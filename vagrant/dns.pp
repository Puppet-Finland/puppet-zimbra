class { "unbound":
  interface => ["::0","0.0.0.0"],
  access    => ["10.0.0.0/8","::1"],
}

unbound::stub { "example.com":
  address  => [ '10.42.42.42'],
  insecure => true,
}

unbound::record { 'soa':
  entry   => 'example.com',
  type    => 'SOA',
  content => 'ns1.example.com. someone.cool. 1 3600 1200 604800 10800',
}

unbound::record { 'ns':
  entry   => 'example.com',
  type    => 'NS',
  content => 'ns1.example.com',
}

unbound::record { 'ns1':
  entry   => 'ns1.example.com',
  type    => 'A',
  content => '10.42.42.42',
}

unbound::record { 'a':
  entry   => 'zimbra.example.com',
  type    => 'A',
  content => '10.42.42.42',
}

unbound::record { 'ptr':
  entry   => 'zimbra.example.com',
  type    => 'PTR',
  reverse => true,
  content => '10.42.42.42',
}

unbound::record { 'mx':
  entry => 'example.com',
  type    => 'MX',
  content => '10 zimbra.example.com',
}

unbound::forward { '.':
  address => [
    '8.8.8.8',
    '8.8.4.4'
    ]
}

class { 'resolv_conf':
  nameservers => ['10.42.42.42'],
}
