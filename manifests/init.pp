# Class: report_hipchat
#
# Send Puppet report information to HipChat

class report_hipchat (
  $api_key,
  $room,
  $server         = 'https://api.hipchat.com',
  $notify_color   = 'red',
  $notify_room    = false,
  $statuses       = [ 'failed' ],
  $config_file    = "${::report_hipchat::params::puppetconf_path}/hipchat.yaml",
  $package_name   = $::report_hipchat::params::package_name,
  $install_hc_gem = $::report_hipchat::params::install_hc_gem,
  $provider       = $::report_hipchat::params::provider,
  $owner          = $::report_hipchat::params::owner,
  $group          = $::report_hipchat::params::group,
  $puppetboard    = $::report_hipchat::params::puppetboard,
  $dashboard      = $::report_hipchat::params::dashboard,
  $api_version    = $::report_hipchat::params::api_version,
  $proxy          = $::report_hipchat::params::proxy,
) inherits report_hipchat::params {
  if versioncmp($::puppetversion, '4.0.0') < 0 {
    notify{'Puppet 3.x support is depricated, upgrade to puppet 4': }
  }

  file { $config_file:
    ensure  => file,
    owner   => $owner,
    group   => $group,
    mode    => '0440',
    content => template('report_hipchat/hipchat.yaml.erb'),
  }

  if $install_hc_gem {
    package { $package_name:
      ensure   => installed,
      provider => $provider,
    }
  }
}
