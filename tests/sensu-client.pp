class { '::sensu':
  rabbitmq_password => 'correct-horse-battery-staple',
  rabbitmq_host     => '192.168.56.10',
  rabbitmq_vhost    => '/sensu',
  subscriptions     => 'all',
  client_address    => $::ipaddress_eth1,
}

file { '/etc/sensu/conf.d/transport.json':
  ensure   => 'present',
  owner    => 'sensu',
  group    => 'sensu',
  mode     => '0555',
  content  => '
{
  "transport": {
    "name": "rabbitmq",
    "reconnect_on_error": true
  }
}
',
  notify  => Service['sensu-client'],
}
