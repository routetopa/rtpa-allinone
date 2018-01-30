#
# Cookbook:: rtpa-allinone
# Recipe:: database
#
# Installs MySQL.
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Load passwords
# ------------------------------------------------------------------------------
passwords = data_bag_item('passwords', 'default')

# Configure the MySQL client.
# ------------------------------------------------------------------------------
mysql_client 'default' do
  action :create
end

# Configure the MySQL service.
# ------------------------------------------------------------------------------
mysql_service 'default' do
  initial_root_password passwords['sys_mysql_admin_password']
  port                  node['sys']['mysql']['port']
  action                [:create, :start]
end

# Install the mysql2 Ruby gem.
# ------------------------------------------------------------------------------
mysql2_chef_gem 'default' do
  action :install
end
