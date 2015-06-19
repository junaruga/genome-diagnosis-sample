package Genome::Record;

use strict;
use warnings;
use Carp;
use Data::Dumper::Concise;
use English qw( -no_match_vars );
use JSON;
use Readonly;
use Try::Tiny;

use Genome::Const;

my $_CACHE_FIND_VALUE = undef;

sub new {
    my ($class, $options) = @_;

    my $self = ($options) ? $options : {};
    bless $self, $class;
}

sub find {
    my ($options) = @_;

    my $value = undef;
    if ( $options->{cache} ) {
        $value = $_CACHE_FIND_VALUE;
    }

    if ( !defined $value ) {
        my $file = Genome::Record::get_file();
        my $obj = Genome::Record::_get_obj_from_json_file($file);
        my $name = Genome::Record::get_name();
        $value = $obj->{$name};
    }

    return $value;
}

sub get_name {
    # TODO: get data file name from pm file name automatically.
    croak 'get_name should be implemented at child class';
}

sub get_file {
    my $name = Genome::Record::get_name();
    my $file = sprintf '%s/%s.json',
        $Genome::Const::DATA_DIR, $name;

    return $file;
}

sub save {
    my ($self, $value) = @_;

    if ( !defined $value ) {
        croak 'value is required.';
    }

    my $name = Genome::Record::get_name();
    my $out_obj = +{
        $name => $value,
    };

    my $file = Genome::Record::get_file();
    my $text = to_json($out_obj, +{pretty => 1});
    open my $fh, '>', $file
        or croak "$file $OS_ERROR";
    print $fh, $text;
    close $fh;

    return;
}

# Get all text data at once for sample.
sub _get_text {
    my ($file) = @_;

    if ( !defined $file ) {
        croak 'file is required.';
    }

    open my $fh, '<', $file
        or croak "$file $OS_ERROR";
    my $content = do {
        local $INPUT_RECORD_SEPARATOR = undef;
        return <$fh>
    };
    close $fh;

    return $content;
}

sub _get_obj_from_json_file {
    my ($file) = @_;

    if ( !defined $file ) {
        croak 'file is required.';
    }

    my $text = Genome::Record::_get_text($file);
    my $obj = decode_json $text;
    return $obj;
}

1;
