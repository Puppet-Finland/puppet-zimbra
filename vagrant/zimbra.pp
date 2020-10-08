notify { 'Installing Zimbra Collaboration Server': }

class { '::zimbra':

  fqdn_interface => 'eth1',
  options_hash => {
    'SMTPDEST'                                => 'info@example.com',
    'SMTPHOST'                                => $facts['fqdn'],
    'SMTPSOURCE'                              => 'info@example.com',
    'zimbraDNSMasterIP'                       => '10.42.42.42',
    'zimbraPrefTimeZoneId'                    => 'Europe/Helsinki',
    'zimbraFeatureBriefcasesEnabled'          => 'Disabled',
    'zimbraFeatureTasksEnabled'               => 'Disabled',
    'zimbraVersionCheckNotificationEmail'     => 'info@example.com',
    'zimbraVersionCheckNotificationEmailFrom' => 'info@example.com',
    'ldap_bes_searcher_password'              => 'changeit',
    'ldap_nginx_password'                     => 'changeit',
    'mailboxd_keystore_password'              => 'changeit',
    'mailboxd_truststore_password'            => 'changeit',
  }
}


