general_packages = case node['platform_family']
                   when 'debian', 'ubuntu'
                     include_recipe 'apt'
                     %w(libreadline6 libreadline6-dev git autoconf libssl-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev libpq-dev)
                   when 'rhel'
                     %w(git openssl-devel libyaml-devel readline readline-devel zlib-devel gcc curl-devel httpd-devel apr-devel apr-util-devel sqlite-devel libxml2-devel libxslt-devel )
                   else
                     raise node['platform_family']
                   end

general_packages.each do |pack|
  package pack do
    action :install
  end
end

node['rails-stack']['packages'].each do |pack|
  package pack do
    action :install
  end
end
