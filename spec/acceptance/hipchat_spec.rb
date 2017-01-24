require 'spec_helper_acceptance'

describe 'puppet-hipchat' do
  context 'configure and send hipchat notification' do
    context 'works with no errors' do
      # Because of puppetserver_gem not always resolving due to puppetserver
      # install cleanup, we will install the prerequisites first
      it 'preconfigure puppetserver' do
        version = ENV['PUPPETSERVER_VERSION'] || 'present'
        pp = <<-EOS
        class { 'puppetserver::repository': } ->
        class { 'puppetserver':
          version => #{version},
          config  => {
            'java_args'     => {
              'xms'         => '256m',
              'xmx'         => '256m',
              'maxpermsize' => '512m',
            },
          },
        }
        host { 'puppet':
          ip => '127.0.0.1',
        }
        EOS
        apply_manifest(pp, catch_failures: true)
      end

      it 'installs puppet report' do
        pp = <<-EOS
        service { 'puppetserver':
          ensure => running
        }
        ini_setting {'report':
          ensure  => present,
          path    => '/etc/puppetlabs/puppet/puppet.conf',
          section => 'master',
          setting => 'report',
          value   => 'true',
          notify  => Service['puppetserver'],
        }
        ini_setting {'reports':
          ensure  => present,
          path    => '/etc/puppetlabs/puppet/puppet.conf',
          section => 'master',
          setting => 'reports',
          value   => 'hipchat',
          notify  => Service['puppetserver'],
        }
        class {'::report_hipchat':
          api_key        => 'mykey',
          room           => 'myroom',
          statuses       => ['all', 'testing'],
          install_hc_gem => true,
          provider       => 'puppetserver_gem',
          proxy          => 'http://myproxy.com:80',
          notify         => Service['puppetserver'],
        }
        EOS

        apply_manifest(pp, catch_failures: true)
        expect(apply_manifest(pp, catch_failures: true).exit_code).to be_zero
      end

      # run the agent, this will cause the reporting handler generate a tmp file
      # to show it executed properly
      it 'an agent run is successful' do
        expect(run_agent_on(hosts[0]).exit_code).to be_zero
      end

      it 'installs the hipchat gem' do
	show_result = shell('puppetserver gem list | grep hipchat')
	expect(show_result.stdout).to match /hipchat/
      end
    end


    describe file('/tmp/hipchat-notified.txt') do
      it { is_expected.to be_file }
    end
  end
end
