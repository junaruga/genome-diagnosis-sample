#!/bin/sh

BIN_DIR=`dirname ${0}`
ROOT_DIR="${BIN_DIR}/../.."
TIDY_FILE="${ROOT_DIR}/etc/dev/perltidyrc"

set -x

for PERL_DIR in `echo "lib script"`; do
    echo "PERL_DIR ${PERL_DIR}"
    find ${PERL_DIR} -name "*.p[ml]" -print0 \
        | xargs -0 perltidy -b -bext='/' --profile="${TIDY_FILE}"
done

exit 0
