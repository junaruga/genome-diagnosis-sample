package Genome::Const;

use strict;
use warnings;
use Cwd qw( abs_path );
use File::Basename qw( dirname );
use Readonly;

our $BASE_PAIR_CHARS = [ 'A', 'T', 'G', 'C' ];
our $UNKNOWN_BASE_PAIR_CHAR = '_';

Readonly my $BIN_DIR   => dirname __FILE__;
Readonly our $ROOT_DIR => abs_path($BIN_DIR);
Readonly our $DATA_DIR => "$ROOT_DIR/data";

1;
