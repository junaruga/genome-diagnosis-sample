package Genome::GenomeGenerator;

use strict;
use warnings;
use Carp;
use Data::Dumper::Concise;
use English qw( -no_match_vars );
use List::Util;
use Readonly;
use Try::Tiny;
use String::Buffer;

use Genome::Const;
use Genome::Log qw( log );
use Genome::Model::DiseaseSnp;
use Genome::Model::Genome;
use Genome::Model::Snp;

# Total number of base pair.
# Set sample value for example..
# Actually it is about 3.1 billions.
# See https://en.wikipedia.org/wiki/Human_genome#Molecular_organization_and_gene_content
Readonly my $GENOME_BP_SIZE           => 300;
Readonly my $GENERATED_PROFILE_NUMBER => 100;
Readonly my $SNP_APPEARED_RATE        => 0.8;

sub new {
    my ( $class, $options ) = @_;

    my $self = ($options) ? $options : {};
    bless $self, $class;
}

sub generate_genome {
    my ( $self, $options ) = @_;

    my $disease_snps  = Genome::Model::DiseaseSnp->new()->find();
    my $snp_positions = [];
    for my $disease_snp ( @{$disease_snps} ) {
        for my $snp ( @{ $disease_snp->{possible_snps} } ) {
            my $position = $self->_get_snp_position($snp);
            push @{$snp_positions}, $position;
        }
    }
    my $base_genome = $self->_generate_base_genome_string();

    my $genome_records = [];
    for ( my $count = 0; $count < $GENERATED_PROFILE_NUMBER; $count++ ) {
        my $profile_id = $count + 1;
        my $genome_string =
            $self->_generate_genome_string_with_snps( $base_genome,
            $snp_positions );
        my $genome_record = +{
            profile_id => $profile_id,
            genome     => $genome_string,
        };
        push @{$genome_records}, $genome_record;
    }

    my $genome = Genome::Model::Genome->new();
    $genome->save($genome_records);

    return;
}

sub _get_snp_position {
    my ( $self, $snp_value ) = @_;

    if ( !defined $snp_value ) {
        croak 'snp_value is required.';
    }

    my $position   = 0;
    my $snps       = Genome::Model::Snp->new()->find( +{ cache => 1 } );
    my @found_snps = grep { $_->{snp} eq $snp_value } @{$snps};

    if ( scalar @found_snps <= 0 ) {
        croak "snp: [$snp_value] can not befound in snps data.";
    }

    return $found_snps[0]->{position};
}

sub _generate_base_genome_string {
    my ($self) = @_;

    my $buff = String::Buffer->new();
    for my $count ( 1 .. $GENOME_BP_SIZE ) {
        my $bp_char = $self->_get_base_pair_char_at_random();
        $buff->write($bp_char);
    }

    return $buff->read();
}

sub _get_base_pair_char_at_random {
    my ($self) = @_;

    my $bp_chars     = $Genome::Const::BASE_PAIR_CHARS;
    my $number_of_bp = scalar @{$bp_chars};
    my $selected_num = int( rand $number_of_bp );

    my $selected_bp_char = $bp_chars->[$selected_num];

    return $selected_bp_char;
}

sub _generate_genome_string_with_snps {
    my ( $self, $base_genome, $snp_positions ) = @_;

    if ( !defined $base_genome ) {
        croak 'base_genome is required.';
    }
    if ( !defined $snp_positions ) {
        croak 'snp_positions is required.';
    }

    my $buff = String::Buffer->new();
    for ( my $pos = 0; $pos < length($base_genome); $pos++ ) {
        my $char = substr( $base_genome, $pos, 1 );
        if ( List::Util::first { $_ == $pos } @{$snp_positions} ) {

            # Set another bp.
            # Value is different with base's char by 75% (= 3/4).
            $char = $self->_get_base_pair_char_at_random();
        }
        $buff->write($char);
    }

    return $buff->read();
}

1;
