include 'docker'

# install docker
class docker_host::install {
  class { 'docker':
    version         => '1.3.1',
    manage_kernel   => false,
    socket_bind     => 'unix:///var/run/docker.sock',
  }
}
