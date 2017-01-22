# Class: report_hipchat::params
#
# Parameterize for Puppet platform.
#
class report_hipchat::params {

  $api_version     = 'v1'
  $config_file     = '/etc/puppetlabs/puppet/hipchat.yaml'
  $dashboard       = undef
  $group           = 'puppet'
  $install_hc_gem  = true
  $owner           = 'puppet'
  $package_name    = 'hipchat'
  $provider        = 'puppetserver_gem'
  $proxy           = undef
  $puppetboard     = undef
}
