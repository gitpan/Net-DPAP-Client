package Net::DPAP::Client::Image;
use strict;
use warnings;
use base qw(Class::Accessor::Fast);
use Carp::Assert;
use LWP::Simple;
use Net::DAAP::DMAP qw(:all);

__PACKAGE__->mk_accessors(qw(ua kind id name aspectratio creationdate
imagefilename thumbnail_url hires_url));

sub thumbnail {
  my $self = shift;
  my $url = $self->thumbnail_url;
  return $self->decode(get($url));
}

sub hires {
  my $self = shift;
  my $url = $self->hires_url;
  return $self->decode(get($url));
}

sub decode {
  my $self = shift;
  my $data  = shift;
  my $dmap = dmap_unpack($data);


  assert($dmap->[0]->[0] eq 'daap.databasesongs');
  foreach my $tuple (@{$dmap->[0]->[1]}) {
    my $key = $tuple->[0];
    my $value = $tuple->[1];
    assert($value == 200) if $key eq 'dmap.status';
    next unless $key eq 'dmap.listing';
    my $list = $value->[0]->[1];

    foreach my $subtuple (@$list) {
      my $subsubkey = $subtuple->[0];
      my $subsubvalue = $subtuple->[1];
      return $subsubvalue if $subsubkey eq 'dpap.picturedata';
    }
  }
}

1;
