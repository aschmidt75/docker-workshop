include 'docker'

# configure the docker host:
# - make vagrant use the socket
# - pull image
class docker_host::config {
  # - give vagrant user(group) access to docker socket
  user { 'vagrant':
    groups   => 'docker'
  }

  # disable UFW
  service { 'ufw':
    enable => true,
    ensure => stopped
  }
}
