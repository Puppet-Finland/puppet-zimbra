#
# @summary Manage Zimbra Collaboration Server install
#
# @param required_packages
#   Required packages for the osfamily
# @param absent_packages
#    Packages that need to be absent
# @param install_source
#   Install source for ZCS
# @param install_destination
#   Installation destination
# @param options_hash
#   options to override defaults
# @param fqdn_interface
#   The interface for the fully qualified interface
# @param default_options
#   Default options
# @param $default_configs_template
#   Default configs_template
# @param debug
#   Debug option
class zimbra(
  Array[String] $required_packages,
  String $install_source,
  String $install_destination,
  Hash $default_options,
  Hash $options_hash,
  String $fqdn_interface,
  String $default_configs_template,
  Optional[Array[String]] $absent_packages = undef,
  Enum['true', 'false', 'on_failure'] $debug = 'on_failure',
  String $default_locale = 'en_US.UTF-8',
) {

  contain 'zimbra::install'
  contain 'zimbra::config'
  contain 'zimbra::service'

  Class['zimbra::install']
  -> Class['zimbra::config']
  -> Class['zimbra::service']

  Class['zimbra::config'] ~> Class['zimbra::service']
}
