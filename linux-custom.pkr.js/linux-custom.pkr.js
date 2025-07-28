{
  "variables": { },
  "builders": [
    {
      "type": "docker",
      "image": "linux-custom:{{cmake_re_source_hash}}",
      "commit": true
    }
  ]

}