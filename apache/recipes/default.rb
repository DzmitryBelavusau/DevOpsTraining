#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

user 'apache' do
    manage_home true
    comment 'Apache User'
    group 'root'
    home '/home/apache'
    shell '/bin/bash'
    password 'apache'
    action :create
end

package "apache2" do
    case node[:platform]
    when "centos","redhat","fedora","suse"
      package_name "httpd"
    when "debian","ubuntu"
      package_name "apache2"
    when "arch"
      package_name "apache"
    end
    action :install
end

cookbook_file '/etc/httpd/modules/mod_jk.so' do
    source 'mod_jk-so'
    owner 'apache'
    mode '0755'
    action :create
end

template '/etc/httpd/conf/workers.properties' do
    source 'workers.properties.erb'
end

template '/etc/httpd/conf.d/loadbalancer.conf' do
    source 'loadbalancer.conf.erb'
end

execute 'start apache from user' do
#    user 'apache'      //https starts under 'apache' user writen in httpd.conf
    command 'systemctl start httpd'
end