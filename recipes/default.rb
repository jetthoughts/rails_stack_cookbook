include_recipe 'rails-stack::packages'

# User deployer
include_recipe 'rails-stack::user'
include_recipe 'rails-stack::sudoers'
include_recipe 'rails-stack::lib_directory'

include_recipe 'rails-stack::ruby'

# Monit
include_recipe 'monit'

# Nginx
include_recipe 'nginx'

# Postfix - local smtp server
include_recipe 'postfix'

# Memcached service
include_recipe 'memcached'

# Logrotate
include_recipe 'logrotate::default'

# Postgresql
include_recipe 'rails-stack::pgdg'

# Rails applications
include_recipe 'rails-stack::applications'

# Monit configurations for services
include_recipe 'rails-stack::monit'
