#
# Cookbook:: jenkins-docker
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

package 'docker'

user 'jenkins' do
    manage_home true
    comment 'Jenkins User'
    home '/home/jenkins'
    shell '/bin/bash'
    password 'jenkins'
    action :create
end

directory '/etc/jenkins_home' do
    owner 'vagrant'
    group 'vagrant'
    mode '0755'
    action :create
end

directory '/backup/jenkins' do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
end

docker_service 'default' do
    #group 'dockerroot'
    action [:create, :start]
end

docker_image 'jenkins' do
    repo 'jenkins/jenkins'
    tag 'lts-alpine'
    action :pull
end

docker_container 'jenkins' do
    repo 'jenkins/jenkins'
    tag 'lts-alpine'
    port ['8000:8080', '50000:50000']
    volumes [ '/etc/jenkins_home/:/var/jenkins_home/' ]
    user 'jenkins'
end

cron 'jenkins_backup' do
    hour '1'
    minute '0'
    user 'root'
    command 'tar -cvzf /backup/jenkins/files.tar.gz /etc/jenkins_home'
    action :create
end
