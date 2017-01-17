class docker_auth::params {
  $manage_as = 'service'
  $container_image = 'docker.io/cesanta/docker_auth:latest'

  $package_name = 'docker_auth'
  $service_name = 'docker_auth'
  $config_file = '/etc/docker_auth/auth_config.yml'

  $package_ensure = 'installed'
  $service_ensure = 'running'
  $service_enable = true

  $server_addr = ':5001'
  $server_certificate = "${::settings::ssldir}/certs/${::clientcert}.pem"
  $server_key = "${::settings::ssldir}/private_keys/${::clientcert}.pem"

  $token_issuer = 'Auth Service'
  $token_expiration = 900

  # Allow anonymous (no "docker login") access.
  $users = { '' => {} }

  # full acls for everybody:
  $acls = [{
      'match'   => { account => '' },
      'actions' => ['*'],
      'comment' => 'Allow everything from all',
    },
  ]
}
