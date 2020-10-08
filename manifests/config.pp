#
# @summary Configure Zimbra Collaboration Server
#
class zimbra::config {

  assert_private()

  $locales = (['en_US.UTF-8 UTF-8'] << $zimbra::default_locale).unique
  
  class { 'locales':
    default_locale => $zimbra::default_locale,
    locales        => $locales,
  }

  host { 'localhost.localdomain':
    host_aliases => 'localhost',
    ip           => '127.0.0.1',
  }

  $fqdn_ip = $facts['networking']['interfaces'][$zimbra::fqdn_interface]['ip']

  host { $facts['fqdn']:
    host_aliases => $facts['hostname'],
    ip           => $fqdn_ip,
  }

  $created_dir = url_parse($zimbra::install_source, 'filedir')
  $install_dir = "${zimbra::install_destination}/${created_dir}"
  $options = merge($zimbra::default_options, $zimbra::options_hash)

  file { "${install_dir}/defaults.conf":
    content => template($zimbra::default_configs_template),
    mode    => '0600',
  }

  exec { 'zimbra_install_and_configure':
    command   => "${install_dir}/install.sh ${install_dir}/defaults.conf",
    cwd       => $install_dir,
    creates   => "${zimbra::install_destination}/zimbra/conf/log4j.properties",
    timeout   => '1800',
    logoutput => $zimbra::debug,
    require   => [
      Host['localhost.localdomain'],
      Host["${facts['fqdn']}"],
      File["${install_dir}/defaults.conf"],
    ]
  }
}
