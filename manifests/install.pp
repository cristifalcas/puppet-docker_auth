class docker_auth::install {
  if $docker_auth::manage_as == 'container' {
    docker::run { $docker_auth::package_name:
      image           => $docker_auth::container_image,
      volumes         => [
        "${docker_auth::config_file}:/config/auth_config.yml",
        "${docker_auth::server_certificate}:${docker_auth::server_certificate}",
        "${docker_auth::server_key}:${docker_auth::server_key}",
        '/var/log/docker_auth:/logs',
      ],
      command         => ' --v=2  -log_dir=/logs  /config/auth_config.yml',
      restart_service => true,
      net             => 'host',
      detach          => false,
      manage_service  => true,
      running         => true,
    }
  } else {
    package { [$docker_auth::package_name]: ensure => $docker_auth::package_ensure, }
  }
}
