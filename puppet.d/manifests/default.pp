
notify { "Provisioning of ${hostname}": }

class { 'docker_host': }

# add our own demo user
group { 'demo':
  ensure => present,
}

user { 'demo':
  ensure     => present,
  comment    => 'Docker Workshop demo user',
  gid        => 'demo',
  password   => '$6$ZGnLbCrs$ZtuArdZZT.dc/U1gUj5VrkgtetclrPweXW7raElTYZV8Vkc1k49BgreZaCV8/nDKKGLt726ewcMSM/D7Z8fz21',
  managehome => true,
  shell      => '/bin/bash',
  require    => [ Group['demo']  ]
}

# manage a sudoers file
file { '/etc/sudoers.d/demo':
  owner   => 'root',
  group   => 'root',
  mode    => '0440',
  content => 'demo ALL=(ALL) NOPASSWD:ALL'
}

# install additional packages
package { [ 'bridge-utils', 'apache2' ]:
  ensure => installed
}

service { 'apache2':
  ensure  => running,
  enable  => true,
  require => Package['apache2']
}


