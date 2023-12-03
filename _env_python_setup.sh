#!/usr/bin/env bash
###################################################################################################
#
#   General python environment setup/reset script. Script can be used to re-create python
#   general/global environment from 'scratch' or to get rid of some 'garbage' packages- unnesessary
#   installed modules. After the cleanup, script installs the following basic libraries: pipenv,
#   jupyter, pytest
#
#   This script works under following environments:
#       - MacOS, 10.14+
#       - Windows GitBash/MinGW
#       - TBD -> linux debian
#       - TBD -> linux red hat
#
#   Warning: script must be used (run) from shell, not from the virtual environment (pipenv shell).
#
#   Created:  Dmitrii Gusev, 30.01.2022
#   Modified: Dmitrii Gusev, 26.06.2023
#
###################################################################################################

# -- safe bash scripting
set -euf -o pipefail

# -- general setup - some variables
export LANG='en_US.UTF-8'
TMP_FILE="req.txt"

clear
printf "Python Development Environment setup is starting...\n\n"

# -- setup some commands aliases, depending on the machine type
unameOut="$(uname -s)" # get machine name (short)
# - based on the machine type - setup aliases
case "${unameOut}" in
    Linux*)     MACHINE=Linux; CMD_PYTHON=python3; CMD_PIP=pip3;; # linux
    Darwin*)    MACHINE=Mac; CMD_PYTHON=python3; CMD_PIP=pip3;; # mac
    CYGWIN*)    MACHINE=Cygwin; CMD_PYTHON=python; CMD_PIP=pip;; # win - cygwin emulator
    MINGW*)     MACHINE=MinGW; CMD_PYTHON=python; CMD_PIP=pip;; # win - mingw emulator
    *)          MACHINE="UNKNOWN:${unameOut}"; printf "Unknown machine: %s" "${MACHINE}"; exit 1
esac
# - just a debug output
printf "Machine type: [%s], using python: [%s], using pip: [%s].\n\n" \
    "${MACHINE}" "${CMD_PYTHON}" "${CMD_PIP}"

# -- upgrading pip (just for the case)
printf "\n--- Upgrading PIP (if there are updates) ---\n\n"
# pip --no-cache-dir install --upgrade pip # option I: working but not in a mingw/gitbash
${CMD_PYTHON} -m pip --no-cache-dir install --upgrade pip # this works in mingw/gitbash
printf "\n\n ** upgrading PIP - done **\n"

# -- upgrading setuptools (if there are updates)
printf "\n--- Upgrading SETUPTOOLS (if there are updates) ---\n\n"
${CMD_PYTHON} -m pip --no-cache-dir install --upgrade setuptools
printf "\n\n ** upgrading SETUPTOOLS - done **\n"

# -- freeze current global dependencies
# todo: use user local dependencies? -> for linux
printf "\n\n--- Freezing dependencies to the [%s] file ---\n" ${TMP_FILE}
${CMD_PIP} freeze > ${TMP_FILE}
printf "\n\n ** freezing the current dependencies to the [%s] file - done **\n\n" ${TMP_FILE}

# -- remove (uninstall) all global dependencies, freezed in the file
printf "\n--- Uninstalling dependencies freezed to the [%s] file ---\n\n" ${TMP_FILE}
${CMD_PIP} uninstall -r ${TMP_FILE} -y || printf "Nothing to uninstall!"
printf "\n\n ** uninstalling the current dependencies - done **\n"

# -- list the current empty environment
printf "\n\n--- The Current Empty Environment (no dependencies) ---\n\n"
${CMD_PIP} list
sleep 5

# -- remove temporary file
rm ${TMP_FILE}
printf "\n\n ** removing tmp file %s - done **\n\n" ${TMP_FILE}

# -- install necessary dependencies
printf "\n--- Installing basic/minimal dependencies to the global python environment ---\n\n"
${CMD_PIP} --no-cache-dir install pipenv pytest jupyter
printf "\n\n ** installing core dependencies - done **\n"

printf "\n\nPython Development Environment setup is done.\n\n\n"
