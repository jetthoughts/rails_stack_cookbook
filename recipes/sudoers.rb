deployer = node['rails-stack']['deployer']
sudo deployer do
  user deployer
  commands ['/usr/bin/monit', '/etc/init.d/nginx', '/etc/init.d/monit', '/usr/bin/tail -f /var/log/messages']
  nopasswd true
end
