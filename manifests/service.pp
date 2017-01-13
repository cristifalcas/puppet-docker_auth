class docker_auth::service {
  if $docker_auth::manage_as == 'service' {
    service { $docker_auth::service_name:
      ensure => $docker_auth::service_ensure,
      enable => $docker_auth::service_enable,
    }
  } else {
    service { $docker_auth::service_name:
      ensure => 'stopped',
      enable => false,
    }
  }
}
