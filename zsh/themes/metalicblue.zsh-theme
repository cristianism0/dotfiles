# vim:ft=zsh ts=2 sw=2 sts=2
#
# MetalicBlue Theme - based on agnoster's Theme
# https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH with a metalic blue palette
# Performance-optimized version:
#   - zstyle/autoload moved out of prompt functions (run once, not per prompt)
#   - Git dirty check replaced with faster porcelain variant
#   - wc -l replaced with zsh built-in jobstates
#   - sed in prompt_git_relative replaced with zsh parameter expansion
#   - git directory check cached per $PWD to avoid redundant subprocesses
#   - bzr/hg early-exit guards added

### Segment drawing
CURRENT_BG='NONE'

CURRENT_FG='153'
CURRENT_DEFAULT_FG='153'

### Theme Color Configuration
: ${METALICBLUE_DIR_FG:='153'}
: ${METALICBLUE_DIR_BG:='235'}

: ${METALICBLUE_CONTEXT_FG:='111'}
: ${METALICBLUE_CONTEXT_BG:='234'}

: ${METALICBLUE_GIT_CLEAN_FG:='234'}
: ${METALICBLUE_GIT_CLEAN_BG:='111'}

: ${METALICBLUE_GIT_DIRTY_FG:='234'}
: ${METALICBLUE_GIT_DIRTY_BG:='67'}

: ${METALICBLUE_BZR_CLEAN_FG:='234'}
: ${METALICBLUE_BZR_CLEAN_BG:='111'}
: ${METALICBLUE_BZR_DIRTY_FG:='234'}
: ${METALICBLUE_BZR_DIRTY_BG:='67'}

: ${METALICBLUE_HG_NEWFILE_FG:='153'}
: ${METALICBLUE_HG_NEWFILE_BG:='25'}
: ${METALICBLUE_HG_CHANGED_FG:='234'}
: ${METALICBLUE_HG_CHANGED_BG:='67'}
: ${METALICBLUE_HG_CLEAN_FG:='234'}
: ${METALICBLUE_HG_CLEAN_BG:='111'}

: ${METALICBLUE_VENV_FG:='234'}
: ${METALICBLUE_VENV_BG:='111'}

: ${METALICBLUE_AWS_PROD_FG:='153'}
: ${METALICBLUE_AWS_PROD_BG:='25'}
: ${METALICBLUE_AWS_FG:='234'}
: ${METALICBLUE_AWS_BG:='67'}

: ${METALICBLUE_STATUS_RETVAL_FG:='111'}
: ${METALICBLUE_STATUS_ROOT_FG:='153'}
: ${METALICBLUE_STATUS_JOB_FG:='67'}
: ${METALICBLUE_STATUS_FG:='153'}
: ${METALICBLUE_STATUS_BG:='234'}

## Non-Color settings
: ${METALICBLUE_STATUS_RETVAL_NUMERIC:=false}
: ${METALICBLUE_GIT_INLINE:=false}
: ${METALICBLUE_GIT_BRANCH_STATUS:=true}

# ─────────────────────────────────────────────────────────────
# PERF: Load vcs_info and zstyle ONCE at theme init, not per prompt
# ─────────────────────────────────────────────────────────────
autoload -Uz vcs_info
setopt promptsubst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '✚'
zstyle ':vcs_info:*' unstagedstr '±'
zstyle ':vcs_info:*' formats ' %u%c'
zstyle ':vcs_info:*' actionformats ' %u%c'

# Powerline separator
() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  SEGMENT_SEPARATOR=$'\ue0b0'
}

# ─────────────────────────────────────────────────────────────
# PERF: Git info cache — recomputed only when $PWD changes
# ─────────────────────────────────────────────────────────────
_mf_git_cache_pwd=""
_mf_git_inside_worktree=""
_mf_git_repo_path=""

_mf_refresh_git_cache() {
  if [[ "$PWD" != "$_mf_git_cache_pwd" ]]; then
    _mf_git_cache_pwd="$PWD"
    _mf_git_inside_worktree=$(command git rev-parse --is-inside-work-tree 2>/dev/null)
    _mf_git_repo_path=$(command git rev-parse --git-dir 2>/dev/null)
  fi
}

# ─────────────────────────────────────────────────────────────
# PERF: Faster dirty check — stops at first dirty file
# ─────────────────────────────────────────────────────────────
_mf_git_dirty() {
  command git status --porcelain --ignore-submodules=dirty 2>/dev/null | head -n1
}

### Segment drawing

prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

prompt_end_line1() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

git_toplevel() {
  local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -z $repo_root ]]; then
    repo_root=$(git rev-parse --git-dir 2>/dev/null)
    [[ $repo_root == '.' ]] && repo_root=$PWD
  fi
  echo -n $repo_root
}

### Prompt components

prompt_context() {
  if [[ "$USERNAME" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment "$METALICBLUE_CONTEXT_BG" "$METALICBLUE_CONTEXT_FG" "%(!.%{%F{$METALICBLUE_STATUS_ROOT_FG}%}.)%n@%m"
  fi
}

prompt_git_relative() {
  local repo_root=$(git_toplevel)
  # PERF: zsh parameter expansion instead of sed subprocess
  local path_in_repo="${PWD#${repo_root}}"
  path_in_repo="${path_in_repo#/}"
  [[ -n $path_in_repo ]] && prompt_segment "$METALICBLUE_DIR_BG" "$METALICBLUE_DIR_FG" "$path_in_repo"
}

prompt_git() {
  (( $+commands[git] )) || return
  [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]] && return

  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=$'\ue0a0'
  }
  local ref dirty mode

  # PERF: Use cached git state instead of re-running rev-parse
  _mf_refresh_git_cache

  if [[ "$_mf_git_inside_worktree" = "true" ]]; then
    dirty=$(_mf_git_dirty)
    ref=$(command git symbolic-ref HEAD 2>/dev/null) || \
    ref="◈ $(command git describe --exact-match --tags HEAD 2>/dev/null)" || \
    ref="➦ $(command git rev-parse --short HEAD 2>/dev/null)"

    if [[ -n $dirty ]]; then
      prompt_segment "$METALICBLUE_GIT_DIRTY_BG" "$METALICBLUE_GIT_DIRTY_FG"
    else
      prompt_segment "$METALICBLUE_GIT_CLEAN_BG" "$METALICBLUE_GIT_CLEAN_FG"
    fi

    if [[ $METALICBLUE_GIT_BRANCH_STATUS == 'true' ]]; then
      local ahead behind
      ahead=$(command git log --oneline @{upstream}.. 2>/dev/null)
      behind=$(command git log --oneline ..@{upstream} 2>/dev/null)
      if [[ -n "$ahead" && -n "$behind" ]]; then
        PL_BRANCH_CHAR=$'\u21c5'
      elif [[ -n "$ahead" ]]; then
        PL_BRANCH_CHAR=$'\u21b1'
      elif [[ -n "$behind" ]]; then
        PL_BRANCH_CHAR=$'\u21b0'
      fi
    fi

    local repo_path="$_mf_git_repo_path"
    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || \
            -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    vcs_info
    echo -n "${${ref:gs/%/%%}/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
    [[ $METALICBLUE_GIT_INLINE == 'true' ]] && prompt_git_relative
  fi
}

prompt_bzr() {
  (( $+commands[bzr] )) || return
  # PERF: quick check before expensive directory walk
  command bzr root &>/dev/null || return

  local dir="$PWD"
  while [[ ! -d "$dir/.bzr" ]]; do
    [[ "$dir" = "/" ]] && return
    dir="${dir:h}"
  done

  local bzr_status status_mod status_all revision
  if bzr_status=$(command bzr status 2>&1); then
    status_mod=$(echo -n "$bzr_status" | head -n1 | grep "modified" | wc -m)
    status_all=$(echo -n "$bzr_status" | head -n1 | wc -m)
    revision=${$(command bzr log -r-1 --log-format line | cut -d: -f1):gs/%/%%}
    if [[ $status_mod -gt 0 ]]; then
      prompt_segment "$METALICBLUE_BZR_DIRTY_BG" "$METALICBLUE_BZR_DIRTY_FG" "bzr@$revision ✚"
    elif [[ $status_all -gt 0 ]]; then
      prompt_segment "$METALICBLUE_BZR_DIRTY_BG" "$METALICBLUE_BZR_DIRTY_FG" "bzr@$revision"
    else
      prompt_segment "$METALICBLUE_BZR_CLEAN_BG" "$METALICBLUE_BZR_CLEAN_FG" "bzr@$revision"
    fi
  fi
}

prompt_hg() {
  (( $+commands[hg] )) || return
  # PERF: quick check before running hg id
  command hg root &>/dev/null || return

  local rev st branch
  if $(command hg id >/dev/null 2>&1); then
    if $(command hg prompt >/dev/null 2>&1); then
      if [[ $(command hg prompt "{status|unknown}") = "?" ]]; then
        prompt_segment "$METALICBLUE_HG_NEWFILE_BG" "$METALICBLUE_HG_NEWFILE_FG"
        st='±'
      elif [[ -n $(command hg prompt "{status|modified}") ]]; then
        prompt_segment "$METALICBLUE_HG_CHANGED_BG" "$METALICBLUE_HG_CHANGED_FG"
        st='±'
      else
        prompt_segment "$METALICBLUE_HG_CLEAN_BG" "$METALICBLUE_HG_CLEAN_FG"
      fi
      echo -n ${$(command hg prompt "☿ {rev}@{branch}"):gs/%/%%} $st
    else
      st=""
      rev=$(command hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
      branch=$(command hg id -b 2>/dev/null)
      if command hg st | command grep -q "^\?"; then
        prompt_segment "$METALICBLUE_HG_NEWFILE_BG" "$METALICBLUE_HG_NEWFILE_FG"
        st='±'
      elif command hg st | command grep -q "^[MA]"; then
        prompt_segment "$METALICBLUE_HG_CHANGED_BG" "$METALICBLUE_HG_CHANGED_FG"
        st='±'
      else
        prompt_segment "$METALICBLUE_HG_CLEAN_BG" "$METALICBLUE_HG_CLEAN_FG"
      fi
      echo -n "☿ ${rev:gs/%/%%}@${branch:gs/%/%%}" $st
    fi
  fi
}

prompt_dir() {
  if [[ $METALICBLUE_GIT_INLINE == 'true' ]] && $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    prompt_segment "$METALICBLUE_DIR_BG" "$METALICBLUE_DIR_FG" "$(git_toplevel | sed "s:^$HOME:~:")"
  else
    prompt_segment "$METALICBLUE_DIR_BG" "$METALICBLUE_DIR_FG" '%~'
  fi
}

prompt_virtualenv() {
  if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
    prompt_segment '25' "$METALICBLUE_VENV_FG" "🐍 $CONDA_DEFAULT_ENV"
  fi
  if [[ -n "$VIRTUAL_ENV" && -n "$VIRTUAL_ENV_DISABLE_PROMPT" ]]; then
    prompt_segment "$METALICBLUE_VENV_BG" "$METALICBLUE_VENV_FG" "(${VIRTUAL_ENV:t:gs/%/%%})"
  fi
}

prompt_status() {
  local -a symbols

  if [[ $METALICBLUE_STATUS_RETVAL_NUMERIC == 'true' ]]; then
    [[ $RETVAL -ne 0 ]] && symbols+="%{%F{$METALICBLUE_STATUS_RETVAL_FG}%}$RETVAL"
  else
    [[ $RETVAL -ne 0 ]] && symbols+="%{%F{$METALICBLUE_STATUS_RETVAL_FG}%}✘"
  fi
  [[ $UID -eq 0 ]] && symbols+="%{%F{$METALICBLUE_STATUS_ROOT_FG}%}⚡"
  # PERF: zsh built-in jobstates instead of spawning wc -l subprocess
  [[ -n ${(k)jobstates} ]] && symbols+="%{%F{$METALICBLUE_STATUS_JOB_FG}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment "$METALICBLUE_STATUS_BG" "$METALICBLUE_STATUS_FG" "$symbols"
}

prompt_aws() {
  [[ -z "$AWS_PROFILE" || "$SHOW_AWS_PROMPT" = false ]] && return
  case "$AWS_PROFILE" in
    *-prod|*production*) prompt_segment "$METALICBLUE_AWS_PROD_BG" "$METALICBLUE_AWS_PROD_FG" "AWS: ${AWS_PROFILE:gs/%/%%}" ;;
    *) prompt_segment "$METALICBLUE_AWS_BG" "$METALICBLUE_AWS_FG" "AWS: ${AWS_PROFILE:gs/%/%%}" ;;
  esac
}

prompt_terraform() {
  local terraform_info=$(tf_prompt_info 2>/dev/null)
  [[ -z "$terraform_info" ]] && return
  prompt_segment '25' '153' "TF: $terraform_info"
}

# ─────────────────────────────────────────────────────────────
# Two-line prompt build
# Line 1: [status][context][dir][git/vcs...]
# Line 2: ❯
# ─────────────────────────────────────────────────────────────
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  prompt_aws
  prompt_terraform
  prompt_context
  prompt_dir
  prompt_git
  prompt_bzr
  prompt_hg
  prompt_end_line1
  echo -n "\n%{%F{111}%}❯%{%f%}"
}

PROMPT='%{%f%b%k%}$(build_prompt) '
