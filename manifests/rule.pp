# simple rules
define policy::rule (
  $component,
  $ensure = present,
  $value  = '',
  $type   = 'json',
  $file   = undef,
) {

  if ! $component {
    fail('component must be one of the OpenStack services')
  }

  if $type == 'json' {
    $extension = 'json'
    $lens      = 'Json.lns'
  } elsif $type == 'yaml' {
    $extension = 'yaml'
    $lens      = 'Yaml.lns'
  } else {
    fail("extension ${type} is unknown")
  }

  if $file {
    $savefile = $file
  } else {
    $savefile = "/etc/${component}/policy.${extension}"
  }

  case $ensure {
    default: {
      $changes = [
        "set dict/entry[last()+1] \"${title}\"",
        "set dict/entry[last()]/string \"${value}\""
      ]
    }
    absent:  { $changes = "rm dict/entry[.= \"${title}\"]" }
  }

  augeas {
    "${component}-${title}-policy":
      lens    => $lens,
      incl    => $savefile,
      context => "/files${savefile}",
      changes => $changes,
  }

  Augeas["${component}-${title}-policy"] ~>
  Service<| tag == $component |>

}
