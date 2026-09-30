# /etc/nushell/config.nu
# System-wide Nushell configuration (Gruvbox Light Workstation)

$env.config = {
    show_banner: false
    buffer_editor: "hx"
    edit_mode: "vi"
    cursor_shape: {
        vi_insert: "line"
        vi_normal: "block"
    }
    table: {
        mode: "rounded"
        index_mode: "auto"
        show_empty: true
        trim: {
            methodology: "wrapping"
            wrapping_try_keep_words: true
        }
    }
    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
    }
    color_config: {
        separator: "#7c6f64"
        leading_trailing_space_bg: { attr: "n" }
        header: { fg: "#3c3836" attr: "b" }
        empty: "#458588"
        bool: "#b16286"
        int: "#b16286"
        filesize: "#689d6a"
        duration: "#d79921"
        date: "#d79921"
        range: "#7c6f64"
        float: "#b16286"
        string: "#3c3836"
        nothing: "#928374"
        binary: "#b16286"
        cell-path: "#3c3836"
        row_index: { fg: "#928374" attr: "b" }
        record: "#3c3836"
        list: "#3c3836"
        block: "#3c3836"
        hints: "#928374"
        search_result: { fg: "#181818" bg: "#f4bf75" }
        shape_and: "#b16286"
        shape_binary: "#b16286"
        shape_block: "#458588"
        shape_bool: "#b16286"
        shape_closure: "#458588"
        shape_custom: "#98971a"
        shape_datetime: "#d79921"
        shape_directory: { fg: "#458588" attr: "b" }
        shape_external: "#458588"
        shape_external_resolved: "#458588"
        shape_externalarg: "#3c3836"
        shape_filepath: "#458588"
        shape_flag: { fg: "#076678" attr: "b" }
        shape_float: "#b16286"
        shape_garbage: { fg: "#fbf1c7" bg: "#cc241d" }
        shape_glob_interpolation: "#689d6a"
        shape_globpattern: "#689d6a"
        shape_int: "#b16286"
        shape_internalcall: "#458588"
        shape_keyword: "#b16286"
        shape_list: "#3c3836"
        shape_literal: "#3c3836"
        shape_match_pattern: "#98971a"
        shape_matching_brackets: { attr: "u" }
        shape_nothing: "#928374"
        shape_operator: "#d79921"
        shape_or: "#b16286"
        shape_pipe: "#b16286"
        shape_range: "#d79921"
        shape_record: "#3c3836"
        shape_redirection: "#b16286"
        shape_signature: { fg: "#98971a" attr: "b" }
        shape_string: "#98971a"
        shape_string_interpolation: "#689d6a"
        shape_table: { fg: "#458588" attr: "b" }
        shape_variable: "#076678"
        shape_vardecl: "#076678"
    }
}
