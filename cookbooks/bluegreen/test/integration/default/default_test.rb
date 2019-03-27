# # encoding: utf-8

# Inspec test for recipe bluegreen::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe service('docker') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe docker_image('10.70.5.202:5000/task7') do
  it { should exist }
  its('image') { should match /task7/ }
end

describe docker.containers do
  its('names') { should be_in ['blue', 'green'] }
end

describe port.where { port >= 38080 && port <= 38081 } do
  it { should be_listening }
end
