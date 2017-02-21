# Class: docker_auth
#
# This module manages docker_auth
#
# [*manage_as*]
#   How to manage the authentication service. Valid values are: service, container
#   Defaults to service
#
# [*container_image*]
#   From where to pull the image.
#   Defaults to docker.io/cesanta/docker_auth:latest
#
# [*package_name*]
#   Name of package to be installed
#   Defaults to docker_auth
#
# [*package_ensure*]
#   Passed to the package resource.
#   Defaults to present
#
# [*config_file*]
#   Path to config file
#   Defaults to /etc/docker_auth/auth_config.yml
#
# [*service_name*]
#   Name of service to start
#   Defaults to docker_auth
#
# [*service_ensure*]
#   Whether you want to docker_auth to start up
#   Defaults to running
#
# [*service_enable*]
#   Whether you want to docker_auth to start up at boot
#   Defaults to true
#
# [*server_addr*]
#   Address and port where the server should listen to
#   Defaults to ':5001'
#
# [*server_certificate*]
#   Public part of the certificate used to sign the tokens
#   Defaults to "${::settings::ssldir}/certs/${::clientcert}.pem"
#
# [*server_key*]
#   Private part of the certificate used to sign the tokens
#   Defaults to "${::settings::ssldir}/private_keys/${::clientcert}.pem"
#
# [*token_issuer*]
#   Must match issuer in the Registry config.
#   Defaults to 'Auth Service'
#
# [*token_expiration*]
#   How long the token is valid
#   Defaults to 900
#
# [*users*]
#   Hash with users definition. Example:
# 	  $users = {
# 	    "admin" => {
# 	      "password" => '$2y$05$LO.vzwpWC5LZGqThvEfznu8qhb5SGqvBSWY1J3yZ4AxtMRZ3kN5jC',
# 	    },
# 	    "" => {},
# 	  }
#   Defaults to { "" => {} } (unauthenticated users)
#
# [*acls*]
#   Array with acls. Example:
# 	  $acls = [{
# 	      "match"   => { "account" => "" },
# 	      "actions" => ["*"],
# 	      "comment"=> "Allow everything from all",
# 	    },
# 	    {
# 	      "match" => {
# 	        "ip"   => "127.0.0.0/8",
# 	        "name" => "test-*",
# 	      },
# 	      "actions" => ["pull"],
# 	    }
# 	  ]
#   Defaults to [{ "match"   => { "account" => "" }, "actions" => ["*"] } ] (allow all for all accounts)
#
class docker_auth (
  $manage_as          = $::docker_auth::params::manage_as,
  $container_image    = $::docker_auth::params::container_image,
  $package_name       = $::docker_auth::params::package_name,
  $package_ensure     = $::docker_auth::params::package_ensure,
  $service_name       = $::docker_auth::params::service_name,
  $service_ensure     = $::docker_auth::params::service_ensure,
  $service_enable     = $::docker_auth::params::service_enable,
  #
  $server_addr        = $::docker_auth::params::server_addr,
  $server_certificate = $::docker_auth::params::server_certificate,
  $server_key         = $::docker_auth::params::server_key,
  $token_issuer       = $::docker_auth::params::token_issuer,
  $token_expiration   = $::docker_auth::params::token_expiration,
  $users              = $::docker_auth::params::users,
  $acls               = $::docker_auth::params::acls,
) inherits docker_auth::params {
  validate_re($manage_as, '^(service|container)$')

  contain ::docker_auth::install
  contain ::docker_auth::config
  contain ::docker_auth::service

  if $manage_as == 'service' {
    Class['::docker_auth::install'] ->
    Class['::docker_auth::config'] ~>
    Class['::docker_auth::service']
  } elsif $manage_as == 'container' {
    # dir path for $config_file needs to be created outside of this module
    Class['::docker_auth::config'] ->
    Class['::docker_auth::install'] ~>
    Class['::docker_auth::service']
  }
}
