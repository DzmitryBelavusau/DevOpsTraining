resource_name :bluegreen

property :portname, String, default: '0'

action :start do
    case new_resource.portname
    when '38081'
        docker_container 'blue' do
            repo '10.70.5.202:5000/task7'
            tag node['image']['version']
            port '38080:8080'
            action :run
        end
  
        ruby_block "check blue container" do
            block do
                require 'chef/mixin/shell_out'
                Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
                sleep(20)
                command = 'curl http://localhost:38080/task7b/'
                command_out = shell_out(command)
                puts command_out.stdout
                puts node['image']['version']
                raise "blue container do not start/not contains new version" if !command_out.stdout.include? node['image']['version']
            end
        end

        docker_container 'green' do
            action :delete
        end
    when '38080'
        docker_container 'green' do
            repo '10.70.5.202:5000/task7'
            tag node['image']['version']
            port '38081:8080'
            action :run
        end
  
        ruby_block "check green container" do
            block do
                require 'chef/mixin/shell_out'
                Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
                sleep(20)
                command_green = 'curl http://localhost:38081/task7b/'
                command_out_green = shell_out(command_green)
                puts command_out_green.stdout
                puts node['image']['version']
                raise "green container do not start/not contains new version" if !command_out_green.stdout.include? node['image']['version']
            end
        end

        docker_container 'blue' do
            action :delete
        end
    else
        docker_container 'blue' do
            repo '10.70.5.202:5000/task7'
            tag node['image']['version']
            port '38080:8080'
            action :run
        end
    end
end