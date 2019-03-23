#
# Cookbook:: jenkins-slave
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

user 'jenkins' do
    manage_home true
    comment 'Jenkins User'
    home '/home/jenkins'
    shell '/bin/bash'
    password 'jenkins'
    action :create
end

include_recipe 'java'

cookbook_file '/home/jenkins/agent.jar' do
    source 'agent-jar'
    owner 'jenkins'
    mode '0777'
    action :create
end

execute 'install slave' do
    command 'nohup java -jar /home/jenkins/agent.jar -jnlpUrl http://10.70.5.202:8080/computer/jenkins-slave/slave-agent.jnlp -secret e81fc6b7f880d008eb7160a18fecd0759d721d72ffc8f239098e9c23830e2b94 -workDir "/home/jenkins" &'
    not_if 'pgrep java'
end
