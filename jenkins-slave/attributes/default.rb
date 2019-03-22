# This is a Chef attributes file. It can be used to specify default and override
# attributes to be applied to nodes that run this cookbook.

default['java']['jdk_version'] = '8'
default['java']['install_flavor'] = 'oracle'
default['java']['set_etc_environment'] = true
default['java']['oracle']['accept_oracle_download_terms'] = true

normal_unless['jenkins']['username'] = 'admin'
normal_unless['jenkins']['password'] = 'admin'
override['jenkins']['slave_name'] = 'test slave'
override['jenkins']['slave_desc'] = 'test slave'
override['jenkins']['remote_fs'] = '/home/jenkins'
override['jenkins']['user'] = 'jenkins'
override['jenkins']['master']['host'] = '10.70.5.202'
override['jenkins']['master']['port'] = 8080