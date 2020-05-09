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
class zimbra(

  $install_source           = $::zimbra::params::install_source,
  $zimbra_version           = $::zimbra::params::version,
  $install_destination      = '/opt',
  $license_template         = 'zimbra/ZCSLicense.xml',
  $default_configs_template = 'zimbra/defaults.erb',
  $prerequisites_class      = '::zimbra::prerequisites',
  $options_hash             = {},
  $debug                    = 'on_failure',
  
) inherits zimbra::params {


  $created_dir = url_parse($install_source,'filedir')
  $install_dir = "${install_destination}/${created_dir}"
  $options = merge($::zimbra::params::default_options,$options_hash)

  # Resources Managed
  if $prerequisites_class and $prerequisites_class != '' {
    include $prerequisites_class
  }

  archive { "/tmp//zimbra.tgz":
    extract      => true,
    extract_path => $install_destination,
    source       => $install_source,
    # creates      => "/opt/keycloak-${keycloak_version}/standalone",
    cleanup      => true,
  }

  puppi::netinstall { 'netinstall_zimbra':
    url                 => $install_source,
    destination_dir     => $install_destination,
  } ->

  file { "${install_dir}/defaults.conf":
    content => template($default_configs_template),
    mode    => '0600',
  } ->
  file { "/opt/ZCSLicense.xml":
    content => template($license_template),
  } ->
  exec { 'Zimbra_installation':
    command   => "${install_dir}/install.sh ${install_dir}/defaults.conf",
    cwd       => $install_dir,
    creates   => '/opt/zimbra/conf/log4j.properties',
    timeout   => '1800',
    logoutput => $debug,
  }

}
