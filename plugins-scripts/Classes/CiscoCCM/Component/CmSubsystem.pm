package Classes::CiscoCCM::Component::CmSubsystem;
our @ISA = qw(Classes::CiscoCCM);
use strict;

sub init {
  my $self = shift;
  $self->get_snmp_tables('CISCO-CCM-MIB', [
      ['ccms', 'ccmTable', 'Classes::CiscoCCM::Component::CmSubsystem::Cm'],
  ]);
}

sub check {
  my $self = shift;
  foreach (@{$self->{ccms}}) {
    $_->check();
  }
  if (! scalar(@{$self->{ccms}})) {
    $self->add_message(
        defined $self->opts->mitigation() ? $self->opts->mitigation() : 2,
        'local callmanager is down');
  }
}


package Classes::CiscoCCM::Component::CmSubsystem::Cm;
our @ISA = qw(GLPlugin::TableItem);
use strict;

sub check {
  my $self = shift;
  $self->blacklist('cm', $self->{ccmIndex});
  $self->add_info(sprintf 'cm %s is %s',
      $self->{ccmName},
      $self->{ccmStatus});
  $self->add_message($self->{ccmStatus} eq 'up' ? OK : CRITICAL, $self->{info});
}

