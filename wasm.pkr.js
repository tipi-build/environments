{
  "variables": { },
  "builders": [
    {
      "type": "docker",
      "image": "nxxm/tipi-ubuntu-staging-275",
      "commit": true,
      "changes": [
        "EXPOSE 22"
      ]
    }
  ]
}