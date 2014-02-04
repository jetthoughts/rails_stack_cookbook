# User deployer
include_recipe 'rails-stack::user'
include_recipe 'rails-stack::sudoers'
include_recipe 'rails-stack::lib_directory'

include_recipe 'rails-stack::packages'

include_recipe 'rails-stack::ruby'

# Postfix - local smtp server
include_recipe 'postfix'

# Memcached service
include_recipe 'memcached'

# Postgresql
include_recipe 'rails-stack::pgdg'

# Rails applications
include_recipe 'rails-stack::applications'
