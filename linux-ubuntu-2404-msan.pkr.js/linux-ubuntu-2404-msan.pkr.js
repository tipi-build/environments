{
  "variables": { },
  "builders": [
    {
      "type": "docker",
      "image": "tipibuild/tipi-ubuntu-2404-msan:{{cmake_re_source_hash}}",
      "commit": true
    }
  ]
}