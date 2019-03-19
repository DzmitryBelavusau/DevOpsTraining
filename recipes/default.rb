#
# Cookbook:: task9
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

package 'docker'

docker_service 'default' do
    group 'dockerroot'
    insecure_registry node['docker']['registry']
    action [:create, :start]
end
