#
# @summary Manage Zimbra Collaboration Server service
#
class zimbra::service {

  assert_private()

  service { 'postfix':
    ensure => 'stopped',
    enable => false,
  }

  # Zimbra configures it's own unbound.
  # We use it as a helper when testing with vagrant.
  # We turn it off here.
  service { 'unbound':
    ensure => 'stopped',
    enable => false,
  }

  service { 'zimbra':
    ensure  => 'running',
    enable  => true,
    require => 
    [
      Service['postfix'],
      Service['unbound'],
    ],
  }
}
