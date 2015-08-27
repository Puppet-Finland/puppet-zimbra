# Class: zimbra::user
#
# This class creates zimbra user
#
class zimbra::user {
  @user { $zimbra::user :
    ensure     => $zimbra::manage_file,
    comment    => "${zimbra::user} user",
    password   => '!',
    managehome => false,
    uid        => $zimbra::user_uid,
    gid        => $zimbra::user_gid,
    groups     => $zimbra::groups,
    shell      => '/bin/bash',
  }

  User <| title == $zimbra::user |>

}

