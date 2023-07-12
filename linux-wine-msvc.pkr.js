{
  "variables": { },
  "builders": [
    {
      "type": "docker",
      "image": "tipibuild/tipi-ubuntu-wine-msvc:{{tipi_cli_version}}",
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
  ,"_tipi_version":"{{tipi_version_hash}}"

}