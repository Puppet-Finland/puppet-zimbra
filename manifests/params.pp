# Class: zimbra::params
#
# Defines all the variables used in the module.
#
class zimbra::params {

  $install_base_url = 'https://download.zimbra.org/zimbra/zimbra/'

  $package = 'zimbra'

  $service = 'zimbra'

  $service_subscribe = Class['zimbra::config']

  $file = $::osfamily ? {
    default => '/etc/zimbra/zimbra.yml',
  }

  $init_options_file = $::osfamily ? {
    Debian  => '/etc/default/zimbra',
    default => '/etc/sysconfig/zimbra',
  }

  $file_mode = '0644'

  $file_owner = 'root'

  $file_group = 'root'

  $dir = $::osfamily ? {
    default => '/etc/zimbra/',
  }

}
