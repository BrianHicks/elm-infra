job "ingress" {
  datacenters = ["dc1"]

  # we want to run the load balancer on every node so we can point DNS to any of
  # them and be fine.
  type = "system"

  update {
    max_parallel     = 1
    min_healthy_time = "20s"
    healthy_deadline = "3m"
    auto_revert      = true
  }

  group "ingress" {
    count = 1

    restart {
      # The number of attempts to run the job within the specified interval.
      attempts = 10
      interval = "5m"
      mode     = "delay"
      delay    = "25s"
    }

    task "traefik" {
      driver = "docker"

      # The "config" stanza specifies the driver configuration, which is passed
      # directly to the driver to start the task. The details of configurations
      # are specific to each driver, so please see specific driver
      # documentation for more information.
      config {
        image = "traefik:v1.5.3"

        args = [
          "--logLevel=INFO",
          "--consulCatalog",
          "--consulCatalog.endpoint=172.17.0.1:8500",
          "--consulCatalog.exposedByDefault=false",
          "--api.entrypoint=api",
          "--api.dashboard",
          "--entrypoints=Name:http Address::80",
          "--entrypoints=Name:api Address::8081",
        ]
      }

      resources {
        cpu    = 100 # MHz
        memory = 64  # MB

        network {
          mbits = 10

          port "http" {
            static = 80
          }

          port "https" {
            static = 443
          }

          port "api" {
            static = 8081
          }
        }
      }

      service {
        name = "ingress"
        port = "http"

        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }

      service {
        name = "ingress"
        port = "https"

        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
