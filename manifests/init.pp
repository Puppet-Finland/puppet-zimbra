#
# = Class: zimbra
#
# This class installs and manages zimbra
#
#
# == Parameters
#
# Refer to the official documentation for standard parameters usage.
# Look at the code for the list of supported parametes and their defaults.
#
class zimbra (

  $ensure              = 'present',
  $version             = undef,
  $audit               = undef,
  $noop                = undef,

  $install             = 'package',
  $install_base_url    = $zimbra::params::install_base_url,
  $install_source      = undef,
  $install_destination = '/opt',

  $user                = 'zimbra',
  $user_create         = true,
  $user_uid            = undef,
  $user_gid            = undef,
  $user_groups         = undef,

  $java_heap_size      = '1024',

  $package             = $zimbra::params::package,
  $package_provider    = undef,

  $service             = $zimbra::params::service,
  $service_ensure      = 'running',
  $service_enable      = true,
  $service_subscribe   = $zimbra::params::service_subscribe,
  $service_provider    = undef,

  $init_script_file           = '/etc/init.d/zimbra',
  $init_script_file_template  = 'zimbra/init.erb',
  $init_options_file          = $zimbra::params::init_options_file,
  $init_options_file_template = 'zimbra/init_options.erb',

  $file                = $zimbra::params::file,
  $file_owner          = $zimbra::params::file_owner,
  $file_group          = $zimbra::params::file_group,
  $file_mode           = $zimbra::params::file_mode,
  $file_replace        = $zimbra::params::file_replace,
  $file_source         = undef,
  $file_template       = undef,
  $file_content        = undef,
  $file_options_hash   = undef,

  $dir                 = $zimbra::params::dir,
  $dir_source          = undef,
  $dir_purge           = false,
  $dir_recurse         = true,

  $dependency_class    = 'zimbra::dependency',
  $my_class            = undef,

  $monitor_class       = '',
  $monitor_options_hash = { },

  $firewall            = false,
  $firewall_options_hash = { },

  ) inherits zimbra::params {


  # Input parameters validation
  validate_re($ensure, ['present','absent'], 'Valid values are: present, absent. WARNING: If set to absent all the resources managed by the module are removed.')
  validate_re($install, ['package','upstream'], 'Valid values are: package, upstream.')
  validate_re($service_ensure, ['running','stopped'], 'Valid values are: running, stopped')
  validate_bool($service_enable)
  validate_bool($dir_recurse)
  validate_bool($dir_purge)
  if $file_options_hash { validate_hash($file_options_hash) }

  # Calculation of variables used in the module
  if $file_content {
    $managed_file_content = $file_content
  } else {
    if $file_template {
      $managed_file_content = template($file_template)
    } else {
      $managed_file_content = undef
    }
  }

  if $version {
    $managed_package_ensure = $version
  } else {
    $managed_package_ensure = $ensure
  }

  if $ensure == 'absent' {
    $managed_service_enable = undef
    $managed_service_ensure = stopped
    $dir_ensure = absent
    $file_ensure = absent
  } else {
    $managed_service_enable = $service_enable
    $managed_service_ensure = $service_ensure
    $dir_ensure = directory
    $file_ensure = present
  }

  $managed_install_source = $zimbra::install_source ? {
    ''      => "${zimbra::install_base_url}/zimbra-${zimbra::version}.zip",
    default => $zimbra::install_source,
  }

  $created_dir = url_parse($managed_install_source,'filedir')
  $home_dir = "${zimbra::install_destination}/${zimbra::created_dir}"

  $managed_file = $zimbra::install ? {
    package => $zimbra::file,
    default => "${zimbra::home_dir}/config/zimbra.yml",
  }

  $managed_dir = $zimbra::dir ? {
    ''      => $zimbra::install ? {
      package => $zimbra::dir,
      default => "${zimbra::home_dir}/config/",
    },
    default => $zimbra::dir,
  }

  $managed_service_provider = $install ? {
    /(?i:upstream|puppi)/ => 'init',
    default               => undef,
  }

  # Resources Managed
  class { 'zimbra::install':
  }

  class { 'zimbra::service':
    require => Class['zimbra::install'],
  }

  class { 'zimbra::config':
    require => Class['zimbra::install'],
  }


  # Extra classes
  if $zimbra::dependency_class {
    include $zimbra::dependency_class
  }

  if $zimbra::monitor_class {
    include $zimbra::monitor_class
  }

  if $zimbra::firewall_class {
    include $zimbra::firewall_class
  }

  if $zimbra::my_class {
    include $zimbra::my_class
  }

}
