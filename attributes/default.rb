#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# APPLICATION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Host settings
# ------------------------------------------------------------------------------
default['title'] = 'NEW INSTANCE'
default['url']   = 'http://127.0.0.1'

# Administrator user info
# ------------------------------------------------------------------------------
default['admin']['real_name'] = 'Platform Administrator'
default['admin']['username']  = 'administrator'
default['admin']['email']     = 'webmaster@routetopa.eu'



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# SYSTEM SERVICES
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Apache service
# ------------------------------------------------------------------------------
default['sys']['httpd']['user']  = 'www-data'
default['sys']['httpd']['group'] = 'www-data'
default['sys']['httpd']['root']  = '/var/www'

# MySQL Service
# ------------------------------------------------------------------------------
default['sys']['mysql']['port'] = '3306'

# PostgreSQL Service
# ------------------------------------------------------------------------------
default['sys']['pg']['port']           = '5432'
default['sys']['pg']['admin_username'] = 'postgres'
default['sys']['pg']['admin_password'] = 'loveopendata'

# Jetty Service
# ------------------------------------------------------------------------------
default['sys']['jetty']['port'] = '8983'



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# EXTERNAL SERVICES SERVICES
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# SMTP Endpoint
# ------------------------------------------------------------------------------
default['service']['mail']['host']         = 'smtp.elasticemail.com'
default['service']['mail']['port']         = '2525'
default['service']['mail']['user']         = 'isislab.unisa@gmail.com'
default['service']['mail']['encryption']   = 'null'
default['service']['mail']['from_address'] = node['admin']['email']
default['service']['mail']['from_name']    = node['title']

# DEEP Endpoints
# ------------------------------------------------------------------------------
default['service']['deep']['base']          = 'http://deep.routetopa.eu/deep_1_20'
default['service']['deep']['url']           = "#{node['service']['deep']['base']}/DEEP/"
default['service']['deep']['datalets']      = "#{node['service']['deep']['base']}/DEEP/datalets-list"
default['service']['deep']['client']        = "#{node['service']['deep']['base']}/DEEPCLIENT/js/deepClient.js"
default['service']['deep']['components']    = "#{node['service']['deep']['base']}/COMPONENTS/"
default['service']['deep']['webcomponents'] = "#{node['service']['deep']['base']}/COMPONENTS/bower_components/webcomponentsjs/webcomponents-lite.js"

# Ultraclarity
# ------------------------------------------------------------------------------
default['service']['ultraclarity']['url'] = ''

# Facebook
# ------------------------------------------------------------------------------
default['service']['facebook']['app_id'] = ''



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CKAN
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Virtual host configuration
# ------------------------------------------------------------------------------
default['ckan']['alias'] = 'data'
default['ckan']['port'] = '8080'

# Platform configuration
# ------------------------------------------------------------------------------
default['ckan']['site_id']  = 'default'
default['ckan']['site_url'] = node['url']

# Database configuration
# ------------------------------------------------------------------------------
default['ckan']['pg']['host'] = '127.0.0.1'
default['ckan']['pg']['port'] = node['sys']['pg']['port']
default['ckan']['pg']['user'] = 'ckan'
default['ckan']['pg']['name'] = 'ckan'

# Jetty configuration
# ------------------------------------------------------------------------------
default['ckan']['jetty']['host'] = '127.0.0.1'
default['ckan']['jetty']['port'] = node['sys']['jetty']['port']



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# SPOD
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Virtual host configuration
# ------------------------------------------------------------------------------
default['spod']['alias']             = 'spod'
default['spod']['port']              = '8088'
default['spod']['notification_port'] = '3000'
default['spod']['ethersheet_port']   = '8001'
default['spod']['etherpad_port']     = '9001'
default['spod']['root']              = "#{node['sys']['httpd']['root']}/#{node['spod']['alias']}"
default['spod']['url']               = "#{node['url']}/#{node['spod']['alias']}"

# Platform configuration
# ------------------------------------------------------------------------------
default['spod']['contact_us_email'] = node['admin']['email']
default['spod']['password_salt'] = ''
default['spod']['site_tagline'] = ''
default['spod']['site_description'] = ''


# Details for the Administrator user that will be created
# ------------------------------------------------------------------------------
default['spod']['admin']['username']  = node['admin']['username']
default['spod']['admin']['email']     = node['admin']['email']
default['spod']['admin']['real_name'] = node['admin']['real_name']

# Database and user that will be created
# ------------------------------------------------------------------------------
default['spod']['mysql']['host']   = '127.0.0.1'
default['spod']['mysql']['port']   = node['sys']['mysql']['port']
default['spod']['mysql']['user']   = 'spod'
default['spod']['mysql']['name']   = 'spod'
default['spod']['mysql']['prefix'] = 'ow_'

# Realtime services configuration
# ------------------------------------------------------------------------------
default['spod']['document']['port']    = 9001
default['spod']['spreadsheet']['port'] = 8001


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# WORDPRESS
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Virtual host configuration
# ------------------------------------------------------------------------------
default['wordpress']['alias'] = 'site'
default['wordpress']['port']  = '8888'
default['wordpress']['root']  = "#{node['sys']['httpd']['root']}/#{node['wordpress']['alias']}"
default['wordpress']['url']   = "#{node['url']}"

# Platform configuration
# ------------------------------------------------------------------------------
default['wordpress']['title'] = node['title']

# Details for the Administrator user that will be created
# ------------------------------------------------------------------------------
default['wordpress']['admin']['username']  = node['admin']['username']
default['wordpress']['admin']['email']     = node['admin']['email']
default['wordpress']['admin']['real_name'] = node['admin']['real_name']

# Database and user that will be created
# ------------------------------------------------------------------------------
default['wordpress']['mysql']['host'] = '127.0.0.1'
default['wordpress']['mysql']['port'] = node['sys']['mysql']['port']
default['wordpress']['mysql']['user'] = 'wordpress'
default['wordpress']['mysql']['name'] = 'wordpress'
default['wordpress']['mysql']['prefix'] = 'wp_'



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# OAUTH2
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Virtual host configuration
# ------------------------------------------------------------------------------
default['oauth2']['alias'] = 'oauth2'
default['oauth2']['port']  = '8089'
default['oauth2']['root'] = "#{node['sys']['httpd']['root']}/#{node['oauth2']['alias']}"
default['oauth2']['url'] = "#{node['url']}/#{node['oauth2']['alias']}"

# Platform configuration
# ------------------------------------------------------------------------------
default['oauth2']['title'] = node['title']

# Details for the Administrator user that will be created
# ------------------------------------------------------------------------------
default['oauth2']['admin']['username']  = node['admin']['username']
default['oauth2']['admin']['email']     = node['admin']['email']
default['oauth2']['admin']['real_name'] = node['admin']['real_name']

# Database and user that will be created
# ------------------------------------------------------------------------------
default['oauth2']['mysql']['host']   = '127.0.0.1'
default['oauth2']['mysql']['port']   = node['sys']['mysql']['port']
default['oauth2']['mysql']['user']   = 'oauth2'
default['oauth2']['mysql']['name']   = 'oauth2'
default['oauth2']['mysql']['prefix'] = ''



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TET
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

default['tet']['port'] = '8000'



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# COMPATIBILITY SETTINGS
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

default['postgresql']['pg_gem']['version'] = '0.21.0'