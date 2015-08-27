#
# = Class: zimbra::monitor
#
# This class monitors zimbra
#
# POC
#
class zimbra::monitor {

  $enable   = $zimbra::monitor_options_hash['enable'],
  $tool     = $zimbra::monitor_options_hash['tool'],
  $host     = $zimbra::monitor_options_hash['host'],
  $protocol = $zimbra::monitor_options_hash['protocol'],
  $port     = $zimbra::monitor_options_hash['port'],
  $service  = $zimbra::monitor_options_hash['service'],
  $process  = $zimbra::monitor_options_hash['process'],

  if $port and $protocol == 'tcp' {
    monitor::port { "zimbra_port_${protocol}_${port}":
      enable   => $enable,
      tool     => $tool,
      ip       => $host,
      protocol => $protocol,
      port     => $port,
    }
  }
  if $service {
    monitor::service { "zimbra_service_${service}":
      enable   => $enable,
      tool     => $tool,
      service  => $service,
    }
  }


}
