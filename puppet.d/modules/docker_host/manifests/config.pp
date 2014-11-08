include 'docker'

# configure the docker host:
# - make vagrant use the socket
# - patch in default password (vagrant), so users can log in on tty
# - pull image
class docker_host::config {
  # - give vagrant user(group) access to docker socket
  user { 'vagrant':
    groups    => 'docker',
    password => '$6$PItmuCw3$GhVuRvitKtZOgufjE5e60pbOQvwi89We8AXYo7m1ARIecED7sjHN1q4Bqgru4S6qrFPQZ46jkGln.XiHzgK4P.'
  }

  # disable UFW
  service { 'ufw':
    enable => true,
    ensure => stopped
  }
}
