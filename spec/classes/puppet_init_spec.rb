require 'spec_helper'

describe 'report_hipchat' do
  let(:facts) do
    {
      is_pe:          false,
      puppetversion: '3.0.0'
    }
  end

  context 'default' do
    let(:params) do
      {
        api_key: 'mykey',
        room:    'myroom',
        server:  'myserver'
      }
    end
    it { is_expected.to contain_class('report_hipchat') }
    it { is_expected.to contain_class('report_hipchat::params') }
    it { is_expected.to contain_notify('Puppet 3.x support is depricated, upgrade to puppet 4') }
    it { is_expected.to contain_package('hipchat').with(provider: 'gem') }
    it { is_expected.to contain_file('/etc/puppet/hipchat.yaml').with_content(%r{:hipchat_api: mykey}) }
    it { is_expected.to contain_file('/etc/puppet/hipchat.yaml').with_content(%r{:hipchat_room: myroom}) }
    it { is_expected.to contain_file('/etc/puppet/hipchat.yaml').with_content(%r{:hipchat_server: myserver}) }
    it { is_expected.to contain_file('/etc/puppet/hipchat.yaml').with_content(%r{:hipchat_api_version: v1\n}) }
    it { is_expected.to contain_file('/etc/puppet/hipchat.yaml').without_content(%r{:hipchat_proxy:}) }
    it { is_expected.to contain_file('/etc/puppet/hipchat.yaml').without_content(%r{:hipchat_puppetboard:}) }
    it { is_expected.to contain_file('/etc/puppet/hipchat.yaml').without_content(%r{:hipchat_dashboard:}) }
  end

  describe 'use api version 2' do
    let(:params) do
      {
        api_key:     'mykey',
        room:        'myroom',
        server:      'myserver',
        api_version: 'v2'
      }
    end
    it { is_expected.to contain_file('/etc/puppet/hipchat.yaml').with_content(%r{:hipchat_api_version: v2}) }
  end

  describe 'specify file location' do
    let(:params) do
      {
        api_key:     'mykey',
        room:        'myroom',
        config_file: '/tmp/foo'
      }
    end
    it { is_expected.to contain_file('/tmp/foo') }
  end

  describe 'no hipchat gem' do
    let(:params) do
      {
        api_key:       'mykey',
        room:          'myroom',
        install_hc_gem: false
      }
    end
    it { is_expected.not_to contain_package('hipchat') }
  end

  describe 'on pe' do
    let(:facts) do
      {
        is_pe: true
      }
    end
    let(:params) do
      {
        api_key: 'mykey',
        room:    'myroom'
      }
    end
    it { is_expected.to contain_package('hipchat').with_provider('pe_gem') }
    it { is_expected.to contain_file('/etc/puppetlabs/puppet/hipchat.yaml') }
  end

  describe 'on puppet 4' do
    let(:facts) do
      {
        is_pe:         false,
        puppetversion: '4.0.0'
      }
    end
    let(:params) do
      {
        api_key: 'mykey',
        room:    'myroom'
      }
    end
    it { is_expected.not_to contain_package('hipchat') }
    it { is_expected.to contain_file('/etc/puppetlabs/puppet/hipchat.yaml') }
  end

  describe 'with proxy' do
    let(:params) do
      {
        api_key: 'mykey',
        room:    'myroom',
        server:  'myserver',
        proxy:   'myproxy'
      }
    end
    it { is_expected.to contain_file('/etc/puppet/hipchat.yaml').with_content(%r{:hipchat_proxy: myproxy\n}) }
  end

  describe 'with puppetboard' do
    let(:params) do
      {
        api_key:     'mykey',
        room:        'myroom',
        server:      'myserver',
        puppetboard: 'mypuppetboard'
      }
    end
    it { is_expected.to contain_file('/etc/puppet/hipchat.yaml').with_content(%r{:hipchat_puppetboard: mypuppetboard\n}) }
  end

  describe 'with dashboard' do
    let(:params) do
      {
        api_key:   'mykey',
        room:      'myroom',
        server:    'myserver',
        dashboard: 'mydashboard'
      }
    end
    it { is_expected.to contain_file('/etc/puppet/hipchat.yaml').with_content(%r{:hipchat_dashboard: mydashboard\n}) }
  end
end
