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