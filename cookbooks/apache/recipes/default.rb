#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'httpd' do
  action :install
end

ruby_block 'randomly_choose_language' do
  block do
    node.run_state['scripting_language'] = if Random.rand > 0.5
                                             'php'
                                           else
                                             'perl'
                                           end
    puts "scripting language :: #{node.run_state['scripting_language']}"
  end
end

package 'scripting_language' do
  package_name lazy { node.run_state['scripting_language'] }
  action :install
end

# Disable the default virtual host
apache_vhost 'welcome' do
  action :remove
  notifies :restart, 'service[httpd]'
end

# Iterate over the apache sites
node['apache']['sites'].each do |site_name, site_data|
  # Enable an Apache Virtualhost
  apache_vhost site_name do
    site_port site_data['port']
    action :create
    notifies :restart, 'service[httpd]'
  end
end

service 'httpd' do
  action [ :enable, :start ]
end
