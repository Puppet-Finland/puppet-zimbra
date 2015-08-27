#
# = Class: zimbra::config
#
# This class manages zimbra configurations
#
class zimbra::config {

  if $zimbra::file {
    file { 'zimbra.conf':
      ensure  => $zimbra::file_ensure,
      path    => $zimbra::managed_file,
      mode    => $zimbra::file_mode,
      owner   => $zimbra::file_owner,
      group   => $zimbra::file_group,
      source  => $zimbra::file_source,
      content => $zimbra::managed_file_content,
    }
  }

  # Configuration Directory, if dir defined
  if $zimbra::dir_source {
    file { 'zimbra.dir':
      ensure  => $zimbra::dir_ensure,
      path    => $zimbra::managed_dir,
      source  => $zimbra::dir_source,
      recurse => $zimbra::dir_recurse,
      purge   => $zimbra::dir_purge,
      force   => $zimbra::dir_purge,
    }
  }

}
