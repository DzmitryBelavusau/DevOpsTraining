# # encoding: utf-8

# Inspec test for recipe apache::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe user('apache') do
  it { should exist }
  its('group') { should eq 'root' }
end

describe file('/etc/httpd/modules/mod_jk.so') do
  it { should exist }
end

describe file('/etc/httpd/conf/workers.properties') do
  it { should exist }
  its('content') { should match ( /worker.list=lb/ ) }
end

describe file('/etc/httpd/conf.d/loadbalancer.conf') do
  it { should exist }
  its('content') { should match ( /mod_jk.so/ ) }
end

describe apache do
  its ('user') { should cmp 'apache' }
end