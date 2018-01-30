#
# Cookbook:: rtpa-allinone
# Recipe:: oauth2
#
# Installs the ROUTE-TO-PA Auth Server 2
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Retrieve mysql password
# ------------------------------------------------------------------------------
passwords = data_bag_item('passwords', 'default')

# Store database connection details
# ------------------------------------------------------------------------------
db_connection = {
  :host => node['oauth2']['mysql']['host'],
  :port => node['oauth2']['mysql']['port'],
  :username => 'root',
  :password => passwords['sys_mysql_admin_password'],
  :socket => "/var/run/mysql-default/mysqld.sock"
}

# Install Composer
# ------------------------------------------------------------------------------
include_recipe 'composer'

# Create the document root directory
# ------------------------------------------------------------------------------
directory node['oauth2']['root'] do
  recursive true
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

# Enable site in Apache configuration
# ------------------------------------------------------------------------------
httpd_config 'oauth2' do
  source 'apache/oauth2.conf.erb'
  notifies :restart, 'httpd_service[default]'
end

# Clone the git repository into document root directory
# ------------------------------------------------------------------------------
git node['oauth2']['root'] do
  repository 'https://github.com/routetopa/auth-server-2.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

# Update Composer packages
# ------------------------------------------------------------------------------
composer_project node['oauth2']['root'] do 
  dev false
  prefer_dist true
  action :update
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

# Load configuration file
# ------------------------------------------------------------------------------
template "#{node['oauth2']['root']}/.env" do
  source 'oauth2/env.erb'
  variables( oauth2_mysql_password: passwords['oauth2_mysql_password'], service_mail_password: passwords['service_mail_password'] )
  owner node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

# Replace .htaccess
# ------------------------------------------------------------------------------
template "#{node['oauth2']['root']}/public/.htaccess" do
  source 'oauth2/htaccess.erb'
  owner node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

# Create database
# ------------------------------------------------------------------------------
mysql_database node['oauth2']['mysql']['name'] do
  connection db_connection
  action :create
end

# Create database user and grant permissions
# ------------------------------------------------------------------------------
mysql_database_user node['oauth2']['mysql']['user'] do
  username node['oauth2']['mysql']['user']
  password passwords['oauth2_mysql_password']
  connection db_connection
  action [:create, :grant]
end

# Create App key
# ------------------------------------------------------------------------------
bash 'create_app_key' do
  code 'php artisan key:generate'
  cwd node['oauth2']['root']
end

# Update database structure
# ------------------------------------------------------------------------------
bash 'migrate_database' do
  code 'php artisan migrate'
  cwd node['oauth2']['root']
end

# Add the administrator
# ------------------------------------------------------------------------------
bash 'create_administrator' do
  code "php artisan oauth2:user #{node['oauth2']['admin']['email']} #{passwords['admin_password']} 1"
  cwd node['oauth2']['root']
end

# Add the 'authenticate' scope
# ------------------------------------------------------------------------------
bash 'create_scope' do
  code 'php artisan oauth2:scope authenticate 1'
  cwd node['oauth2']['root']
end  

# Add clients
# ------------------------------------------------------------------------------
bash 'create_client_spod_website' do
  code "php artisan oauth2:client spod-website \"#{passwords['spod_oauth2_secret_key']}\" \"#{node['spod']['url']}/spodoauth2connect/oauth\" \"authorization_code refresh_token\" \"authenticate\" \"\" \"\" \"#{node['spod']['url']}\" \"#{node['spod']['url']}/spodoauth2connect/begin\" 1"
  cwd node['oauth2']['root']
end

bash 'create_client_spod_mobile' do
  code "php artisan oauth2:client spod-mobile \"\" \"com.google.codelabs.appauth:/oauth2callback\" \"authorization_code refresh_token\" \"authenticate\" \"\" \"\" \"\" \"\" 1"
  cwd node['oauth2']['root']
end

# Enable JWT
# ------------------------------------------------------------------------------
bash 'enable_jwt' do
  code "php artisan oauth2:jwt_keys spod"
  cwd node['oauth2']['root']
end