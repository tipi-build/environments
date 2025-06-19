{
  "variables": { },
  "builders": [
    {
      "type": "docker",
      "image": "tipibuild/linux-custom-almalinux-95:{{cmake_re_source_hash}}",
      "commit": true
    }
  ],
  "post-processors": [
    { 
      "type": "docker-tag",
      "repository": "linux",
      "tag": "latest"
    }
  ]
}