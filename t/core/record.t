use strict;
use warnings;
use Test::More;
use Test::Flatten;

use Genome::Model::DiseaseSnp;
use Genome::Model::Genome;
use Genome::Model::Snp;

use t::TestGenome;

my $snp = Genome::Model::Snp->new();

subtest 'sub get_name' => sub {
    my $name = $snp->get_name();
    is $name, 'snps', 'snps name';
};

subtest 'sub find' => sub {
    my $snps = Genome::Model::Snp->new()->find();
    ok $snps, 'snps';
    is((ref $snps), 'ARRAY', 'Ref of anps');
    cmp_ok((scalar @{$snps}), '>', 0, 'Size of anps');
};

done_testing;

