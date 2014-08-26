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

  # get us our trusty image..
  docker::image { 'ubuntu':
      image_tag => '14.04',
      before    => Notify['Pulling docker images...']
  }
  notify { 'Pulling docker images...': }
}
