# = Class: sensu::client::service
#
# Manages the Sensu client service
#
# == Parameters
#
# [*hasrestart*]
#   Bolean. Value of hasrestart attribute for this service.
#   Default: true
#
class sensu::client::service (
  $hasrestart = true,
) {

  validate_bool($hasrestart)

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $::sensu::manage_services {

    case $::sensu::client {
      true: {
        $ensure = 'running'
        $enable = true
      }
      default: {
        $ensure = 'stopped'
        $enable = false
      }
    }

    if $::osfamily == 'windows' {

      file { 'C:/opt/sensu/bin/sensu-client.xml':
        ensure  => file,
        content => template("${module_name}/sensu-client.erb"),
      }

      exec { 'install-sensu-client':
        provider => 'powershell',
        command  => "New-Service -Name sensu-client -BinaryPathName c:\\opt\\sensu\\bin\\sensu-client.exe -DisplayName 'Sensu Client' -StartupType Automatic",
        unless   => 'if (Get-Service sensu-client -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }',
        before   => Service['sensu-client'],
        require  => File['C:/opt/sensu/bin/sensu-client.xml'],
      }
    }

    if $::osfamily == 'FreeBSD' {
      $provider = 'bsd'
    } else {
      $provider = undef
    }

    service { 'sensu-client':
      ensure     => $ensure,
      enable     => $enable,
      hasrestart => $hasrestart,
      provider   => $provider,
      subscribe  => [
        Class['sensu::package'],
        Class['sensu::client::config'],
        Class['sensu::rabbitmq::config'],
      ],
    }
  }
}
