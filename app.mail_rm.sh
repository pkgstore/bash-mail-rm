#!/usr/bin/env -S bash -eu
# -------------------------------------------------------------------------------------------------------------------- #
# MAIL: REMOVE
# Scanning and deleting emails by content.
# -------------------------------------------------------------------------------------------------------------------- #
# @package    Bash
# @author     Kai Kimera <mail@kai.kim>
# @license    MIT
# @version    0.1.0
# @link
# -------------------------------------------------------------------------------------------------------------------- #

(( EUID != 0 )) && { echo >&2 'This script should be run as root!'; exit 1; }

# -------------------------------------------------------------------------------------------------------------------- #
# CONFIGURATION
# -------------------------------------------------------------------------------------------------------------------- #

# Sources.
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )"; readonly SRC_DIR
SRC_NAME="$( basename "$( readlink -f "${BASH_SOURCE[0]}" )" )"; readonly SRC_NAME
# shellcheck source=/dev/null
. "${SRC_DIR}/${SRC_NAME%.*}.conf"

# Parameters.
DATA="${DATA:?}"; readonly DATA
SEARCH="${SEARCH:?}"; readonly SEARCH

# -------------------------------------------------------------------------------------------------------------------- #
# -----------------------------------------------------< SCRIPT >----------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

function _error() {
  echo >&2 "[$( date '+%FT%T%z' )]: $*"; exit 1
}

function mail_remove() {
  [[ ! -d "${DATA}" ]] && _error "'${DATA}' not found!"
  while IFS= read -rd '' file; do
    rg -l0 --hidden "${SEARCH}" "${file}" | xargs -0 rm -f --
  done < <( find "${DATA}" -type 'f' -mtime "-${DAYS:-7}" -print0 )
}

function main() {
  mail_remove
}; main "$@"
