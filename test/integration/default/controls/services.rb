# frozen_string_literal: true

# Prepare platform "finger"
platform_finger = system.platform[:finger].split('.').first.to_s

control 'nsd.service.running' do
  title 'The service should be installed, enabled and running'

  # Overide by `platform_finger`
  service_name =
    case platform_finger
    when 'centos-6', 'amazonlinux-1'
      'crond'
    else
      'nsd'
    end

  describe service(service_name) do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  describe command('nslookup -port=53530 ns1.example.test 127.0.0.1') do
    its('stdout') { should match '192.168.0.1' }
  end

  describe command('nslookup -port=53530 ns2.example.test 127.0.0.1') do
    its('stdout') { should match '192.168.0.2' }
  end

  describe command('nslookup -port=53530 example.test 127.0.0.1') do
    its('stdout') { should match '192.168.0.10' }
  end

  describe command('nslookup -port=53530 www.example.test 127.0.0.1') do
    its('stdout') { should match '192.168.0.10' }
  end

  describe command('nslookup -port=53530 mail.example.test 127.0.0.1') do
    its('stdout') { should match '192.168.0.11' }
  end

  describe command('nslookup -port=53530 192.168.0.1 127.0.0.1') do
    its('stdout') { should match 'ns1.example.test' }
  end

  describe command('nslookup -port=53530 192.168.0.2 127.0.0.1') do
    its('stdout') { should match 'ns2.example.test' }
  end

  describe command('nslookup -port=53530 192.168.0.10 127.0.0.1') do
    its('stdout') { should match 'example.test' }
  end

  describe command('nslookup -port=53530 192.168.0.11 127.0.0.1') do
    its('stdout') { should match 'mail.example.test' }
  end
end
