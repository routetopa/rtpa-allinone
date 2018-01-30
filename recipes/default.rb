#
# Cookbook:: rtpa-allinone
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# Ensure the apt cache is up to date
# ------------------------------------------------------------------------------
apt_update 'daily' do
  frequency 86_400
  action :periodic
end

# git will be requires in different places of the cookbook
# ------------------------------------------------------------------------------
package 'git-core'

include_recipe 'rtpa-allinone::httpd'
include_recipe 'rtpa-allinone::mysql'
include_recipe 'rtpa-allinone::ckan'
include_recipe 'rtpa-allinone::spod'
include_recipe 'rtpa-allinone::wordpress'
include_recipe 'rtpa-allinone::oauth2'

