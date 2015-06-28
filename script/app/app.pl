use Mojolicious::Lite;

get '/' => sub {
    my $c = shift;
    $c->stash(apple => 'test');
    $c->render(template => 'index');
};

get '/analyze/:profile_id' => sub {
    my $c = shift;
    my $profile_id = $c->stash('profile_id');
    $c->stash(profile_id => $profile_id);
    $c->render(template => 'analyze');
};

app->start('daemon', '-l', 'http://*:8080');
