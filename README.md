# Puppet Hipchat

[![Puppet Forge](http://img.shields.io/puppetforge/v/puppet/report_hipchat.svg)](https://forge.puppetlabs.com/puppet/report_hipchat)
[![Puppet Forge downloads](https://img.shields.io/puppetforge/dt/puppet/report_hipchat.svg)](https://forge.puppetlabs.com/puppet/report_hipchat)
[![Puppet Forge score](https://img.shields.io/puppetforge/f/puppet/report_hipchat.svg)](https://forge.puppetlabs.com/puppet/report_hipchat)
[![Build Status](https://travis-ci.org/voxpupuli/puppet-report_hipchat.svg?branch=master)](https://travis-ci.org/voxpupuli/puppet-report_hipchat)


## Description

A Puppet report handler for sending notifications of Puppet runs to [HipChat](http://www.hipchat.com).

## TravisCI status

[![Build Status](https://travis-ci.org/voxpupuli/puppet-report_hipchat.svg?branch=master)](https://travis-ci.org/voxpupuli/puppet-report_hipchat)

## Requirements

* `hipchat >= 0.12.0`
* `puppet`

#### Obtaining Hipchat Auth Token
For the room in which you want to receive puppet notifications, add a new BYO Integration. This will return an example url: `https://example.hipchat.com/v2/room/123456789/notification?auth_token=WzP0dc4oEESuSmF2WJT23GtL5mili9uXof73M48S`
        `https://example.hipchat.com` is the server (you can use on premise hipchat servers as well)
        `v2` is the api version
        `123456789` is the room
        `WzP0dc4oEESuSmF2WJT23GtL5mili9uXof73M48S` is the api_key

## Usage / Installation

```puppet
class { 'report_hipchat':
  server         => 'https://example.hipchat.com',
  api_version    => 'v2',
  api_key        => 'WzP0dc4oEESuSmF2WJT23GtL5mili9uXof73M48S',
  room           => '123456789',
  install_hc_gem => true,
}
```

With puppetboard link: 

```puppet
class { 'report_hipchat':
  server         => 'https://example.hipchat.com',
  api_version    => 'v2',
  api_key        => 'WzP0dc4oEESuSmF2WJT23GtL5mili9uXof73M48S',
  room           => '123456789',
  install_hc_gem => true,
  puppetboard    => 'https://puppetboard.test.local',
}
```

With dashboard link:

```puppet
class { 'report_hipchat':
  server         => 'https://example.hipchat.com',
  api_version    => 'v2',
  api_key        => 'WzP0dc4oEESuSmF2WJT23GtL5mili9uXof73M48S',
  room           => '123456789',
  install_hc_gem => true,
  dashboard      => 'https://dashboard.test.local',
}
```

### Proxy

```puppet
class { 'report_hipchat':
  server         => 'https://example.hipchat.com',
  api_version    => 'v2',
  api_key        => 'WzP0dc4oEESuSmF2WJT23GtL5mili9uXof73M48S',
  room           => '123456789',
  install_hc_gem => true,
  proxy          => 'http://proxy.test.local:8080',
}
```

### Configure the report in puppet.conf
```puppet
# on puppet master
ini_setting {'pluginsync-master':
  ensure  => present,
  path    => '/etc/puppetlabs/puppet/puppet.conf',
  section => 'master',
  setting => 'pluginsync',
  value   => 'true', 
  notify  => Service['puppetserver'],
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

# on puppetmaster and agents
ini_setting {'pluginsync-agent':
  ensure  => present,
  path    => '/etc/puppetlabs/puppet/puppet.conf',
  section => 'agent',
  setting => 'pluginsync',
  value   => 'true',
  notify  => Service['puppetserver'],
} 
```

Result:
```ini
[master]
report = true
reports = hipchat
pluginsync = true
[agent]
report = true
```

Params
-----
```list
api_key:        Hipchat API key String[required]
api_version:    Hipchat API version: String[default: 'v1']
room:           Hipchat Room String[required]
notify_room:    Notify room: Boolean[default: false]
notify_color:   Notification Color: String[default: 'red'] options['red', 'green', 'purple', 'random']
statuses:       Array of statuses to notify: Array[Defailt ['failed'] ], options['failed', 'all']
server:         Hipchat Sever String[default: 'https://api.hipchat.com']
config_file:    Hipchat config file: String[default: "{confdir}/hipchat.yaml"]
owner:          hipchat.conf owner: String[default: Varies based on puppet version]
group:          hipchat.conf group: String[default: Varies based on puppet version]

package_name:   Hipchat gem: String[default: 'hipchat']
install_hc_gem: Install Hipchat Gem: Boolean[default: Varies based on puppet version]
provider:       Package Provider to use: String[default: puppetserver_gem]

puppetboard:    URL to puppetboard: String[optional]
dashboard:      URL to dashboard: String[optional]
proxy:          proxy url and port to reach hipchat: String[optional] Format: 'http://username:password@proxy_host:proxy_port'
```

#### NOTE FOR PUPPETBOARD 1.1.2+ USERS: 
if you are using environments other than `production`
you will need to either configure puppetboard default environment to * or set `hipchat_server`
to append /%2A, ex: `:hipchat_server: http://hipchat.test.local/%2A` otherwise you will receive
a not found error for any nodes in environments other than `production`.

#### Disabling notifcations temporarily
* To temporarily disable HipChat notifications add a file named
  `hipchat_disabled` in the same path as `hipchat.yaml`. Removing it
  will re-enable notifications.

    $ touch /etc/puppetlabs/puppet/hipchat_disabled

Team
----

Maintainer: [James Powis](https://github.com/james-powis)

Original author: James Turnbull <james@lovedthanlost.net>

License
-------

    Author:: James Turnbull (<james@lovedthanlost.net>)
    Copyright:: Copyright (c) 2011 James Turnbull
    License:: Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
