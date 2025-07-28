{
  "variables": { },
  "builders": [
    {
      "type": "docker",
      "image": "tipibuild/tipi-almalinux-95:{{cmake_re_source_hash}}",
      "commit": true
    }
  ]
}