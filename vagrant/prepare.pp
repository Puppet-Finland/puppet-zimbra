notify { 'Preparing for setup': }

$tools = [ 'emacs-nox', 'tcpdump', 'strace', 'nmap', 'net-tools', 'git' ]

package { $tools:
  ensure  => 'installed',
}

package { 'r10k':
  ensure   => 'present',
  provider => 'puppet_gem',
}

exec { 'Update modules':
  cwd       => "${::basedir}",
  logoutput => true,
  command   => 'r10k puppetfile install --verbose',
  timeout   => 600,
  path      => ['/bin','/usr/bin','/opt/puppetlabs/bin','/opt/puppetlabs/puppet/bin'],
}

