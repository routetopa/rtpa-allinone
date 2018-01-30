# rtpa-allinone

This Chef Cookbook allows you to configure the ROUTE-TO-PA stack. 
It can be used to build an All-in-one machine that runs all the 
software composing the ROUTE-TO-PA platform.

Tested with Ubuntu 14.04

## Before running the Cookbook

The only mandatory configuration that you need to alter is the `node['url']` parameter. 
You **must** set it to the public address of the node, otherwise the Wordpress installation
won't complete.

## Installing in local (without Chef Serve)

If you want to install the All-in-one but you don't have a Chef infrastructure ready, you
may use Chef's local mode.

You can follow these instruction:

```
# Install Ruby 2.3 repository for Ubuntu 14.04
sudo apt-add-repository ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install ruby2.3 ruby2.3-dev

# Install Chef
curl -L https://omnitruck.chef.io/install.sh | sudo bash
sudo gem install berkshelf

# Prepare the cookbook
mkdir ~/cookbooks
cd ~/cookbooks
git clone https://github.com/routetopa/rtpa-allinone.git

# Download cookbook dependencies
berks vendor -b ~/cookbooks/rtpa-allinone/Berksfile
mv berks-cookbooks/* ~/cookbooks/

# Configure the local machine
cp -R ~/cookbooks/rtpa-allinone/test/fixtures/default/databags ~/
# Edit file ~/cookbooks/rtpa-allinone/attributes/default.rb
# and change attribute `default['url']`.

# Install
sudo chef-client -z -o rtpa-allinone
```