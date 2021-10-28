{
  "variables": { },
  "builders": [
    {
      "type": "docker",
      "image": "tipibuild/tipi-ubuntu",
      "commit": true
    }
  ],
  "post-processors": [
    { 
      "type": "docker-tag",
      "repository": "linux",
      "tag": "latest"
    }
  ]
  ,"_tipi_version":"{{tipi_version_hash}}"


}
