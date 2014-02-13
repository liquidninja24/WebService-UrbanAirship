package My::Subclass;

use strict;
use warnings FATAL => qw(all);

use WebService::UrbanAirship;

our @ISA = qw(WebService::UrbanAirship);


sub _api_uri {

  my $port = eval {
    require Apache::Test;
    require Apache::TestRequest;

    Apache::Test::config()->{vhosts}
                          ->{TestLive}
                          ->{port};
  };

  return URI->new("https://localhost:$port");
}

1;
