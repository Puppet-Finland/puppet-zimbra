#
# Testing configuration file provisioning via template
# Auditing enabled
#
class { 'zimbra':
  template => 'zimbra/tests/test.conf',
  audit    => 'all',
}
