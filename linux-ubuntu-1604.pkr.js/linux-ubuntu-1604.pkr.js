{
  "variables": { },
  "builders": [
    {
      "type": "docker",
      "image": "tipibuild/tipi-ubuntu-1604:{{cmake_re_source_hash}}",
      "commit": true
    }
  ]
}