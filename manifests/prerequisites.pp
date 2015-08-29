class zimbra::prerequisites {

  host { 'localhost.localdomain':
    host_aliases => 'localhost', 
    ip           => '127.0.0.1',
  }

  host { $::fqdn:
    host_aliases => $::hostname, 
    ip           => $::ipaddress,
  }

  $packages = $::osfamily ? {
    'Debian' => [ 'sysstat' , 'sqlite3' , 'pax' , 'libperl5.18' , 'libaio1' , 'unzip' ],
    'RedHat' => [ 'sysstat' , 'sqlite' , 'pax' , 'perl-libs' , 'libaio' ,
    'unzip' , 'perl-core', 'nmap-ncat' ],
  }
  ensure_packages($packages)

  $packages_uninstall = [ 'postfix' ]
  ensure_packages($packages_uninstall, { ensure => absent } )



}
