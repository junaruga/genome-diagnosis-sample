#!/usr/bin/env perl

use strict;
use warnings;
use Carp;
use Data::Dumper::Concise;
use English qw( -no_match_vars );
use Getopt::Long;
use Readonly;
use Try::Tiny;
use version; our $VERSION = qv('v1.0.0');

use Genome::Log qw( log debug_log error_log );
use Genome::GenomeGenerator;

Readonly my $STATUS => +{
    ok => 0,
    error => 1,
};

sub main {
    my $exit_status = $STATUS->{ok};

    my $profile_number = undef;
    my $is_debug = 0;
    try {
        GetOptions(
            'number|n=i' => \$profile_number,
            'debug' => \$is_debug,
        );
        if ($is_debug) {
            $Genome::Log::IS_DEBUG = 1;
        }

        my $generator = Genome::GenomeGenerator->new(+{
            profile_number => $profile_number,
        });
        $generator->generate_genome();
    }
    catch {
        error_log $_;
        $exit_status = $STATUS->{error};
    };

    return $exit_status;
}

my $exit_status = main();
exit $exit_status;
