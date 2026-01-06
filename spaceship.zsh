SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps (optional)
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (status, prefix, branch, etc.)
  package       # Package version (npm/python/etc)
  node          # Node.js section
  python        # Python section
  docker        # Docker section
  venv          # virtualenv section
  exec_time     # Execution time
  line_sep      # Line break for two-line prompt
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character (the '➜')
)

# 2. General Appearance
SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_PROMPT_SEPARATE_LINE=true # Ensures the input starts on a new line
SPACESHIP_CHAR_SYMBOL="❯ "
SPACESHIP_CHAR_SUFFIX=" "

# 3. Directory (Better contrast for transparent backgrounds)
SPACESHIP_DIR_TRUNC=3
SPACESHIP_DIR_TRUNC_REPO=true
SPACESHIP_DIR_COLOR="cyan"

# 4. Git (Clean and simple)
SPACESHIP_GIT_SYMBOL=" "
SPACESHIP_GIT_BRANCH_COLOR="magenta"
SPACESHIP_GIT_STATUS_COLOR="red"

# 5. Execution Time (Only shows if command takes > 2s)
SPACESHIP_EXEC_TIME_ELAPSED=2
SPACESHIP_EXEC_TIME_COLOR="yellow"

# 6. User/Host (Hidden by default, shows only over SSH)
SPACESHIP_USER_SHOW="needed"
SPACESHIP_HOST_SHOW="needed"
