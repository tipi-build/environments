{
  "variables": { },
  "builders": [
    {
      "type": "docker",
      "image": "tipibuild/tipi-ubuntu-1604:{{tipi_cli_version}}",
      "commit": true
    }
  ],
  "post-processors": [
    { 
      "type": "docker-tag",
      "repository": "linux-ubuntu-16.04",
      "tag": "latest"
    }
  ]
  ,"_tipi_version":"{{tipi_version_hash}}"
}