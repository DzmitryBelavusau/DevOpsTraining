# This is a Chef attributes file. It can be used to specify default and override
# attributes to be applied to nodes that run this cookbook.

default['java']['jdk_version'] = '8'
default['java']['install_flavor'] = 'oracle'
default['java']['set_etc_environment'] = true
default['java']['oracle']['accept_oracle_download_terms'] = true
