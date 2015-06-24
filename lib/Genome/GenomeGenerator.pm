package Genome::GenomeGenerator;

use strict;
use warnings;
use Carp;
use Data::Dumper::Concise;
use English qw( -no_match_vars );
use List::MoreUtils qw( uniq );
use List::Util;
use Readonly;
use Try::Tiny;
use String::Buffer;

use Genome::SnpAnalysis;
use Genome::Const;
use Genome::Log qw( log debug_log );
use Genome::Model::Genome;

# Total number of base pair.
# Set sample value for example..
# Actually it is about 3.1 billions.
# See https://en.wikipedia.org/wiki/Human_genome#Molecular_organization_and_gene_content
Readonly my $GENOME_BP_SIZE           => 300;
Readonly my $DEFAULT_GENERATED_PROFILE_NUMBER => 100;
Readonly my $SNP_APPEARED_RATE        => 0.8;

sub new {
    my ( $class, $options ) = @_;

    my $self = ($options) ? $options : {};

    $self->{profile_number} = (defined $self->{profile_number})
        ? $self->{profile_number} : $DEFAULT_GENERATED_PROFILE_NUMBER;

    bless $self, $class;
}

sub generate_genome {
    my ( $self, $options ) = @_;

    my $snp_analysis = Genome::SnpAnalysis->new();
    my $disease_snps = $snp_analysis->get_disease_snps_with_positions();
    #debug_log 'disease_snps: ', $disease_snps;
    my $snp_positions = [];
    for my $disease_snp ( @{$disease_snps} ) {
        my $positions = $disease_snp->{snp_positions};
        push @{$snp_positions}, @{$positions};
    }
    my @sorted_positions = sort { $a <=> $b } @{$snp_positions};
    @sorted_positions = uniq @sorted_positions;
    $snp_positions = \@sorted_positions;

    my $base_genome = $self->_generate_base_genome_string();

    my $genome_records = [];
    debug_log "profile_number: " . $self->{profile_number};

    my $space_digit = length $self->{profile_number};
    my $debug_genome_format = '%' . $space_digit . 's %s';

    for ( my $count = 0; $count < $self->{profile_number}; $count++ ) {
        my $profile_id = $count + 1;
        my $genome_string =
            $self->_generate_genome_string_with_snps( $base_genome,
            $snp_positions );
        my $genome_record = +{
            profile_id => $profile_id,
            genome     => $genome_string,
        };
        push @{$genome_records}, $genome_record;

        my $debug_genome_message = sprintf $debug_genome_format,
            $profile_id, $genome_string;
        debug_log $debug_genome_message;
    }

    my $genome = Genome::Model::Genome->new();
    $genome->save(+{
        base => $base_genome,
        genomes => $genome_records,
    });

    return;
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
    for ( my $n = 0; $n < length($base_genome); $n++ ) {
        my $char = substr( $base_genome, $n, 1 );
        # position of snp_positions, is started from 1.
        my $target_snp_position = ($n + 1);
        if ( List::Util::first { $_ == $target_snp_position }
            @{$snp_positions} ) {
            # Set another bp.
            # Value is different with base's char by 75% (= 3/4).
            my $replaced_char = $self->_get_base_pair_char_at_random();

            debug_log "Change char on snp_possion: $target_snp_position, "
                . "[$char] to [$replaced_char]";

            $char = $replaced_char;
        }
        $buff->write($char);
    }

    return $buff->read();
}

1;
