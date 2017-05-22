# docker_auth #

[![Build Status](https://travis-ci.org/cristifalcas/puppet-docker_auth.png?branch=master)](https://travis-ci.org/cristifalcas/puppet-docker_auth)

Puppet module for installing, configuring and managing a docker 2.0 authorization server
([specifically cesanta implementation](https://github.com/cesanta/docker_auth))

## Support

This module is currently only for RedHat clones 7.x:

In order to print the yaml config file, we are using
some lib files from [puppet-elasticsearch](https://github.com/elastic/puppet-elasticsearch) module.


## Usage:

          include docker_auth


### Install distribution and docker_auth (on machine distribution-01.company.net):

If you want to start the server from a container (manage_as => 'container'), you will need to create
the folder where $config_file will be written, outside of this module:

		  file { '/etc/docker_auth/': ensure => 'directory', }
		  class { '::docker_distribution':
		    manage_as                    => 'container',
		    container_image              => 'docker.io/registry:2.6.0',
		    http_tls                     => true,
		    storage_delete               => true,
		    auth_type                    => 'token',
		    auth_token_realm             => "https://${::fqdn}:5002/auth",
		    auth_token_issuer            => 'Auth Service',
		    auth_token_rootcertbundle    => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
		  }

		  class { '::docker_auth':
		    manage_as           => 'container',
		    container_image     => 'docker.io/cesanta/docker_auth:1.2',
       		     container_log_local => false,
		    server_addr         => ':5002',
		  }

Note that if you set container_log_local to true (default is false), logs from the docker_auth container will be written to a directory, /var/log/docker_auth on the docker engine system.

### Use the above for a local docker distribution proxy (works only with distribution version 2.6 and up):

		  class { '::docker_distribution':
		    manage_as                    => 'container',
		    container_image              => 'docker.io/registry:2.6.0',
		    http_tls                     => true,
		    storage_delete               => true,
		    proxy_remoteurl              => 'https://distribution-01.company.net',
		  }
