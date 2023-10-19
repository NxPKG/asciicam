#!/usr/bin/env bash

set -eExuo pipefail

if ! command -v "pkill" >/dev/null 2>&1; then
    printf "error: pkill not installed\n"
    exit 1
fi

python3 -V

ASCIICAM_CONFIG_HOME="$(
    mktemp -d 2>/dev/null || mktemp -d -t asciicam-config-home
)"

export ASCIICAM_CONFIG_HOME

TMP_DATA_DIR="$(mktemp -d 2>/dev/null || mktemp -d -t asciicam-data-dir)"

trap 'rm -rf ${ASCIICAM_CONFIG_HOME} ${TMP_DATA_DIR}' EXIT

asciicam() {
    python3 -m asciicam "${@}"
}

## disable notifications

printf "[notifications]\nenabled = no\n" >> "${ASCIICAM_CONFIG_HOME}/config"

## test help message

asciicam -h

## test version command

asciicam --version

## test auth command

asciicam auth

## test play command

# asciicast v1
asciicam play -s 5 tests/demo.json
asciicam play -s 5 -i 0.2 tests/demo.json
# shellcheck disable=SC2002
cat tests/demo.json | asciicam play -s 5 -

# asciicast v2
asciicam play -s 5 tests/demo.cast
asciicam play -s 5 -i 0.2 tests/demo.cast
# shellcheck disable=SC2002
cat tests/demo.cast | asciicam play -s 5 -

## test cat command

# asciicast v1
asciicam cat tests/demo.json
# shellcheck disable=SC2002
cat tests/demo.json | asciicam cat -

# asciicast v2
asciicam cat tests/demo.cast
# shellcheck disable=SC2002
cat tests/demo.cast | asciicam cat -

## test rec command

# normal program
asciicam rec -c 'bash -c "echo t3st; sleep 2; echo ok"' "${TMP_DATA_DIR}/1a.cast"
grep '"o",' "${TMP_DATA_DIR}/1a.cast"

# very quickly exiting program
asciicam rec -c whoami "${TMP_DATA_DIR}/1b.cast"
grep '"o",' "${TMP_DATA_DIR}/1b.cast"

# signal handling
bash -c "sleep 1; pkill -28 -n -f 'm asciicam'" &
asciicam rec -c 'bash -c "echo t3st; sleep 2; echo ok"' "${TMP_DATA_DIR}/2.cast"

bash -c "sleep 1; pkill -n -f 'bash -c echo t3st'" &
asciicam rec -c 'bash -c "echo t3st; sleep 2; echo ok"' "${TMP_DATA_DIR}/3.cast"

bash -c "sleep 1; pkill -9 -n -f 'bash -c echo t3st'" &
asciicam rec -c 'bash -c "echo t3st; sleep 2; echo ok"' "${TMP_DATA_DIR}/4.cast"

# with stdin recording
echo "ls" | asciicam rec --stdin -c 'bash -c "sleep 1"' "${TMP_DATA_DIR}/5.cast"
cat "${TMP_DATA_DIR}/5.cast"
grep '"i", "ls\\n"' "${TMP_DATA_DIR}/5.cast"
grep '"o",' "${TMP_DATA_DIR}/5.cast"

# raw output recording
asciicam rec --raw -c 'bash -c "echo t3st; sleep 1; echo ok"' "${TMP_DATA_DIR}/6.raw"

# appending to existing recording
asciicam rec -c 'echo allright!; sleep 0.1' "${TMP_DATA_DIR}/7.cast"
asciicam rec --append -c uptime "${TMP_DATA_DIR}/7.cast"

# adding a marker
printf "[record]\nadd_marker_key = C-b\n" >> "${ASCIICAM_CONFIG_HOME}/config"
(bash -c "sleep 1; printf '.'; sleep 0.5; printf '\x08'; sleep 0.5; printf '\x02'; sleep 0.5; printf '\x04'") | asciicam rec -c /bin/bash "${TMP_DATA_DIR}/8.cast"
grep '"m",' "${TMP_DATA_DIR}/8.cast"
