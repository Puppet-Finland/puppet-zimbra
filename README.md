# Puppet module: zimbra

This is a Puppet module for zimbra.
It manages its installation, configuration and service.

Released under the terms of Apache 2 License.

## USAGE

* Install zimbra from upstream source (Version NETWORK-8.6.0_GA_1153)

        class { 'zimbra': }

* Install zimbra from a custom source

        class { 'zimbra':
          install_source => 'https://mirror.example.com/zimbra/zcs-NETWORK-8.6.0_GA_1153.UBUNTU14_64.20141215151218.tgz',
        }

* Provide a custom license file (the default one is dummy). The given path is passed to a template() function.

        class { 'zimbra':
          license_template  = 'site/zimbra/ZCSLicense.xml',
        }


* Unattended installation from the upstream source is done via a defaults response file. You can provide your own version of it

        class { 'zimbra':
          defaults_template  = 'site/zimbra/defaults.erb',
        }

Note however that the default template can be fully configured via the options_hash parameter. See Hiera section for details.

* To setup zimbra some prerequisites are needed (packages and hosts entries). They are managed by default in the ```::zimbra::prerequisites``` class. If this clashes with your Puppet setup, provide the same resources in a custom class:

        class { 'zimbra':
          prerequisites_class => '::site::zimbra::prerequisites',
        }

* In case of installation issues you can enable debugging, and see the output of the installation command, with:

        class { 'zimbra':
          debug => true,
        }


## Usage with Hiera

The parameters seen so far, as for any parameter of any class, can be set via Hiera. This is a sample configuration in yaml output where is provided a custom license file, a custom source url and some customisations on the default install settings defined in ```manifests/params.pp```: 

    ---
    zimbra::install_source: 'https://mirror.example.com/zimbra/zcs-NETWORK-8.6.0_GA_1153.UBUNTU14_64.20141215151218.tgz'
    zimbra::license_template: 'site/zimbra/ZCSLicense.xml'
    zimbra::options_hash:
      'SMTPHOST': 'mail.example.com'
      'zimbraMtaMyNetworks': '127.0.0.0/8 10.0.2.0/24 [::1]/128 [fe80::]/64'
      'zimbraPrefTimeZoneIdi': 'Europe/Rome'
      'INSTALL_PACKAGES:'zimbra-core zimbra-logger zimbra-mta zimbra-dnscache zimbra-snmp'

Note that the options_hash settings have the same name of Zimbra installfile, as used in the default ```templates/defaults.erb``` template. We haven't found an online reference for all the settings. For custom settings, for example in distributed environments, it might be needed to make an installation manually, as needed, and then use the created installfile.
 

## TESTING
[![Build Status](https://travis-ci.org/stdmod/puppet-zimbra.png?branch=master)](https://travis-ci.org/stdmod/puppet-zimbra)
