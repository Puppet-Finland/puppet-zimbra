#
# = Class: zimbra::service
#
# This class manages zimbra service
#
class zimbra::service {

  if $zimbra::service {
    service { $zimbra::service:
      ensure     => $zimbra::managed_service_ensure,
      enable     => $zimbra::managed_service_enable,
      subscribe  => $zimbra::service_subscribe,
      provider   => $zimbra::managed_service_provider,
    }
  }

}
