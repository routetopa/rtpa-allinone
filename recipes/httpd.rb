#
# Cookbook:: rtpa-allinone
# Recipe:: httpd
#
# Installs Apache and PHP
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Install Apache and start the service.
# ------------------------------------------------------------------------------
httpd_service 'default' do
  listen_ports [ node['ckan']['port'], node['spod']['port'], node['wordpress']['port'], node['oauth2']['port'] ]
  mpm          'prefork'
  action       [:create, :start]
  subscribes   :restart, 'httpd_config[default]'
end

# Install the mod_rewrite Apache module.
# ------------------------------------------------------------------------------
httpd_module 'rewrite' do
  instance 'default'
end

# Add PHP 7 repository
# ------------------------------------------------------------------------------
apt_repository 'apache-php7' do
  uri 'ppa:ondrej/php'
end

# Remove php5 Apache module
# ------------------------------------------------------------------------------
httpd_module 'php5' do
  instance 'default'
  action   :delete
end

# Install php7 Apache module
# ------------------------------------------------------------------------------
httpd_module 'php7.0' do
  filename     'libphp7.0.so'
  instance     'default'
  module_name  'php7'
  package_name 'libapache2-mod-php7.0'
  notifies     :restart, 'httpd_service[default]'
end

# Install required php modules
# ------------------------------------------------------------------------------
package %w(php7.0-curl php7.0-gd php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-xml php7.0-zip) do
  action   :install
  notifies :restart, 'httpd_service[default]'
end