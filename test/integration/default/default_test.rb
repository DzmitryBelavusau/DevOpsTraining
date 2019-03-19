# # encoding: utf-8

# Inspec test for recipe task9::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe service('docker') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe bash('docker info') do
  its('stdout') { should match /10.70.5.202/ }
end
