notify { 'Installing Zimbra Collaboration Server': }

class { 'zimbra':
  debug => true,
}

