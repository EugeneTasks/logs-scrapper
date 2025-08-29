/**
 * This configuration requires changes in the Docker Engine configuration file.
 * Specifically, ensure that the JSON log driver is set and appropriate log options are configured.
 * Refer to Docker documentation for details on setting the log driver and log options in the engine config.
 */

 {
  "log-driver": "json-file",
  "log-opts": {
    "tag": "{{.Name}}"
  }
}