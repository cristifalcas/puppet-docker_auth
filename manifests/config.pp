class docker_auth::config {
  file { $docker_auth::config_file:
    ensure  => 'file',
    owner   => root,
    group   => root,
    mode    => '0640',
    content => template("${module_name}/auth_config.yml.erb"),
  }
}
