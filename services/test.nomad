job "test" {
  datacenters = ["dc1"]
  type        = "service"

  update {
    max_parallel     = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    auto_revert      = false
    canary           = 0
  }

  group "test" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "cheese" {
      driver = "docker"

      config {
        image = "errm/cheese:cheddar"

        port_map {
          http = 80
        }
      }

      resources {
        cpu    = 100 # MHz
        memory = 32  # MB

        network {
          mbits = 10
          port  "http"{}
        }
      }

      service {
        name = "test"
        port = "http"
        tags = [
          "traefik.enable=true",
          "traefik.frontend.rule=Host:test.letsdosome.science",
        ]

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
