#!/usr/bin/env -S bash -euo pipefail
# -------------------------------------------------------------------------------------------------------------------- #
# MAIL: REMOVING
# Script for scanning and deleting files by content.
# -------------------------------------------------------------------------------------------------------------------- #
# @package    Bash
# @author     Kai Kimera
# @license    MIT
# @version    0.1.0
# @link
# -------------------------------------------------------------------------------------------------------------------- #

(( EUID != 0 )) && { echo >&2 'This script should be run as root!'; exit 1; }

# Sources.
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )"; readonly SRC_DIR # Source directory.
SRC_NAME="$( basename "$( readlink -f "${BASH_SOURCE[0]}" )" )"; readonly SRC_NAME # Source name.
# shellcheck source=/dev/null
. "${SRC_DIR}/${SRC_NAME%.*}.conf" # Loading configuration file.

# Parameters.
DATA="${DATA:?}"; readonly DATA
DAYS="${DAYS:?}"; readonly DAYS
SEARCH="${SEARCH:?}"; readonly SEARCH

# -------------------------------------------------------------------------------------------------------------------- #
# -----------------------------------------------------< SCRIPT >----------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

function _err() {
  echo >&2 "[$( date +'%Y-%m-%dT%H:%M:%S%z' )]: $*"; exit 1
}

function cmd_check() {
  for i in 'rg'; do
    [[ ! -x "$( command -v "${i}" )" ]] && { _err "'${i}' is not installed!"; } || return 0
  done
}

function remove() {
  [[ ! -d "${DATA}" ]] && { _err "'${DATA}' not found!"; }
  while IFS= read -rd '' file; do
    rg -l0 --hidden "${SEARCH}" "${file}" | xargs -0 rm -f --
  done < <( find "${DATA}" -type 'f' -mtime "${DAYS}" -print0 )
}

function main() { cmd_check && remove; }; main "$@"
