# just a plain ping

Chef::Log.info "Ping #{node[:name]}"

execute 'ping-it' do
  command 'echo Pong from `hostname`'
  action :run
end
