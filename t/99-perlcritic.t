use strict;
use warnings;
use File::Basename;
use Readonly;
use Test::More;
use Try::Tiny;

try {
    require Test::Perl::Critic;
    Test::Perl::Critic->import(-profile => "t/perlcriticrc");
}
catch {
    plan skip_all => 'Test::Perl::Critic is not installed.';
};

my @PERL_DIRS = qw( lib script );
all_critic_ok(@PERL_DIRS);
