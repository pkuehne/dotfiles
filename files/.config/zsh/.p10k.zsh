# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

  typeset -gA _thm=(
    bg      '#282a36'
    fg      '#f8f8f2'
    grey    '#44475a'
    dim     '#6272a4'
    cyan    '#8be9fd'
    green   '#50fa7b'
    orange  '#ffb86c'
    pink    '#ff79c6'
    purple  '#bd93f9'
    red     '#ff5555'
    yellow  '#f1fa8c'
  )

  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon
    dir
    vcs
    newline
    prompt_char
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    command_execution_time  # duration of the last command
    background_jobs         # presence of background jobs
    status                  # exit code of the last command
    justfile                # a justfile governs this directory
    mise                    # a mise config governs this directory
    context                 # user@hostname, shown only over ssh or as root
  )

  typeset -g POWERLEVEL9K_MODE=nerdfont-v3
  typeset -g POWERLEVEL9K_ICON_PADDING=none
  typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=

  # Layout
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

  # Multiline connectors
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX="%F{${_thm[dim]}}─╮"
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX="%F{${_thm[dim]}}─┤"
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX="%F{${_thm[dim]}}─╯"

  # Gap filler
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR='─'
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_BACKGROUND=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_GAP_BACKGROUND=
  if [[ $POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR != ' ' ]]; then
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND="${_thm[dim]}"
    typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_FIRST_SEGMENT_END_SYMBOL='%{%}'
    typeset -g POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='%{%}'
  fi

  # Separators
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='\uE0B1'
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='\uE0B3'
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR='\uE0B0'
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR='\uE0B2'
  typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL='\uE0B0'
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\uE0B2'
  typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=

  #################################[ os_icon: os identifier ]##################################
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND="${_thm[bg]}"
  typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND="${_thm[fg]}"

  ################################[ prompt_char: prompt symbol ]################################
  typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND="${_thm[green]}"
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND="${_thm[red]}"
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_{LEFT,RIGHT}_WHITESPACE=

  ##################################[ dir: current directory ]##################################
  typeset -g POWERLEVEL9K_DIR_BACKGROUND="${_thm[purple]}"
  typeset -g POWERLEVEL9K_DIR_FOREGROUND="${_thm[bg]}"
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND="${_thm[grey]}"
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND="${_thm[bg]}"
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  local anchor_files=(
    .bzr
    .citc
    .git
    .hg
    .node-version
    .python-version
    .go-version
    .ruby-version
    .lua-version
    .java-version
    .perl-version
    .php-version
    .tool-versions
    .shorten_folder_marker
    .svn
    .terraform
    CVS
    Cargo.toml
    composer.json
    go.mod
    package.json
    stack.yaml
  )
  typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER="(${(j:|:)anchor_files})"
  typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3

  #####################################[ vcs: git status ]######################################
  typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND="${_thm[green]}"
  typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="${_thm[yellow]}"
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="${_thm[green]}"
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND="${_thm[red]}"
  typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND="${_thm[dim]}"
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\uF126 '
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

  function my_git_formatter() {
    emulate -L zsh

    if [[ -n $P9K_CONTENT ]]; then
      typeset -g my_git_format=$P9K_CONTENT
      return
    fi

    local       meta="%F{${_thm[grey]}}"
    local      clean="%F{${_thm[bg]}}"
    local   modified="%F{${_thm[bg]}}"
    local  untracked="%F{${_thm[bg]}}"
    local conflicted="%F{${_thm[bg]}}"

    local res

    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      local branch=${(V)VCS_STATUS_LOCAL_BRANCH}
      (( $#branch > 32 )) && branch[13,-13]="…"
      res+="${clean}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${branch//\%/%%}"
    fi

    if [[ -n $VCS_STATUS_TAG && -z $VCS_STATUS_LOCAL_BRANCH ]]; then
      local tag=${(V)VCS_STATUS_TAG}
      (( $#tag > 32 )) && tag[13,-13]="…"
      res+="${meta}#${clean}${tag//\%/%%}"
    fi

    [[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] &&
      res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,8]}"

    if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
      res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"
    fi

    if [[ $VCS_STATUS_COMMIT_SUMMARY == (|*[^[:alnum:]])(wip|WIP)(|[^[:alnum:]]*) ]]; then
      res+=" ${modified}wip"
    fi

    if (( VCS_STATUS_COMMITS_AHEAD || VCS_STATUS_COMMITS_BEHIND )); then
      (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
      (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
      (( VCS_STATUS_COMMITS_AHEAD  )) && res+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
    fi

    (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" ${clean}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
    (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && res+="${clean}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
    (( VCS_STATUS_STASHES        )) && res+=" ${clean}*${VCS_STATUS_STASHES}"
    [[ -n $VCS_STATUS_ACTION     ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"
    (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
    (( VCS_STATUS_NUM_STAGED     )) && res+=" ${modified}+${VCS_STATUS_NUM_STAGED}"
    (( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
    (( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"
    (( VCS_STATUS_HAS_UNSTAGED == -1 )) && res+=" ${modified}─"

    typeset -g my_git_format=$res
  }
  functions -M my_git_formatter 2>/dev/null

  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1
  typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter()))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

  ##########################[ status: exit code of the last command ]###########################
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_BACKGROUND="${_thm[bg]}"
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND="${_thm[yellow]}"
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION=
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_CONTENT_EXPANSION="%K{${_thm[bg]}}%F{${_thm[yellow]}}%K{${_thm[yellow]}}%F{${_thm[bg]}}\${P9K_CONTENT}%K{${_thm[bg]}}%F{${_thm[yellow]}}%f"
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_RIGHT_SUBSEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_WHITESPACE_BETWEEN_RIGHT_SEGMENTS=
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_{ERROR,ERROR_SIGNAL,ERROR_PIPE}_BACKGROUND="${_thm[bg]}"
  typeset -g POWERLEVEL9K_STATUS_{ERROR,ERROR_SIGNAL,ERROR_PIPE}_FOREGROUND="${_thm[red]}"
  typeset -g POWERLEVEL9K_STATUS_{ERROR,ERROR_SIGNAL,ERROR_PIPE}_VISUAL_IDENTIFIER_EXPANSION=
  typeset -g POWERLEVEL9K_STATUS_{ERROR,ERROR_SIGNAL,ERROR_PIPE}_CONTENT_EXPANSION="%K{${_thm[bg]}}%F{${_thm[red]}}%K{${_thm[red]}}%F{${_thm[bg]}}\${P9K_CONTENT}%K{${_thm[bg]}}%F{${_thm[red]}}%f"
  typeset -g POWERLEVEL9K_STATUS_{ERROR,ERROR_SIGNAL,ERROR_PIPE}_RIGHT_SUBSEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_STATUS_{ERROR,ERROR_SIGNAL,ERROR_PIPE}_WHITESPACE_BETWEEN_RIGHT_SEGMENTS=
  typeset -g POWERLEVEL9K_STATUS_{ERROR,ERROR_SIGNAL,ERROR_PIPE}_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true

  ###################[ command_execution_time: duration of the last command ]###################
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="${_thm[bg]}"
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="${_thm[yellow]}"
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION=
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_CONTENT_EXPANSION="%K{${_thm[bg]}}%F{${_thm[yellow]}}%K{${_thm[yellow]}}%F{${_thm[bg]}}\${P9K_CONTENT}%K{${_thm[bg]}}%F{${_thm[yellow]}}%f"
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_RIGHT_SUBSEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_WHITESPACE_BETWEEN_RIGHT_SEGMENTS=
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'

  #######################[ background_jobs: presence of background jobs ]#######################
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND="${_thm[bg]}"
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND="${_thm[purple]}"
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION=
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_CONTENT_EXPANSION="%K{${_thm[bg]}}%F{${_thm[purple]}}%K{${_thm[purple]}}%F{${_thm[bg]}}%K{${_thm[bg]}}%F{${_thm[purple]}}%f"
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_RIGHT_SUBSEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_WHITESPACE_BETWEEN_RIGHT_SEGMENTS=
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false

  ##################################[ context: user@hostname ]##################################
  typeset -g POWERLEVEL9K_CONTEXT_{ROOT,REMOTE,REMOTE_SUDO}_BACKGROUND="${_thm[bg]}"
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="${_thm[red]}"
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND="${_thm[yellow]}"
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_CONTENT_EXPANSION="%K{${_thm[bg]}}%F{${_thm[red]}}%K{${_thm[red]}}%F{${_thm[bg]}}\${P9K_CONTENT}%K{${_thm[bg]}}%F{${_thm[red]}}%f"
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_CONTENT_EXPANSION="%K{${_thm[bg]}}%F{${_thm[yellow]}}%K{${_thm[yellow]}}%F{${_thm[bg]}}\${P9K_CONTENT}%K{${_thm[bg]}}%F{${_thm[yellow]}}%f"
  typeset -g POWERLEVEL9K_CONTEXT_{ROOT,REMOTE,REMOTE_SUDO}_RIGHT_SUBSEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_CONTEXT_{ROOT,REMOTE,REMOTE_SUDO}_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  typeset -g POWERLEVEL9K_CONTEXT_{ROOT,REMOTE,REMOTE_SUDO}_WHITESPACE_BETWEEN_RIGHT_SEGMENTS=
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_TEMPLATE='%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=

  ###############################[ justfile: just recipes here ]################################
  typeset -g POWERLEVEL9K_JUSTFILE_RIGHT_SUBSEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_JUSTFILE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  typeset -g POWERLEVEL9K_JUSTFILE_WHITESPACE_BETWEEN_RIGHT_SEGMENTS=
  typeset -g POWERLEVEL9K_MISE_RIGHT_SUBSEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_MISE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  typeset -g POWERLEVEL9K_MISE_WHITESPACE_BETWEEN_RIGHT_SEGMENTS=
  function prompt_justfile() {
    _p9k_upglob '(justfile|Justfile|.justfile|JUSTFILE)' -. && return
    p10k segment -b "${_thm[bg]}" -e -t "%K{${_thm[bg]}}%F{${_thm[orange]}}%K{${_thm[orange]}}%F{${_thm[bg]}}%K{${_thm[bg]}}%F{${_thm[orange]}}%f"
  }

  ###############################[ mise: mise config applies here ]#############################
  function prompt_mise() {
    _p9k_upglob '((mise|.mise|mise.local|.mise.local).toml|.tool-versions)' -. &&
      _p9k_upglob '(.mise|mise)/config.toml' -. && return
    p10k segment -b "${_thm[bg]}" -e -t "%K{${_thm[bg]}}%F{${_thm[cyan]}}%K{${_thm[cyan]}}%F{${_thm[bg]}}%K{${_thm[bg]}}%F{${_thm[cyan]}}%f"
  }

  # Transient prompt
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

  # Instant prompt mode
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

  # Hot reload
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  (( ! $+functions[p10k] )) || p10k reload
}

typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
