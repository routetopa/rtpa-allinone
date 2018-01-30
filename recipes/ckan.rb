#
# Cookbook:: rtpa-allinone
# Recipe:: ckan
#
# Installs CKAN
#
# Copyright:: 2017, The Authors, All Rights Reserved.
#
# http://docs.ckan.org/en/latest/maintaining/installing/install-from-package.html

# Retrieve passwords
# ------------------------------------------------------------------------------
passwords = data_bag_item('passwords', 'default')

# Store database connection details
# ------------------------------------------------------------------------------
pg_connection = {
  :host      => node['ckan']['pg']['host'],
  :port      => node['ckan']['pg']['port'],
  :password  => passwords['sys_pg_admin_password'],
  :username  => node['sys']['pg']['admin_username']
}

# Install the mod_wsgi Apache module.
# ------------------------------------------------------------------------------
httpd_module 'wsgi' do
  instance 'default'
end

# CKAN dependencies
# ------------------------------------------------------------------------------
package %w(nginx libpq5 redis-server git-core)

# Download the latest CKAN version
# ------------------------------------------------------------------------------
remote_file '/tmp/rtpa_tmp_ckan' do
  group    node['sys']['httpd']['group']
  owner    node['sys']['httpd']['user']
  source   'http://packaging.ckan.org/python-ckan_2.7-trusty_amd64.deb'
  action   :nothing
  notifies :install, 'package[python-ckan_2.7-trusty_amd64.deb]', :immediately
end

# Check if there is a new version of CKAN available
# ------------------------------------------------------------------------------
http_request 'HEAD http://packaging.ckan.org/python-ckan_2.7-trusty_amd64.deb' do
  message  ''
  url      'http://packaging.ckan.org/python-ckan_2.7-trusty_amd64.deb'
  if File.exist?('/tmp/rtpa_tmp_ckan')
    headers 'If-Modified-Since' => File.mtime('/tmp/rtpa_tmp_ckan').httpdate
  end
  action   :head
  notifies :create, 'remote_file[/tmp/rtpa_tmp_ckan]', :immediately
end

# Install PostreSQL
# ------------------------------------------------------------------------------
node.default['postgresql']['password']['postgres'] = passwords['sys_pg_admin_password']
include_recipe 'postgresql::ruby'
include_recipe 'postgresql::client'
include_recipe 'postgresql::server'

# Install CKAN
# ------------------------------------------------------------------------------
package 'python-ckan_2.7-trusty_amd64.deb' do
  provider Chef::Provider::Package::Dpkg
  source   '/tmp/rtpa_tmp_ckan'
  action   :install
end

# Create database 
# ------------------------------------------------------------------------------
postgresql_database node['ckan']['pg']['name'] do
  connection pg_connection
  encoding   'utf-8'
  action     :create
end

# Create database's user and grant permissions
# ------------------------------------------------------------------------------
postgresql_database_user node['ckan']['pg']['user'] do
  database_name node['ckan']['pg']['name']
  connection    pg_connection
  createdb      false
  createrole    false
  password      passwords['ckan_pg_password']
  username      node['ckan']['pg']['user'] 
  superuser     false
  action [:create, :grant]
end

# Install Apache Solr and Jetty
# ------------------------------------------------------------------------------
package 'solr-jetty' 

# Start Jetty
# ------------------------------------------------------------------------------
service 'jetty' do
  action :start
end

# Load Jetty configuration file
# ------------------------------------------------------------------------------
template '/etc/default/jetty' do
  source 'jetty/jetty.erb'
  owner 'root'
  group 'root'
  notifies :restart, 'service[jetty]'
end

# Copy CKAN's custom Schema to Jetty
# ------------------------------------------------------------------------------
file '/etc/solr/conf/schema.xml' do
  owner 'root'
  group 'root'
  content lazy { ::File.open('/usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml').read }
  action :create
  notifies :restart, 'service[jetty]'
end

# Load CKAN configuration file
# ------------------------------------------------------------------------------
template '/etc/ckan/default/production.ini' do
  source 'ckan/production.ini.erb'
  owner 'root'
  group 'root'
  variables( ckan_pg_password: passwords['ckan_pg_password'] )
  #notifies :restart, 'service[jetty]'
end

# Enable CKAN in Apache configuration
# ------------------------------------------------------------------------------
httpd_config 'ckan' do
  instance 'default'
  source 'apache/ckan.conf.erb'
  notifies :restart, 'httpd_service[default]'
end

# Enable Datapusher in Apache configuration
# ------------------------------------------------------------------------------
httpd_config 'datapusher' do
  instance 'default'
  source 'apache/datapusher.conf.erb'
  notifies :restart, 'httpd_service[default]'
end

# Initialize CKAN database
# ------------------------------------------------------------------------------
execute 'ckan_db_init'  do
  command 'ckan db init'
  user 'root'
end

# Enable site in nginx configuration
# ------------------------------------------------------------------------------
template '/etc/nginx/sites-enabled/rtpa' do
  source 'nginx/default'
  owner 'root'
  group 'root'
end

file '/etc/nginx/sites-enabled/ckan' do
  action :delete
end

service 'nginx' do
  action :restart
end