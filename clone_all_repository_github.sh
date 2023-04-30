#!/bin/bash

function clean_path_repo {
    local PATH_REPO_1=${1#*-}
    local PATH_REPO_2=${PATH_REPO_1%.*}
    PATH_REPO_3=${PATH_REPO_2%-*}
}

function clone_repo {
    clean_path_repo $1
    local ORGA_NAME=${1%/*}
    local BASE_CLONE_CMD='gh repo clone path_replace orga_repl/mod_rep_repl/prjt_rep_repl'
    local PROJET_NAME=${PATH_REPO_3##*-}
    local MODULE_NAME=${PATH_REPO_3%%-*}
    if [ -v HASHMAP_DIR[$MODULE_NAME] ]; then
        MODULE_NAME=${HASHMAP_DIR[$MODULE_NAME]}
    fi
    local REPL_ORGA="${BASE_CLONE_CMD/orga_repl/$ORGA_NAME}"
    local REPL_PATH="${REPL_ORGA/path_replace/$PATH_REPO}"
    local REPL_MODULE="${REPL_PATH/mod_rep_repl/$MODULE_NAME}"
    local REPL_PROJET="${REPL_MODULE/prjt_rep_repl/$PROJET_NAME}"
    echo $REPL_PROJET
    echo $($REPL_PROJET)
}

# PATH_REPO='EpitechPromo2026/B-CPE-100-MLH-1-1-cpoolday01-thomas.ott'

# PATH='EpitechPromo2026/B-MUL-200-MLH-2-1-myrpg-martin.d-herouville'
declare -A HASHMAP_DIR

SHORT="o:,d:,h"
LONG="orga:,directory:,help"
OPTS=$(getopt --alternative --name clone_all --options $SHORT --longoptions $LONG -- "$@")
eval set -- "$OPTS"

while :
do
    case "$1" in
        -o | --orga )
            ORGA_NAME="$2"
            shift 2
            ;;
        -d | --directory )
            if [ $(echo $2 | grep -o ' ' | wc -l) != 1 ]; then
                echo "Unexpected argument, please use -o \"old_repo_name new_repo_name\""
                exit 84
            fi
            OLD_REPO_NAME=${2% *}
            NEW_REPO_NAME=${2#* }
            HASHMAP_DIR[$OLD_REPO_NAME]=$NEW_REPO_NAME
            shift 2
            ;;
        -h | --help)
            echo "Help function"
            exit 0
            ;;
        --)
            shift;
            break
            ;;
        *)
            echo "Unexpected option: $1. -h for help"
            ;;
    esac
done

if [ -z "$ORGA_NAME" ]; then
    echo "Organisation missed, please add -o argument"
    exit 0
fi

echo $ORGA_NAME

# for PATH_REPO in $(gh repo list "EpitechPromo2026" -L 10000000 | cut -d $'\t' -f 1)
for PATH_REPO in $(gh repo list $ORGA_NAME -L 10000000 | cut -d $'\t' -f 1)
do
    clone_repo $PATH_REPO $HASHMAP_DIR
done
