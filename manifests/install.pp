#
# = Class: zimbra::install
#
# This class installs zimbra
#
class zimbra::install {

  case $zimbra::install {

    package: {

      if $zimbra::package {
        package { $zimbra::package:
          ensure   => $zimbra::managed_package_ensure,
          provider => $zimbra::package_provider,
        }
      }
    }

    upstream: {

      if $zimbra::user_create == true {
        require zimbra::user
      }
      # TODO: Use another define
      puppi::netinstall { 'netinstall_zimbra':
        url                 => $zimbra::managed_install_source,
        destination_dir     => $zimbra::install_destination,
        owner               => $zimbra::user,
        group               => $zimbra::user,
      }

      file { 'zimbra_link':
        ensure => "${zimbra::home_dir}" ,
        path   => "${zimbra::install_destination}/zimbra",
      }
    }

    puppi: {

      if $zimbra::bool_create_user == true {
        require zimbra::user
      }

      puppi::project::archive { 'zimbra':
        source      => $zimbra::managed_install_source,
        deploy_root => $zimbra::install_destination,
        user        => $zimbra::user,
        auto_deploy => true,
        enable      => true,
      }

      file { 'zimbra_link':
        ensure => "${zimbra::home_dir}" ,
        path   => "${zimbra::install_destination}/zimbra",
      }
    }

    default: { }

  }

}
