#!/bin/sh

# This way works in the case of $ source env.sh
ROOT_DIR=$(cd $(dirname ${BASH_SOURCE}); pwd)

# CPAN modules path installed by Carton.
PERL5LIB="$ROOT_DIR/local/lib/perl5"
# This project's modules path
PERL5LIB="$PERL5LIB:$ROOT_DIR/lib"
export PERL5LIB
