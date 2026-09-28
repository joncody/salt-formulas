use clap::{Parser, Subcommand};
use colored::*;
use regex::Regex;
use serde::Deserialize;
use std::fs;
use tokio::process::Command;

#[derive(Parser)]
#[command(name = "salt-bump")]
#[command(about = "Deterministic updater for SaltStack map.jinja formulas", long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Commands,

    #[arg(short, long, default_value = "updater.toml")]
    config: String,
}

#[derive(Subcommand)]
enum Commands {
    /// Check upstreams for newer versions
    Check,
    /// Update map.jinja files in-place with latest versions
    Update {
        /// Specific package to update (updates all if omitted)
        package: Option<String>,
    },
}

#[derive(Deserialize)]
struct Config {
    packages: Vec<PackageConfig>,
}

#[derive(Deserialize, Clone)]
struct PackageConfig {
    name: String,
    file: String,
    key: String,
    #[serde(rename = "type")]
    source_type: String,
    repo: Option<String>,
}

#[derive(PartialEq)]
enum VersionStatus {
    UpToDate,
    Outdated,
    Ahead,
    Error(String),
}

struct PackageStatus {
    name: String,
    file: String,
    key: String,
    current: String,
    latest: String,
    status: VersionStatus,
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let cli = Cli::parse();
    let config_content = fs::read_to_string(&cli.config)
        .map_err(|e| format!("Could not read {}: {}", cli.config, e))?;
    let config: Config = toml::from_str(&config_content)?;

    let client = reqwest::Client::builder()
        .user_agent("Mozilla/5.0")
        .redirect(reqwest::redirect::Policy::none())
        .build()?;

    match cli.command {
        Commands::Check => {
            println!("{}", "Checking upstreams in parallel...".bold());
            let statuses = check_all(&client, &config.packages).await;
            print_table(&statuses);
        }
        Commands::Update { package } => {
            let statuses = check_all(&client, &config.packages).await;
            for status in statuses {
                if let Some(ref target) = package {
                    if &status.name != target {
                        continue;
                    }
                }

                match status.status {
                    VersionStatus::Outdated => {
                        if let Err(e) = update_file(&status.file, &status.key, &status.latest) {
                            eprintln!("{}: Failed to update {}: {}", "Error".red(), status.file, e);
                        } else {
                            println!(
                                "{} {} ({}) -> {}",
                                "[+] Bumped".green().bold(),
                                status.name.bold(),
                                status.current.yellow(),
                                status.latest.green().bold()
                            );
                        }
                    }
                    VersionStatus::Ahead => {
                        if let Err(e) = update_file(&status.file, &status.key, &status.latest) {
                            eprintln!("{}: Failed to reconcile {}: {}", "Error".red(), status.file, e);
                        } else {
                            println!(
                                "{} {} ({}) -> {}",
                                "[~] Reconciled".cyan().bold(),
                                status.name.bold(),
                                status.current.cyan(),
                                status.latest.green().bold()
                            );
                        }
                    }
                    VersionStatus::UpToDate => {
                        println!("[-] {} is up to date ({})", status.name, status.current);
                    }
                    VersionStatus::Error(e) => {
                        eprintln!("{}: {} - {}", "Error".red(), status.name, e);
                    }
                }
            }
            println!("\nRun {} to review changes before committing.", "git diff".cyan().bold());
        }
    }

    Ok(())
}

async fn check_all(client: &reqwest::Client, packages: &[PackageConfig]) -> Vec<PackageStatus> {
    let mut handles = Vec::new();

    for pkg in packages {
        let client = client.clone();
        let pkg = pkg.clone();
        handles.push(tokio::spawn(async move {
            let current_raw = extract_current_version(&pkg.file, &pkg.key).unwrap_or_else(|_| "missing".to_string());
            let mut latest = fetch_latest(&client, &pkg).await.unwrap_or_else(|e| format!("error: {}", e));

            if !latest.starts_with("error") && !pkg.key.contains("branch") {
                latest = latest.trim_start_matches(['v', 'V']).to_string();
            }

            let current_cmp = if !pkg.key.contains("branch") {
                current_raw.trim_start_matches(['v', 'V']).to_string()
            } else {
                current_raw.clone()
            };

            let status = if current_raw == "missing" || latest.starts_with("error") {
                VersionStatus::Error(latest.clone())
            } else if pkg.key.contains("branch") {
                if current_cmp == latest {
                    VersionStatus::UpToDate
                } else {
                    VersionStatus::Outdated
                }
            } else {
                match natural_cmp(&latest, &current_cmp) {
                    std::cmp::Ordering::Greater => VersionStatus::Outdated,
                    std::cmp::Ordering::Less => VersionStatus::Ahead,
                    std::cmp::Ordering::Equal => VersionStatus::UpToDate,
                }
            };

            PackageStatus {
                name: pkg.name,
                file: pkg.file,
                key: pkg.key,
                current: current_raw,
                latest,
                status,
            }
        }));
    }

    let mut results = Vec::new();
    for handle in handles {
        if let Ok(status) = handle.await {
            results.push(status);
        }
    }
    results.sort_by(|a, b| a.name.cmp(&b.name));
    results
}

fn extract_current_version(path: &str, key: &str) -> Result<String, Box<dyn std::error::Error>> {
    let content = fs::read_to_string(path)?;
    let pattern = format!(r#"['"]{}['"]\s*:\s*['"]([^'"]+)['"]"#, regex::escape(key));
    let re = Regex::new(&pattern)?;
    if let Some(caps) = re.captures(&content) {
        return Ok(caps[1].to_string());
    }
    Err("Key not found in file".into())
}

fn update_file(path: &str, key: &str, new_ver: &str) -> Result<(), Box<dyn std::error::Error>> {
    let content = fs::read_to_string(path)?;
    let pattern = format!(r#"(['"]{}['"]\s*:\s*['"])[^'"]+(['"])"#, regex::escape(key));
    let re = Regex::new(&pattern)?;
    let replaced = re.replace(&content, format!("${{1}}{}${{2}}", new_ver));
    fs::write(path, replaced.as_bytes())?;
    Ok(())
}

fn natural_cmp(a: &str, b: &str) -> std::cmp::Ordering {
    let a_clean = a.trim_start_matches(['v', 'V']);
    let b_clean = b.trim_start_matches(['v', 'V']);

    let re = Regex::new(r"(\d+|\D+)").unwrap();
    let a_tokens: Vec<&str> = re.find_iter(a_clean).map(|m| m.as_str()).collect();
    let b_tokens: Vec<&str> = re.find_iter(b_clean).map(|m| m.as_str()).collect();

    for (x, y) in a_tokens.iter().zip(b_tokens.iter()) {
        if let (Ok(nx), Ok(ny)) = (x.parse::<u64>(), y.parse::<u64>()) {
            if nx != ny {
                return nx.cmp(&ny);
            }
        } else if x != y {
            return x.cmp(y);
        }
    }
    a_tokens.len().cmp(&b_tokens.len())
}

async fn fetch_latest(client: &reqwest::Client, pkg: &PackageConfig) -> Result<String, Box<dyn std::error::Error>> {
    match pkg.source_type.as_str() {
        "github_release" => {
            let repo = pkg.repo.as_ref().ok_or("repo required")?;
            let url = format!("https://github.com/{}/releases/latest", repo);
            let resp = client.get(&url).send().await?;
            if let Some(loc) = resp.headers().get("location") {
                let loc_str = loc.to_str()?;
                let tag = loc_str.rsplit('/').next().ok_or("Invalid location header")?;
                return Ok(tag.to_string());
            }
            Err("No release redirect found".into())
        }
        "github_tag" => {
            let repo = pkg.repo.as_ref().ok_or("repo required")?;
            let output = Command::new("git")
                .args(["ls-remote", "--tags", &format!("https://github.com/{}", repo)])
                .output()
                .await?;
            let stdout = String::from_utf8_lossy(&output.stdout);

            let valid_ver_regex = Regex::new(r"^v?[0-9]+\.[0-9]+(\.[0-9]+)?.*$").unwrap();

            let mut valid_tags: Vec<String> = stdout
                .lines()
                .filter_map(|line| line.split("refs/tags/").nth(1))
                .map(|t| t.trim_end_matches("^{}"))
                .filter(|name| valid_ver_regex.is_match(name))
                .filter(|name| !name.contains("rc") && !name.contains("alpha") && !name.contains("beta") && !name.contains("pre"))
                .map(|s| s.to_string())
                .collect();

            valid_tags.sort_by(|a, b| natural_cmp(a, b));
            valid_tags.into_iter().last().ok_or("No valid tags found".into())
        }
        "go_api" => {
            let resp: Vec<serde_json::Value> = client.get("https://go.dev/dl/?mode=json").send().await?.json().await?;
            let ver = resp[0]["version"].as_str().ok_or("No Go version found")?;
            Ok(ver.trim_start_matches("go").to_string())
        }
        "node_api" => {
            let resp: Vec<serde_json::Value> = client.get("https://nodejs.org/dist/index.json").send().await?.json().await?;
            let ver = resp[0]["version"].as_str().ok_or("No Node version found")?;
            Ok(ver.trim_start_matches('v').to_string())
        }
        "nginx_branch" => {
            let output = Command::new("git")
                .args(["ls-remote", "--heads", "https://github.com/nginx/nginx"])
                .output()
                .await?;
            let stdout = String::from_utf8_lossy(&output.stdout);

            let mut stable: Vec<String> = stdout
                .lines()
                .filter_map(|line| line.split("refs/heads/").nth(1))
                .filter(|name| {
                    if let Some(rest) = name.strip_prefix("stable-1.") {
                        if let Ok(minor) = rest.split('.').next().unwrap_or("").parse::<u32>() {
                            return minor % 2 == 0;
                        }
                    }
                    false
                })
                .map(|s| s.to_string())
                .collect();

            stable.sort_by(|a, b| natural_cmp(a, b));
            stable.into_iter().last().ok_or("No stable Nginx branch found".into())
        }
        "postgres_branch" => {
            let output = Command::new("git")
                .args(["ls-remote", "--heads", "https://github.com/postgres/postgres"])
                .output()
                .await?;
            let stdout = String::from_utf8_lossy(&output.stdout);

            let mut stable: Vec<String> = stdout
                .lines()
                .filter_map(|line| line.split("refs/heads/").nth(1))
                .filter(|name| name.starts_with("REL_") && name.ends_with("_STABLE"))
                .map(|s| s.to_string())
                .collect();

            stable.sort_by(|a, b| natural_cmp(a, b));
            stable.into_iter().last().ok_or("No stable Postgres branch found".into())
        }
        "ffmpeg_branch" => {
            let output = Command::new("git")
                .args(["ls-remote", "--heads", "https://github.com/FFmpeg/FFmpeg"])
                .output()
                .await?;
            let stdout = String::from_utf8_lossy(&output.stdout);

            let mut rel: Vec<String> = stdout
                .lines()
                .filter_map(|line| line.split("refs/heads/").nth(1))
                .filter(|name| name.starts_with("release/"))
                .map(|s| s.to_string())
                .collect();

            rel.sort_by(|a, b| natural_cmp(a, b));
            rel.into_iter().last().ok_or("No release branch found".into())
        }
        _ => Err("Unsupported source type".into()),
    }
}

fn print_table(statuses: &[PackageStatus]) {
    println!("\n{:<15} {:<18} {:<18} {}", "Package".bold(), "Current".bold(), "Latest".bold(), "Status".bold());
    println!("{}", "─".repeat(60));
    for s in statuses {
        let status_colored = match &s.status {
            VersionStatus::Outdated => "Outdated".yellow().bold(),
            VersionStatus::Ahead => "Ahead".cyan().bold(),
            VersionStatus::UpToDate => "Up to date".green(),
            VersionStatus::Error(_) => "Error".red(),
        };
        println!("{:<15} {:<18} {:<18} {}", s.name, s.current, s.latest, status_colored);
    }
    println!();
}
