use strict;
use warnings FATAL => qw(all);

use Test::More tests => 9;

my $class = qw(WebService::UrbanAirship);

use_ok($class);

{
  eval { $class->new };

  like ($@,
        qr/application_key/,
        'application_key missing');

  eval { $class->new(application_key => 'key') };

  like ($@,
        qr/application_secret/,
        'application_secret missing');

  eval { $class->new(application_key    => 'key',
                     application_secret => 'secret'),
       };

  like ($@,
        qr/application_master_secret/,
        'application_master_secret missing');
}

{
  my $called = 0;

  no warnings qw(redefine);

  local *WebService::UrbanAirship::_init = sub { $called++ };

  my $o = $class->new(application_key           => 'key',
                      application_secret        => 'secret',
                      application_master_secret => 'master secret');

  isa_ok($o, $class);
  isa_ok($o, 'WebService::UrbanAirship');

  is ($called,
      1,
      '_init() called');
}

{
  my %args = ();

  no warnings qw(redefine);

  local *WebService::UrbanAirship::_init = sub { shift; %args = @_ };

  my %pass = (foo => 1, bar => 2);

  my $o = $class->new(application_key           => 'key',
                      application_secret        => 'secret',
                      application_master_secret => 'master secret',
                      %pass);

  isa_ok($o, $class);

  is_deeply(\%args,
            \%pass,
            'subset of args passed from new() to _init()');
}

