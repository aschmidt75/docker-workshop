class docker_host {
  class { 'docker_host::install': }
  class { 'docker_host::config': }
  class { 'docker_host::run': }

  Class['docker_host::install'] 
    -> Class['docker_host::config']
      -> Class['docker_host::run']
}
