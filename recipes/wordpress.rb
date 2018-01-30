#
# Cookbook:: rtpa-allinone
# Recipe:: wordpress
#
# Installs Wordpress. This recipe is based on:
# https://peteris.rocks/blog/unattended-installation-of-wordpress-on-ubuntu-server/
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Retrieve mysql password
# ------------------------------------------------------------------------------
passwords = data_bag_item('passwords', 'default')

# Store database connection details
# ------------------------------------------------------------------------------
db_connection = {
  :host     => node['wordpress']['mysql']['host'],
  :port     => node['wordpress']['mysql']['port'],
  :username => 'root',
  :password => passwords['sys_mysql_admin_password'],
  :socket   => "/var/run/mysql-default/mysqld.sock"
}

# Create the document root directory
# ------------------------------------------------------------------------------
directory node['wordpress']['root'] do
  recursive true
  user      node['sys']['httpd']['user']
  group     node['sys']['httpd']['group']
end

# Enable site in Apache configuration
# ------------------------------------------------------------------------------
httpd_config 'wordpress' do
  source   'apache/wordpress.conf.erb'
  notifies :restart, 'httpd_service[default]'
end

httpd_service 'default' do
  action :restart
end

# Download the latest Wordpress version
# ------------------------------------------------------------------------------
remote_file '/tmp/rtpa_tmp_wordpress' do
  source   'https://wordpress.org/latest.tar.gz'
  owner    node['sys']['httpd']['user']
  group    node['sys']['httpd']['group']
  action   :nothing
  notifies :extract_local, 'tar_extract[/tmp/rtpa_tmp_wordpress]', :immediately
end

# Check if there is a new version of Wordpress available
# ------------------------------------------------------------------------------
http_request 'HEAD https://wordpress.org/latest.tar.gz' do
  message  ''
  url      'https://wordpress.org/latest.tar.gz'
  if File.exist?('/tmp/rtpa_tmp_wordpress')
    headers 'If-Modified-Since' => File.mtime('/tmp/rtpa_tmp_wordpress').httpdate
  end
  action   :head
  notifies :create, 'remote_file[/tmp/rtpa_tmp_wordpress]', :immediately
end

# Extract Wordpress
# ------------------------------------------------------------------------------
tar_extract '/tmp/rtpa_tmp_wordpress' do
  target_dir node['wordpress']['root']
  user       node['sys']['httpd']['user']
  group      node['sys']['httpd']['group']
  creates    "#{node['wordpress']['root']}/wp-settings.php"
  tar_flags  [ '-P', '--strip-components 1' ]
  action     :extract_local
end

# Load configuration file
# ------------------------------------------------------------------------------
template "#{node['wordpress']['root']}/wp-config.php" do
  source    'wordpress/wp-config.php.erb'
  variables( wordpress_mysql_password: passwords['wordpress_mysql_password'] )
  owner     node['sys']['httpd']['user']
  group     node['sys']['httpd']['group']
end

# Create database
# ------------------------------------------------------------------------------
mysql_database node['wordpress']['mysql']['name'] do
  connection db_connection
  action     :create
end

# Create database user and grant permissions
# ------------------------------------------------------------------------------
mysql_database_user node['wordpress']['mysql']['user'] do
  username   node['wordpress']['mysql']['user']
  password   passwords['wordpress_mysql_password']
  connection db_connection
  action     [:create, :grant]
end

# Launch the installer
# ------------------------------------------------------------------------------
http_request 'wordpress_configure' do
  url "#{node['wordpress']['url']}/wp-admin/install.php?step=2"
  message URI.encode_www_form(
      :weblog_title    => node['wordpress']['title'],
      :user_name       => node['wordpress']['admin']['username'],
      :admin_email     => node['wordpress']['admin']['email'],
      :admin_password  => passwords['admin_password'],
      :admin_password2 => passwords['admin_password'],
      :pw_weak         => '1'
    )
  action :post
end

# Update configuration
# ------------------------------------------------------------------------------
mysql_database node['wordpress']['mysql']['name'] do
  connection db_connection
  sql        "UPDATE #{node['wordpress']['mysql']['prefix']}options SET option_value = '#{node['wordpress']['url']}' where option_name='siteurl'"
  action     :query
end

mysql_database node['wordpress']['mysql']['name'] do
  connection db_connection
  sql        "UPDATE #{node['wordpress']['mysql']['prefix']}options SET option_value = '#{node['wordpress']['url']}' where option_name='home'"
  action     :query
end

# Load .htaccess
# ------------------------------------------------------------------------------
template "#{node['wordpress']['root']}/.htaccess" do
  source 'wordpress/htaccess.erb'
  owner node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end
