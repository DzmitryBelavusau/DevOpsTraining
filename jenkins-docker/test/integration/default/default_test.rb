# # encoding: utf-8

# Inspec test for recipe jenkins-docker::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe user('jenkins') do
  it { should exist }
  its('group') { should eq 'jenkins' }
end

describe directory('/etc/jenkins_home') do
  it { should exist }
end

describe directory('/backup/jenkins') do
  it { should exist }
end

describe service('docker') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe docker_image('jenkins/jenkins:lts-alpine') do
  it { should exist }
  its('image') { should eq 'jenkins/jenkins:lts-alpine' }
  its('repo') { should eq 'jenkins/jenkins' }
  its('tag') { should eq 'lts-alpine' }
end

describe docker_container('jenkins') do
  it { should exist }
  it { should be_running }
  its('ports') { should match /8000/ }
  its('ports') { should match /50000/ }
end