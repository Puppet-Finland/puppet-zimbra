#
# @summary retrieve  Zimbra Collaboration Server
#
class zimbra::install {

  assert_private()

  if $facts['virtual'] == 'virtualbox' {
    if $facts['osfamily'] == 'RedHat' {
      class { 'selinux':
        mode => 'permissive',
      }
    }
  }

  $langpacks = [ 'langpacks-en', 'glibc-all-langpacks' ]

  package { $langpacks:
    ensure => 'installed'
  }

  ensure_packages($zimbra::required_packages)

  ensure_packages($zimbra::absent_packages, { ensure => absent } )

  puppi::netinstall { 'zimbra_install':
    url             => $zimbra::install_source,
    destination_dir => $zimbra::install_destination,
  }
}
