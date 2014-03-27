# source: https://github.com/xaque208/puppet-pxe/blob/master/manifests/images/resources.pp

define syslinux::images($arch,$ver,$os,$baseurl) {

  $image_root = $::syslinux::image_root

  if $baseurl == '' { err('$baseurl is empty and it need not be') }

  ensure_resource('file',"${image_root}/${os}", { ensure => directory })
  ensure_resource('file',"${image_root}/${os}/${ver}", { ensure => directory })
  ensure_resource('file',"${image_root}/${os}/${ver}/${arch}", { ensure => directory })

  exec {
    "wget ${os} pxe linux ${arch} ${ver}":
      path    => "/usr/bin",
      cwd     => "${image_root}/${os}/${ver}/${arch}",
      creates => "${image_root}/${os}/${ver}/${arch}/vmlinuz",
      command => "wget ${baseurl}/vmlinuz";
    "wget ${os} pxe initrd.img ${arch} ${ver}":
      path    => "/usr/bin",
      cwd     => "${image_root}/${os}/${ver}/${arch}",
      creates => "${image_root}/${os}/${ver}/${arch}/initrd.img",
      command => "wget ${baseurl}/initrd.img";
  }

}
