use strict;
use warnings FATAL => qw(all);

use Test::More tests => 9;

my $class = qw(WebService::UrbanAirship);

use_ok($class);

{
  my $o = $class->new(application_key           => 'key',
                      application_secret        => 'secret',
                      application_master_secret => 'master secret');


  isa_ok ($o, $class);

  ok (exists $o->{_ua},
      '_ua slot exists');

  my $ua = $o->{_ua};

  isa_ok ($ua, 'LWP::UserAgent');

  #like ($ua->agent,
  #      qr($class/0.\d+),
  #      'user-agent string properly set');

  is ($ua->timeout,
      60,
      'timeout properly set');

  is_deeply ($ua->protocols_allowed,
             [ qw(https) ],
             'only https allowed');

  my $headers = $ua->default_headers;

  isa_ok ($headers, 'HTTP::Headers');

  is ($headers->content_type,
      'application/json',
      'Content-Type properly set');

  is ($headers->authorization,
      'Basic a2V5Om1hc3RlciBzZWNyZXQ=',
      'Authorization header properly set');

  require Data::Dumper;

  #diag(Data::Dumper::Dumper($o->{_ua}));
}
