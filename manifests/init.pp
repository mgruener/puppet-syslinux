class syslinux (
  $image_root = '/var/lib/syslinux/images',
  $images = undef,
  $hiera_merge = false,
) {

  case type($hiera_merge) {
    'string': {
      validate_re($hiera_merge, '^(true|false)$', "${myclass}::hiera_merge may be either 'true' or 'false' and is set to <${hiera_merge}>.")
      $hiera_merge_real = str2bool($hiera_merge)
    }
    'boolean': {
      $hiera_merge_real = $hiera_merge
    }
    default: {
      fail("${myclass}::hiera_merge type must be true or false.")
    }
  }

  exec { "mkdir -p ${image_root}":
    path    => [ '/bin','/usr/bin'],
    creates => $image_root
  }

  file { $image_root:
    ensure  => directory,
    require => Exec["mkdir -p ${image_root}"],
  }

  package { 'syslinux':
    ensure => present,
  }

  if $images != undef {
    if !is_hash($images) {
        fail("${myclass}::images must be a hash.")
    }

    if $hiera_merge_real == true {
      $images_real = hiera_hash("${myclass}::images")
    } else {
      $images_real = $images
    }

    create_resources('${myclass}::images',$images_real)
  }
}
