# # encoding: utf-8

# Inspec test for recipe jenkins-slave::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe user('jenkins') do
  it { should exist }
end

describe file('/home/jenkins/agent.jar') do
  it { should exist }
end

describe bash('ps aux | grep java') do
  its('stdout') { should match /10.70.5.202/ }
end