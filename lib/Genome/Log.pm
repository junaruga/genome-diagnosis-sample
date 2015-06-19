package Genome::Log;

use strict;
use warnings;
use Carp;
use Data::Dumper::Concise;
use Exporter 'import';
use vars qw( @EXPORT @EXPORT_OK );

@EXPORT    = qw();
@EXPORT_OK = qw( log );

sub log {
    my ( $message, $ref ) = @_;

    if ( !defined $message ) {
        croak 'message is required.';
    }

    if ( defined $ref ) {
        print $message, ' ', Dumper($ref), "\n";
    }
    else {
        print $message, "\n";
    }

    return;
}

1;
