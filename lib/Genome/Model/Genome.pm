package Genome::Model::Genome;

use strict;
use warnings;
use Carp;
use Data::Dumper::Concise;
use English qw( -no_match_vars );
use Readonly;
use Try::Tiny;

use base qw( Genome::Record );

sub get_name {
    my ($self) = @_;

    return 'genomes';
}

1;
