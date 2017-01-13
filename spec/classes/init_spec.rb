require 'spec_helper'

describe 'docker_auth' do
  on_supported_os.each do |os, facts|
    context "with defaults on #{os}" do
      let(:facts) do
        facts.merge({:puppetmaster => 'localhost.localdomain'})
      end
      let(:params) { { :package_ensure => 'installed' } }
      it { should compile.with_all_deps }
      it { should contain_class('docker_auth') }
      it { should contain_class('docker_auth::config') }
      it { should contain_class('docker_auth::install') }
      it { should contain_class('docker_auth::service') }
    end
  end
end
