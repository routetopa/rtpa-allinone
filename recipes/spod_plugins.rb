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

# Install themese
# ------------------------------------------------------------------------------

git "#{node['spod']['root']}/ow_themes/simplicity" do
  repository 'https://github.com/oxwall/simplicity.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_themes/spod_theme_matter" do
  repository 'https://github.com/routetopa/spod-theme-matter'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

# Install plugins
# ------------------------------------------------------------------------------

git "#{node['spod']['root']}/ow_plugins/agora_exporter" do
  repository 'https://github.com/routetopa/spod-plugin-agora-exporter.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/birthdays" do
  repository 'https://github.com/oxwall/birthdays.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/blogs" do
  repository 'https://github.com/oxwall/blogs.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/cacheextreme" do
  repository 'https://github.com/spthaolt/cacheextreme.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/cloudflare" do
  repository 'https://github.com/oxwall/cloudflare.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/cocreation" do
  repository 'https://github.com/routetopa/spod-plugin-cocreation.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/contactus" do
  repository 'https://github.com/oxwall/contactus.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/contact_importer" do
  repository 'https://github.com/oxwall/contactimporter.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/event" do
  repository 'https://github.com/oxwall/event.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/fbconnect" do
  repository 'https://github.com/oxwall/fbconnect.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/forum" do
  repository 'https://github.com/oxwall/forum.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/friends" do
  repository 'https://github.com/oxwall/friends.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/groups" do
  repository 'https://github.com/oxwall/groups.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/mailbox" do
  repository 'https://github.com/oxwall/mailbox.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/newsfeed" do
  repository 'https://github.com/oxwall/newsfeed.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/notification_system" do
  repository 'https://github.com/routetopa/spod-plugin-notification-system.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/notifications" do
  repository 'https://github.com/oxwall/notifications.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/ode" do
  repository 'https://github.com/routetopa/spod-plugin-ode.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/openwall" do
  repository 'https://github.com/routetopa/spod-plugin-openwall.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/photo" do
  repository 'https://github.com/oxwall/photo.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/privacy" do
  repository 'https://github.com/oxwall/privacy.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/slideshow" do
  repository 'https://github.com/oxwall/slideshow.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/social_sharing" do
  repository 'https://github.com/oxwall/socialsharing.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/spodagora" do
  repository 'https://github.com/routetopa/spod-plugin-new-agora.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/spodapi" do
  repository 'https://github.com/routetopa/spod-plugin-api.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/spoddiscussion" do
  repository 'https://github.com/routetopa/spod-plugin-discussion.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/spodoauth2connect" do
  repository 'https://github.com/routetopa/spod-plugin-oauth2'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/spodpr" do
  repository 'https://github.com/routetopa/spod-plugin-myspace.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/spodprivacy" do
  repository 'https://github.com/routetopa/spod-plugin-privacy.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/spodshowcase" do
  repository 'https://github.com/routetopa/spod-plugin-showcase.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/tchat" do
  repository 'https://github.com/routetopa/spod-plugin-tchat.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/video" do
  repository 'https://github.com/oxwall/video.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/virtual_gifts" do
  repository 'https://github.com/oxwall/virtualgifts.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

git "#{node['spod']['root']}/ow_plugins/widgets" do
  repository 'https://github.com/routetopa/spod-plugin-widgets.git'
  action :checkout
  user node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

# Configure spod_notification_service
# ------------------------------------------------------------------------------

#include_recipe "nodejs"
#include_recipe "nodejs::npm"

package 'npm'
package 'nodejs'

link '/usr/bin/node' do
  to '/usr/bin/nodejs'
end

directory '/var/log/spod-notification-service' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template "/etc/init/spod-notification-service.conf" do
  source 'spod/spod-notification-service.conf.erb'
  owner node['sys']['httpd']['user']
  group node['sys']['httpd']['group']
end

bash 'spod-notification-service-sudoer' do
  code "print '4\nY\n' | sh install_spod_notification_service.sh"
  cwd "#{node['spod']['root']}/ow_plugins/notification_system/static/scripts"
  user 'root'
  group 'root'
end

service 'spod-notification-service' do
  action :start
end

# Configure etherpad
# ------------------------------------------------------------------------------

user 'etherpad' do
  home '/home/etherpad'
  shell '/bin/bash'
end

directory '/home/etherpad' do
  owner 'etherpad'
  group 'etherpad'
  action :create
end

git "/home/etherpad/etherpad-lite" do
  repository 'https://github.com/ether/etherpad-lite.git'
  action :checkout
  user 'etherpad'
  group 'etherpad'
end

mysql_database 'etherpadLite' do
  connection mysql_connection
  action :create
end

mysql_database_user 'etherpad' do
  database_name 'etherpadLite'
  username 'etherpad'
  password 'etherpad'
  connection mysql_connection
  action [:create, :grant]
end

file '/home/etherpad/etherpad-lite/settings.json' do
  content lazy { IO.read("#{node['spod']['root']}/ow_plugins/cocreation/static/scripts/etherpad/settings.json") }
  mode '0777'
  owner 'etherpad'
  group 'etherpad'
end

file '/home/etherpad/etherpad-lite/APIKEY.txt' do
  content lazy { IO.read("#{node['spod']['root']}/ow_plugins/cocreation/static/scripts/etherpad/APIKEY.txt") }
  mode '0755'
  owner 'etherpad'
  group 'etherpad'
end

file '/home/etherpad/etherpad-lite/src/static/css/pad.css' do
  content lazy { IO.read("#{node['spod']['root']}/ow_plugins/cocreation/static/scripts/etherpad/pad.css") }
  mode '0755'
  owner 'etherpad'
  group 'etherpad'
end

file '/home/etherpad/etherpad-lite/src/static/css/timeslider.css' do
  content lazy { IO.read("#{node['spod']['root']}/ow_plugins/cocreation/static/scripts/etherpad/timeslider.css") }
  mode '0755'
  owner 'etherpad'
  group 'etherpad'
end

file '/home/etherpad/etherpad-lite/bin/run.sh' do
  content lazy { IO.read("#{node['spod']['root']}/ow_plugins/cocreation/static/scripts/etherpad/APIKEY.txt") }
  mode '0755'
  owner 'etherpad'
  group 'etherpad'
end

bash 'spod-etherpad-deps' do
  code "sh bin/installDeps.sh"
  cwd '/home/etherpad/etherpad-lite/'
  user 'root'
  group 'root'
end

mysql_database 'etherpadLite' do
  connection mysql_connection
  sql        "ALTER DATABASE etherpadLite CHARACTER SET utf8 COLLATE utf8_bin"
  action     :query
end

directory '/var/log/etherpad-lite' do
  owner 'etherpad'
  group 'etherpad'
  mode '0755'
  action :create
end

template "/etc/init/etherpad-lite.conf" do
  source 'spod/etherpad-lite.conf.erb'
  owner 'root'
  group 'root'
  #owner node['sys']['httpd']['user']
  #group node['sys']['httpd']['group']
end

bash 'spod-etherpad-service-sudoer' do
  code "print '11\nY\n' | sh install_etherpad.sh"
  cwd "#{node['spod']['root']}/ow_plugins/cocreation/static/scripts/etherpad"
  user 'root'
  group 'root'
end

service 'etherpad-lite' do
  action :start
end

package 'abiword'

bash 'spod-etherpad-plugins' do
  code 'npm install ep_page_view ep_comments_page ep_document_import_hook ep_font_family ep_font_size ep_mammoth_custom'
  cwd '/home/etherpad/etherpad-lite'
  user 'root'
  group 'root'
end

service 'etherpad-lite' do
  action :restart
end

# Configure ethersheet
# ------------------------------------------------------------------------------

#curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
#sudo apt-get install -y nodejs

#createUser
#cloneRepository
#createDatabase
#copySettings
#installService
#settingSudoUser
#startService