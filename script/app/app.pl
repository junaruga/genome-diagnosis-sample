use strict;
use warnings;
use Carp;
use Data::Dumper::Concise;
use English qw( -no_match_vars );
use Readonly;
use Mojolicious::Lite;

use Genome::Log qw( log );
use Genome::SnpAnalysis;

Readonly my $MAX_PROFILE_ID => 10;

get '/' => sub {
    my $c = shift;
    # TODO: Get profile ids from genome.json
    my @profile_ids = (1..$MAX_PROFILE_ID);
    my $profile_ids_ref = \@profile_ids;
    $c->stash(profile_ids => $profile_ids_ref);
    $c->render(template => 'index');
};

# /analyze/:profile_id.json
get '/analyze/:profile_id' => [format => 'json'] => sub {
    my $c = shift;
    my $profile_id = $c->stash('profile_id');
    #$c->stash(profile_id => $profile_id);

    my $analysis = Genome::SnpAnalysis->new();
    my $result = $analysis->analyze( +{ profile_id => $profile_id, } );
    log('Result: ', $result);

    $c->respond_to(
        json => {json => $result},
    );
};

app->start('daemon', '-l', 'http://*:8080');
