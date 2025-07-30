{
  "variables": { },
  "builders": [
    {
      "type": "docker",
      "image": "tipibuild/tipi-ubuntu-wine-msvc:{{cmake_re_source_hash}}",
      "commit": true
    }
  ]
}