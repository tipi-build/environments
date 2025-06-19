{
  "variables": { },
  "builders": [
    {
      "type": "docker",
      "image": "tipibuild/tipi-ubuntu-wine-msvc:{{cmake_re_source_hash}}",
      "commit": true
    }
  ],
  "post-processors": [
    { 
      "type": "docker-tag",
      "repository": "linux-wine-msvc",
      "tag": "latest"
    }
  ]
}