# frozen_string_literal: true

control 'nsd.config.file' do
  title 'Verify the configuration file'

  describe file('/etc/nsd/nsd.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') do
      should include(
        'Your changes will be overwritten.'
      )
    end
    its('content') { should include '"added_in_pillar": "pillar_value"' }
    its('content') { should include '"added_in_defaults": "defaults_value"' }
    its('content') { should include '"added_in_lookup": "lookup_value"' }
    its('content') { should include '"config": "/etc/nsd/nsd.conf"' }
    its('content') { should include '"lookup": {"added_in_lookup": "lookup_value",' }
    its('content') { should include '"pkg": {"name": "' }
    its('content') { should include '"service": {"name": "' }
    its('content') do
      # rubocop:disable Lint/RedundantCopDisableDirective
      # rubocop:disable Layout/LineLength
      should include(
        '"tofs": {"files_switch": ["any/path/can/be/used/here", "id", '\
        '"roles", "osfinger", "os", "os_family"], "source_files": '\
        '{"nsd-config-file-file-managed": ["nsd.conf.jinja"]}'
      )
      # rubocop:enable Layout/LineLength
      # rubocop:enable Lint/RedundantCopDisableDirective
    end
    its('content') { should include '"arch": "amd64"' }
    its('content') { should include '"winner": "pillar"' }
    its('content') { should include 'winner of the merge: pillar' }
  end

  describe file('/etc/nsd/nsd.conf.d') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end
