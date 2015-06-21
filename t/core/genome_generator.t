use strict;
use warnings;
use Test::More;
use Test::Flatten;

use Genome::GenomeGenerator;

use t::TestGenome;

subtest 'sub generate_genome' => sub {
    my $generator = Genome::GenomeGenerator->new();
    ok $generator, 'New';
    $generator->generate_genome();

    ok 1, 'Done';
};

done_testing;
