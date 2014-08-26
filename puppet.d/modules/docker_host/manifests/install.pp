include 'docker'

# install docker
class docker_host::install {
  class { 'docker':
    version         => '1.1.2',
    manage_kernel   => false,
    socket_bind     => 'unix:///var/run/docker.sock',
  }
}
