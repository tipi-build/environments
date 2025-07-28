{
  "variables": { },
  "builders": [
    {
      "type": "docker",
      "image": "linux-custom-almalinux-95:{{cmake_re_source_hash}}",
      "commit": true
    }
  ]
}