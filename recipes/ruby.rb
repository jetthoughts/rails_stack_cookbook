# Rbenv
include_recipe 'rbenv'
include_recipe 'rbenv::ruby_build'
include_recipe 'rbenv::rbenv_vars'

# Create tmp directories
directory "#{node['rails-stack']['data_path']}/tmp" do
  recursive true
  mode '0777'
end
ENV['TMPDIR'] = "#{node['rails-stack']['data_path']}/tmp"
rbenv_ruby node[:ruby][:version]

directory "#{node[:rbenv][:root_path]}/versions" do
  recursive true
  owner node[:rbenv][:user]
  group node[:rbenv][:group]
end

rbenv_execute 'gem update --system' do
  ruby_version node[:ruby][:version]
end

rbenv_gem 'bundler' do
  ruby_version node[:ruby][:version]
end

include_recipe 'rails-stack::rbenv_wrapper'
