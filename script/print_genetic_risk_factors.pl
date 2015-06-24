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
use Genome::SnpAnalysis;

Readonly my $STATUS => +{
    ok => 0,
    error => 1,
};

sub main {
    my $exit_status = $STATUS->{ok};

    my $profile_id = undef;
    my $is_debug = 0;
    try {
        GetOptions(
            'profile_id|p=i' => \$profile_id,
            'debug' => \$is_debug,
        );
        if ($is_debug) {
            $Genome::Log::IS_DEBUG = 1;
        }
        if ( !defined $profile_id ) {
            croak 'Profile id is required.';
        }

        my $analysis = Genome::SnpAnalysis->new();
        my $result = $analysis->analyze(+{
            profile_id => $profile_id,
        });

        print_result($result);
    }
    catch {
        error_log $_;
        $exit_status = $STATUS->{error};
    };

    return $exit_status;
}

sub print_result {
    my ( $result ) = @_;

    if ( !defined $result ) {
        croak 'result is required.';
    }

    print_line();
    printf "Genetic Risk Factors\n";
    print_line();
    for my $item (@{ $result->{items} }) {
        my $variant_disp = ($item->{is_variant_present})
            ? 'Variant Present' : 'Variant Absent';
        printf "%-20s %20s %10s\n",
            $item->{name} . ',',
            $variant_disp . ',',
            'Risk: ' . ($item->{rate} * 100) . '% ('
            . 'Total: ' . $item->{total_variant_num} . ', '
            . 'Found: ' . $item->{variant_num} . ')';
    }
    print_line();

    return;
}

sub print_line {
    printf "-" x 60 . "\n";
}

my $exit_status = main();
exit $exit_status;
