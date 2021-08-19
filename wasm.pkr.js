{
  "variables": { },
  "builders": [
    {
      "type": "docker",
      "image": "tipibuild/tipi-ubuntu",
      "commit": true,
      "changes": [
        "RUN apt install openssh-server",
        "RUN service ssh start"
        "EXPOSE 22"
      ]
    }
  ],
  "post-processors": [
    { 
      "type": "docker-tag",
      "repository": "wasm",
      "tag": "latest"
    }
  ]

}
