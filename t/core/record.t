use strict;
use warnings;
use Test::More;
use Test::Flatten;

use Genome::Model::DiseaseSnp;
use Genome::Model::Genome;
use Genome::Model::Snp;

use t::TestGenome;

my $snp = Genome::Model::Snp->new();
my $disease_snp = Genome::Model::DiseaseSnp->new();

subtest 'sub get_name, snp' => sub {
    my $name = $snp->get_name();
    is $name, 'snps', 'name';
};

subtest 'sub get_name, disease_snp' => sub {
    my $name = $disease_snp->get_name();
    is $name, 'disease_snps', 'name';
};

subtest 'sub find, snp' => sub {
    my $snps = $snp->find();
    ok $snps, 'snps';
    is((ref $snps), 'ARRAY', 'Ref of anps');
    cmp_ok((scalar @{$snps}), '>', 0, 'Size of anps');
};

subtest 'sub find, disease_snp' => sub {
    my $disease_snps = $disease_snp->find();
    ok $disease_snps, 'disease_snps';
    is((ref $disease_snps), 'ARRAY', 'Ref of disease_snps');
    cmp_ok((scalar @{$disease_snps}), '>', 0, 'Size of disease_snps');
};

done_testing;

