{
  "variables": { },
  "builders": [
    {
      "type": "docker",
      "image": "tipibuild/tipi-ubuntu-staging-383",
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

}
