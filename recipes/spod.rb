#
# Cookbook:: rtpa-allinone
# Recipe:: spod
#
# Installs SPOD.
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Retrieve mysql password
# ------------------------------------------------------------------------------
passwords = data_bag_item('passwords', 'default')

# Store database connection details
# ------------------------------------------------------------------------------
mysql_connection = {
  :host => node['spod']['mysql']['host'],
  :port => node['spod']['mysql']['port'],
  :username => 'root',
  :password => passwords['sys_mysql_admin_password'],
  :socket => "/var/run/mysql-default/mysqld.sock"
}

# Install Composer
# ------------------------------------------------------------------------------
include_recipe 'composer'

# Create the document root directory
# ------------------------------------------------------------------------------
directory node['spod']['root'] do
  recursive true
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

# Clone the spod-core repository into document root directory
# ------------------------------------------------------------------------------
git node['spod']['root'] do
  repository 'https://github.com/routetopa/spod-core.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

# Clone the plugins and theme repositories
# ------------------------------------------------------------------------------
include_recipe 'rtpa-allinone::spod_plugins'

# Update spod-core Composer packages
# ------------------------------------------------------------------------------
composer_project node['spod']['root'] do 
  dev false
  prefer_dist true
  action :update
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

# Load .htaccess
# ------------------------------------------------------------------------------
template "#{node['spod']['root']}/.htaccess" do
  source 'spod/htaccess.erb'
  owner node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

# Load configuration file
# ------------------------------------------------------------------------------
template "#{node['spod']['root']}/ow_includes/config.php" do
  source 'spod/config.php.erb'
  variables( spod_mysql_password: passwords['spod_mysql_password'] )
  owner node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

# Create database
# ------------------------------------------------------------------------------
mysql_database node['spod']['mysql']['name'] do
  connection mysql_connection
  action :create
end

# Create database user and grant permissions
# ------------------------------------------------------------------------------
mysql_database_user node['spod']['mysql']['user'] do
  username node['spod']['mysql']['user']
  password passwords['spod_mysql_password']
  connection mysql_connection
  action [:create, :grant]
end

# Configure Apache
# ------------------------------------------------------------------------------
httpd_config 'spod' do
  source 'apache/spod.conf.erb'
end

# Import database
# Here we use the 'bash' resource instead of the 'mysql_database' resource,
# since the latter one seems to have problems with large .sql files.
# ------------------------------------------------------------------------------
template '/tmp/spod_import_sql.sql' do
  source 'spod/install.sql.erb'
  variables( service_mail_password: passwords['service_mail_password'],
    service_elasticemail_api_key: passwords['service_mail_password'],
    service_firebase_api_key: passwords['service_firebase_api_key'],
    service_ckan_api_key: passwords['service_ckan_api_key'],
    spod_oauth2_secret_key: passwords['spod_oauth2_secret_key'] )
  owner node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
  action :create_if_missing
  notifies :run, 'bash[spod_import_sql]', :immediate
end

bash 'spod_import_sql' do
  code "mysql -uroot -p#{ passwords['sys_mysql_admin_password'] } -S /var/run/mysql-default/mysqld.sock #{node['spod']['mysql']['name']} < /tmp/spod_import_sql.sql"
  action :nothing
end

# Setup cronjob
# ------------------------------------------------------------------------------
package 'wget'

cron 'spod_cronjob' do
  command "wget #{node['spod']['url']}/ow_cron/run.php"
  action :create
end