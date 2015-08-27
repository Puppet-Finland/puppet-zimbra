#
# Testing configuration file provisioning via source
# Auditing enabled
#
class { 'zimbra':
  source => 'puppet:///modules/zimbra/tests/test.conf',
  audit  => 'all',
}
