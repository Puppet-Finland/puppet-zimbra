#
# = Class: zimbra::firewall
#
# This class firewalls zimbra
#
# POC
#
class zimbra::firewall {

  $enable          = $zimbra::firewall_options_hash['enable'],
  $tool            = $zimbra::firewall_options_hash['tool'],
  $host            = $zimbra::firewall_options_hash['host'],
  $port            = $zimbra::firewall_options_hash['port'],
  $protocol        = $zimbra::firewall_options_hash['protocol'],
  $source_ip4      = $zimbra::firewall_options_hash['source_ip4'],
  $destination_ip4 = $zimbra::firewall_options_hash['destination_ip4'],
  $source_ip6      = $zimbra::firewall_options_hash['source_ip6'],
  $destination_ip6 = $zimbra::firewall_options_hash['destination_ip6'],

  if $port {
    firewall::port { "zimbra_${protocol}_${port}":
      enable   => $enable,
      ip       => $host,
      protocol => $protocol,
      port     => $port,
      tool     => $tool,
    }
  }
}
