# Requires https://github.com/tmux-plugins/tmux-cpu

show_ram() {
    tmux set-option -g @ram_low_bg_color "$thm_yellow"
    tmux set-option -g @ram_medium_bg_color "$thm_orange"
    tmux set-option -g @ram_high_bg_color "$thm_red"

    local index=$1
    local icon=$(get_tmux_option "@catppuccin_ram_icon", "#{ram_icon}")
    local color=$(get_tmux_option "@catppuccin_ram_color", "#{ram_bg_color}")
    local text=$(get_tmux_option "@catppuccin_ram_text", "#{ram_percentage}")

    local module=$( build_status_module "$index" "$icon" "$color" "$text" )

    echo "$module"
}
