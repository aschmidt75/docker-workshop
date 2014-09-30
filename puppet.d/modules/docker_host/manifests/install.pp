include 'docker'

# install docker
class docker_host::install {
  class { 'docker':
    version         => '1.2.0',
    manage_kernel   => false,
    socket_bind     => 'unix:///var/run/docker.sock',
  }
}
