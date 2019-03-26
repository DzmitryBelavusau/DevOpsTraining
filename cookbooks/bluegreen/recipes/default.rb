#
# Cookbook:: bluegreen
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'chef/mixin/shell_out'

docker_image '10.70.5.202:5000/task7' do
    tag node['image']['version']
    action :pull
end

ruby_block "get port blue" do
    block do
        node.run_state['serviceport'] = '0'
        Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)      
        command = 'docker ps --format "{{.Ports}}"'
        command_out = shell_out(command)
        node.default['port'] = command_out.stdout
        if node['port'].include? '38080'
            node.run_state['serviceport'] = '38080'
        end
        if node['port'].include? '38081'
            node.run_state['serviceport'] = '38081'
        end
    end
end

bluegreen 'bluegreen' do
    portname lazy { node.run_state['serviceport'] }
    action :start
end
