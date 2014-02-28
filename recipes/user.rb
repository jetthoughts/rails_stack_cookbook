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

directory "/home/#{deployer}" do
  owner deployer
  group deployer
end

Chef::Log.info("I am a message from the #{recipe_name} recipe in the #{cookbook_name} cookbook.")

key = node['rails-stack']['authorized_keys']
authorized_keys_file = "/home/#{deployer}/.ssh/authorized_keys"

if !key.empty?
  template authorized_keys_file do
    source 'user/authorized_keys.erb'
    variables({ key: key })
    owner deployer
    group deployer
  end
else

  execute "create_authorized_keys_file" do
    command "cp /root/.ssh/authorized_keys #{authorized_keys_file} && chown #{deployer}:#{deployer} #{authorized_keys_file}"
    creates authorized_keys_file
  end

end
