# Class: zimbra::dependency
#
# This class installs zimbra dependency
#
# == Usage
#
# This class may contain resources available on the
# Example42 modules set.
#
class zimbra::dependency {

  include java

  if $zimbra::install != 'package' {
    git::reposync { 'zimbra-servicewrapper':
      source_url      => 'https://github.com/zimbra/zimbra-servicewrapper.git',
      destination_dir => "${zimbra::install_destination}/zimbra-servicewrapper",
      post_command    => "cp -a ${zimbra::install_destination}/zimbra-servicewrapper/service/ ${zimbra::home_dir}/bin ; chown -R ${zimbra::user}:${zimbra::user} ${zimbra::home_dir}/bin/service",
      creates         => "${zimbra::home_dir}/bin/service",
      before          => [ Class['zimbra::service'] , Class['zimbra::config'] ],
    }
    exec { 'zimbra-servicewrapper-copy':
      command => "cp -a ${zimbra::install_destination}/zimbra-servicewrapper/service/ ${zimbra::home_dir}/bin ; chown -R ${zimbra::user}:${zimbra::user} ${zimbra::home_dir}/bin/service",
      path    => '/bin:/sbin:/usr/sbin:/usr/bin',
      creates => "${zimbra::home_dir}/bin/service",
      require => Git::Reposync['zimbra-servicewrapper'],
    }
    file { "${zimbra::home_dir}/bin/service/zimbra":
      ensure  => present,
      mode    => 0755,
      owner   => $zimbra::user,
      group   => $zimbra::user,
      content => template($zimbra::init_script_file_template),
      before  => Class['zimbra::service'],
      require => Git::Reposync['zimbra-servicewrapper'],
    }
    file { "/etc/init.d/zimbra":
      ensure  => "${zimbra::home_dir}/bin/service/zimbra",
    }
    file { "${zimbra::home_dir}/bin/service/zimbra.conf":
      ensure  => present,
      mode    => 0644,
      owner   => $zimbra::user,
      group   => $zimbra::user,
      content => template($zimbra::init_options_file_template),
      before  => Class['zimbra::service'],
      require => Git::Reposync['zimbra-servicewrapper'],
    }
    file { "${zimbra::home_dir}/logs":
      ensure  => directory,
      mode    => 0755,
      owner   => $zimbra::user,
      group   => $zimbra::user,
      before  => Class['zimbra::service'],
      require => Git::Reposync['zimbra-servicewrapper'],
    }
  }

}
