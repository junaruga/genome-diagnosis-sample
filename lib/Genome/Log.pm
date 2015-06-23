package Genome::Log;

use strict;
use warnings;
use Carp;
use Data::Dumper::Concise;
use Exporter 'import';
use vars qw( @EXPORT @EXPORT_OK );

@EXPORT    = qw();
@EXPORT_OK = qw( log debug_log error_log );

our $IS_DEBUG = 0;

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

sub debug_log {
    my ( $message, $ref ) = @_;

    if ($IS_DEBUG) {
        Genome::Log::log('[DEBUG] ' . $message, $ref);
    }

    return;
}

sub error_log {
    my ( $message, $ref ) = @_;

    Genome::Log::log('[ERROR] ' . $message, $ref);

    return;
}

1;
