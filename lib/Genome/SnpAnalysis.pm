package Genome::SnpAnalysis;

use strict;
use warnings;
use Carp;
use Data::Dumper::Concise;
use English qw( -no_match_vars );
use Math::Round;
use Readonly;
use Try::Tiny;

use Genome::Log qw( log debug_log );
use Genome::Model::DiseaseSnp;
use Genome::Model::Genome;
use Genome::Model::Snp;

sub new {
    my ( $class, $options ) = @_;

    my $self = ($options) ? $options : {};

    $self = bless $self, $class;
    $self->_load_related_data();

    return $self;
}

sub get_disease_snps_with_positions {
    my ( $self ) = @_;

    return $self->{disease_snps};
}

sub analyze {
    my ( $self, $options ) = @_;

    my $profile_id = $options->{profile_id};
    if ( !defined $profile_id ) {
        croak 'profile_id is required.';
    }

    my $genome_obj = Genome::Model::Genome->new()->find();
    my $base_genome_string = $genome_obj->{base};
    my $genomes = $genome_obj->{genomes};

    my $target_genome_string = undef;
    for my $genome (@{$genomes}) {
        if ( $genome->{profile_id} == $profile_id ) {
            $target_genome_string = $genome->{genome};
            last;
        }
    }
    if ( !defined $target_genome_string ) {
        croak "genome string is not found. profile_id: $profile_id";
    }

    my $result = $self->analyze_genome_string($target_genome_string,
        $base_genome_string);

    return $result;
}

sub analyze_genome_string {
    my ( $self, $target, $base ) = @_;

    if ( !defined $target ) {
        croak 'target is required.';
    }
    if ( !defined $base ) {
        croak 'base is required.';
    }

    debug_log "target: $target";
    debug_log "base  : $base";

    #$self->{disease_snps}
    my $result = +{
        items => [],
    };
    my $disease_snps = $self->{disease_snps};
    #debug_log 'disease_snps:', $disease_snps;

    for my $disease_snp (@{$disease_snps}) {
        my $positions = $disease_snp->{snp_positions};
        my $variant_count = 0;
        for my $position (@{$positions}) {
            debug_log "snp position: $position";
            my $n = $position - 1;
            my $target_char = substr( $target, $n, 1 );
            my $base_char = substr( $base, $n, 1 );
            if ( $target_char ne $base_char ) {
                $variant_count++;
            }
        }

        my $num_of_position = scalar @{$positions};
        my $rate = ($num_of_position > 0)
            ? $variant_count / $num_of_position : 0;
        $rate = nearest .01, $rate;
        my $is_variant_present = ($variant_count > 0) ? 1 : 0;

        my $item = +{
            name => $disease_snp->{name},
            rate => $rate,
            total_variant_num => $num_of_position,
            variant_num => $variant_count,
            is_variant_present => $is_variant_present,
        };
        push @{ $result->{items} }, $item;
    }

    return $result;
}

sub _load_related_data {
    my ( $self, $options ) = @_;

    # $disease_snps = [
    #     {
    #         id: xxx,
    #         name: xxx,
    #         possible_snps: [ xxx, yyy, zzz ],
    #         snp_possitons = [ n1, n2, n3 ],
    #     },
    #     {
    #         ...
    #     },
    #}]
    my $disease_snps = Genome::Model::DiseaseSnp->new()->find();
    for my $disease_snp ( @{$disease_snps} ) {
        $disease_snp->{snp_positions} = [];
        for my $snp ( @{ $disease_snp->{possible_snps} } ) {
            my $position = $self->_get_snp_position($snp);
            push @{ $disease_snp->{snp_positions} }, $position;
        }
    }

    $self->{disease_snps} = $disease_snps;

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

1;
