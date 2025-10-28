{
  "variables": { },
  "builders": [
    {
      "type": "docker",
      "image": "linux-custom-amazonlinux-2023:{{cmake_re_source_hash}}",
      "commit": true
    }
  ]
}