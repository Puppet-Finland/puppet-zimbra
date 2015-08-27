# Puppet module: zimbra

This is a Puppet module for zimbra.
It manages its installation, configuration and service.

The module is based on stdmod naming standars.
Refer to http://github.com/stdmod/

Released under the terms of Apache 2 License.

NOTE: This module is to be considered a POC, that uses the stdmod naming conventions.
For development time reasons the module currently uses some Example42 modules and prerequisites.

## USAGE - Basic management

* Install zimbra with default package, settings and dependencies

        class { 'zimbra': }

* Install zimbra fetching the upstream tarball

        class { 'zimbra':
          install => 'upstream',
          version => '0.90.2',
        }

* Remove zimbra package and purge all the managed files

        class { 'zimbra':
          ensure => absent,
        }

* Create an zimbra user with defined settings

        class { 'zimbra':
          install     => 'upstream',
          user_create => true, # Default
          user_uid    => '899',
        }

* Do not create an zimbra user when installing via upstream
  (You must provide it in othr ways)

        class { 'zimbra':
          install     => 'upstream',
          user_create => false,
        }

* Manage Java settings

        class { 'zimbra':
          java_heap_size => '2048', # Default: 1024
        }

* Specify a custom template to use for the init script and its path

        class { 'zimbra':
          init_script_file           = '/etc/init.d/zimbra', # Default
          init_script_file_template  = 'site/zimbra/init.erb',
        }

* Provide a custom configuration file for the init script (here you can better tune Java settings)

        class { 'zimbra':
          init_options_file_template  = 'site/zimbra/init_options.erb',
        }


* Do not automatically restart services when configuration files change (Default: Class['zimbra::config']).

        class { 'zimbra':
          service_subscribe => false,
        }

* Enable auditing (on all the arguments)

        class { 'zimbra':
          audit => 'all',
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'zimbra':
          noop => true,
        }


## USAGE - Overrides and Customizations
* Use custom source for main configuration file

        class { 'zimbra':
          file_source => [ "puppet:///modules/example42/zimbra/zimbra.conf-${hostname}" ,
                           "puppet:///modules/example42/zimbra/zimbra.conf" ],
        }


* Use custom source directory for the whole configuration dir.

        class { 'zimbra':
          dir_source  => 'puppet:///modules/example42/zimbra/conf/',
        }

* Use custom source directory for the whole configuration dir purging all the local files that are not on the dir.
  Note: This option can be used to be sure that the content of a directory is exactly the same you expect, but it is desctructive and may remove files.

        class { 'zimbra':
          dir_source => 'puppet:///modules/example42/zimbra/conf/',
          dir_purge  => true, # Default: false.
        }

* Use custom source directory for the whole configuration dir and define recursing policy.

        class { 'zimbra':
          dir_source    => 'puppet:///modules/example42/zimbra/conf/',
          dir_recursion => false, # Default: true.
        }

* Use custom template for main config file. Note that template and source arguments are alternative.

        class { 'zimbra':
          file_template => 'example42/zimbra/zimbra.conf.erb',
        }

* Use a custom template and provide an hash of custom configurations that you can use inside the template

        class { 'zimbra':
          filetemplate       => 'example42/zimbra/zimbra.conf.erb',
          file_options_hash  => {
            opt  => 'value',
            opt2 => 'value2',
          },
        }


* Specify the name of a custom class to include that provides the dependencies required by the module

        class { 'zimbra':
          dependency_class => 'site::zimbra_dependency',
        }


* Automatically include a custom class with extra resources related to zimbra.
  Here is loaded $modulepath/example42/manifests/my_zimbra.pp.
  Note: Use a subclass name different than zimbra to avoid order loading issues.

        class { 'zimbra':
          my_class => 'site::my_zimbra',
        }

* Specify an alternative class where zimbra monitoring is managed

        class { 'zimbra':
          monitor_class => 'site::monitor::zimbra',
        }

* Enable and configure monitoring (with default zimbra::monitor)

        class { 'zimbra':
          monitor             = true,                  # Default: false
          monitor_host        = $::ipaddress_eth0,     # Default: $::ipaddress
          monitor_port        = 9200,                  # Default
          monitor_tool        = [ 'nagios' , 'monit' ] # Default: ''
        }

* Enable and configure firewalling (with default zimbra::firewall)

        class { 'zimbra':
          firewall             = true,                  # Default: false
          firewall_src         = '10.0.0.0/24,          # Default: 0/0
          firewall_dst         = $::ipaddress_eth0,     # Default: 0/0
          firewall_port        = 9200,                  # Default
        }


## TESTING
[![Build Status](https://travis-ci.org/stdmod/puppet-zimbra.png?branch=master)](https://travis-ci.org/stdmod/puppet-zimbra)
