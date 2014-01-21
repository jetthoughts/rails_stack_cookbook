include_recipe 'rails-stack::nginx_applications'
include_recipe 'rails-stack::unicorn_applications'
include_recipe 'rails-stack::delayed_job_applications'
include_recipe 'rails-stack::logrotate_applications'
