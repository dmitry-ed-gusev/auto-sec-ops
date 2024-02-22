#!/usr/bin/env bash
###################################################################################################
#
#   General python environment setup/reset script. Script can be used to re-create python
#   general/global environment from 'scratch' or to get rid of some 'garbage' packages- unnecessary
#   installed modules. After the cleanup, script installs the following basic libraries: pipenv,
#   jupyter, pytest, pipx
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
#   Modified: Dmitrii Gusev, 14.02.2024
#
###################################################################################################

# -- safe bash scripting
set -euf -o pipefail

# -- general setup - some variables
export LANG='en_US.UTF-8'
TMP_FILE="req.txt" # for cygwin/mingw

clear
printf "Python Development Environment setup is starting...\n\n"

# -- setup some commands aliases, depending on the machine type
unameOut="$(uname -s)" # get machine name (short)
# - based on the machine type - setup aliases
case "${unameOut}" in
    Linux*)     MACHINE=Linux; CMD_PYTHON=python3; CMD_PIP=pip3;;
    Darwin*)    MACHINE=Mac; CMD_PYTHON=python3; CMD_PIP=pip3;;
    CYGWIN*)    MACHINE=Cygwin; CMD_PYTHON=python; CMD_PIP=pip;;
    MINGW*)     MACHINE=MinGW; CMD_PYTHON=python; CMD_PIP=pip;;
    *)          MACHINE="UNKNOWN:${unameOut}"; printf "Unknown machine: %s" "${MACHINE}"; exit 1
esac
# - just a debug output
printf "Machine type: [%s], using python: [%s], using pip: [%s].\n\n" \
    "${MACHINE}" "${CMD_PYTHON}" "${CMD_PIP}"

# -- upgrading pip + setuptools (main tools, just for the case)
printf "\n--- Upgrading PIP+SETUPTOOLS (if there are updates) ---\n\n"
# pip --no-cache-dir install --upgrade pip # option I: working but not in a mingw/gitbash
${CMD_PYTHON} -m pip --no-cache-dir install --upgrade pip setuptools # option II: works in mingw/gitbash
printf "\n\n ** upgrading PIP+SETUPTOOLS - done **\n"
sleep 2

# -- freeze current global dependencies
if [[ $MACHINE == 'Cygwin' || $MACHINE == 'MinGW' ]]; then # cygwin/mingw

    printf "\n\n--- Cleanup dependencies. ---\n"
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

else # linux/macos

    printf "\n\n--- We're on linux - processing TBD... ---\n"
    # TODO: use user local dependencies? -> for linux

fi

# -- install necessary dependencies
printf "\n--- Installing (if not installed) and upgrading core dependencies to the global env ---\n\n"
${CMD_PIP} --no-cache-dir install pipenv pytest jupyter pipx
${CMD_PIP} --no-cache-dir install --upgrade pipenv pytest jupyter pipx
printf "\n\n ** installing core dependencies - done **\n"

printf "\n\nPython Development Environment setup is done.\n\n\n"
