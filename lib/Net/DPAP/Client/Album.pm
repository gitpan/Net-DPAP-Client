package Net::DPAP::Client::Album;
use strict;
use warnings;
use base qw(Class::Accessor::Fast);

__PACKAGE__->mk_accessors(qw(count id name images));

1;
