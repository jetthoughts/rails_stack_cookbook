deployer = node['rails-stack']['deployer']

group deployer

user deployer do
  gid deployer
  comment 'Deployer User'
  shell '/bin/bash'
  manage_home true
  # somerandompassword
  password '$6$/MLZ1/yCXsle3Rgn$2d/128Nmj80Nc.cQBns4YbeV.rzSjd4ZMfxo/GbXteQ/KEvGbY8bi87eGSF.Hkb5UpvLT62sjogUMwZWArAX3/'
end

directory "/home/#{deployer}/.ssh" do
  recursive true
  owner deployer
  group deployer
  mode '0700'
end

key = node['rails-stack']['authorized_keys']

# Get authorized keys from the bag
if key.empty?
  deployer_bag = data_bag_item('keys', 'deployer')
  key = [bag['authorized_keys']] if deployer_bag
end

unless key.empty?
  template "/home/#{deployer}/.ssh/authorized_keys" do
    source 'user/authorized_keys.erb'
    variables({ key: key })
    owner deployer
    group deployer
  end
end

sudo deployer do
  user deployer
  commands ['/usr/bin/monit', '/etc/init.d/nginx', '/etc/init.d/monit']
  nopasswd true
end
