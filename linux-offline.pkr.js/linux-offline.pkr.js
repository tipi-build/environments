{
  "variables": { },
  "builders": [
    {
      "type": "docker",
      "image": "linux-offline:{{cmake_re_source_hash}}",
      "commit": true
    }
  ]

}