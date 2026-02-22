#!/bin/bash
DRY_RUN=false
# as the loops
# args passed via terminal will counter in position
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
fi
#WORK_DIR="$PWD"
# the locate of the script
# 1. init a subshell
# 2. dirname will get the name of the script given by BASH_SOURCE[0]
# 3. cd will change to the dirname from 2 and pwd will trigger an echo
# 4. use &> to throw any stdout to void
# 5. pwd get the path string, we will use it.
# 6. each -- space is used to give a literal path to the previous command
# 6. this also protect agains files and dirs that starts with -
WORK_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
TARGET_DIR="$HOME/.config"
IGNORED_FILES=("aliases.zsh" "sway" ".git" ".gitignore" "README.md" "wallpapers" $(basename -- "${BASH_SOURCE[0]}"))
TO_HOME=(".zshrc")
#fallback
mkdir -p "$TARGET_DIR"
# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
echo -e "${BLUE}Starting Symlink automation...${NC}"
if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}>>> MODE: DRY RUN (No changes will be made)${NC}\n"
fi
check_ignore() {
    # to use an args we just need to indicate the var
    # the var is passed using positional refenrences
    # $1, $2, $3 etc...
    for f in "${IGNORED_FILES[@]}"; do
        # the args must be spaced from the []
        # bash uses 0 for true and 1 for false
        if [[ "$f" = "$1" ]]; then
            return 0
        fi
    done
    return 1
}
create_links() {
    #this will create symlinks
    # and if the directory exists
    # will create a backup for it
    # create backup
    local parent="$1"
    local link="$2"

    FILE_PATH="$parent/$link"
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)

    if [[ -e "$FILE_PATH" ]]; then
        if [[ -L "$FILE_PATH" ]]; then
            echo -e "${RED}[DRY_RUN] Removing existing symlink: $FILE_PATH${NC}"
            [ "$DRY_RUN" = false ] && rm "$FILE_PATH"
        else
            echo -e "${RED}Found existing file. Backing up to ${FILE_PATH}.bak_${TIMESTAMP}${NC}"
            if [ "$DRY_RUN" = false ]; then
                mv "$FILE_PATH" "${FILE_PATH}.bak_${TIMESTAMP}"
            fi
        fi
    fi

    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY-RUN] Would link: $WORK_DIR/$link -> $FILE_PATH${NC}"
    else
        ln -s "$WORK_DIR/$link" "$FILE_PATH"
        echo -e "${GREEN}Symlink created for: $link${NC}"
    fi
}
# colect all subdirectories on this path
# * used without "" indicates all files on the current dir
# current dir can be saw using pwd
# enter and exit from WORK_DIR to use * properly
cd "$WORK_DIR" || exit

# process items and create links to a destination

process_items() {
    local destination="$1"
    local description="$2"
    # remove $1 and $2 so $@ can get all the itens from *
    # * returns an array with all the files on our WORK_DIR
    shift 2
    local items=("$@")
    
    echo -e "\n${BLUE}Processing $description...${NC}"
    for item in "${items[@]}"; do
        # in this case we will not use [[]]
        # [[]] is used for expression comparison
        # here, we will only get the bool value
        if check_ignore "$item"; then
            echo -e "${NC}Ignoring: $item${NC}"
            continue
        fi
        create_links "$destination" "$item"
    done
}

# Link to .config
process_items "$TARGET_DIR" ".config directory" *

# Link to home
process_items "$HOME" "home directory" "${TO_HOME[@]}"

# to add new path we can create a list
# files=("file1" "file2" "file3")
# process_items "destination" "destination directory" "${files[@]}"


echo -e "\n${GREEN}Done!${NC}"

# -e: Checks if a file exists
# -d: Checks if a directory exists
# -f: Checks if a file is a regular file
# -s: Checks if a file is not empty
