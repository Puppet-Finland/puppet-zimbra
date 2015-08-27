#
# Testing installation from upstream
#
class { 'zimbra':
  install => 'upstream',
  version => '0.90.1',
}
