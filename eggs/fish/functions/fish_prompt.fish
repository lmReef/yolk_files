function fish_prompt --description 'Write out the prompt'
    set -l last_status $status
    set -q fish_prompt_pwd_full_dirs
    or set -lx fish_prompt_pwd_full_dirs (math round 1 + $COLUMNS / 100  )

    # cwd
    set -l cwd (set_color $fish_color_end; prompt_pwd)

    # git / vcs
    set -g __fish_git_prompt_showdirtystate 1
    set -g __fish_git_prompt_showuntrackedfiles 1
    set -g __fish_git_prompt_showupstream informative
    set -g __fish_git_prompt_showcolorhints 1
    set -g __fish_git_prompt_use_informative_chars 1
    # Unfortunately this only works if we have a sensible locale
    string match -qi "*.utf-8" -- $LANG $LC_CTYPE $LC_ALL
    and set -g __fish_git_prompt_char_dirtystate "*"
    set -g __fish_git_prompt_char_untrackedfiles "?"
    # remove leading whitespace
    set -l vcs (set_color normal; fish_vcs_prompt '(%s)' 2>/dev/null)

    # venv
    set -q VIRTUAL_ENV_DISABLE_PROMPT
    or set -g VIRTUAL_ENV_DISABLE_PROMPT true
    set -q VIRTUAL_ENV
    and set -l venv (set_color $fish_color_keyword; string replace ' ' @ (python --version))

    # TODO: mise config get

    # prompt status
    set -l prompt_status ""
    set -l status_color (set_color $fish_color_end)
    if test $last_status -ne 0
        set status_color (set_color $fish_color_error)
        set prompt_status $status_color "[" $last_status "]"
    end

    # duration
    set -l duration "$cmd_duration$CMD_DURATION"
    if test $duration -gt 1000
        set duration (set_color $fish_color_comment) (math --scale=0 $duration / 1000)s
    else
        set duration
    end

    # prompt suffix
    set -l suffix '❯'

    string join -n " " \
        (prompt_login) \
        $cwd \
        $vcs \
        $venv \
        $prompt_status \
        $duration
    echo -n -s $status_color $suffix ' '
    set_color normal
end
