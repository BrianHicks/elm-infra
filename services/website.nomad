job "website" {
  datacenters = ["dc1"]
  type        = "service"

  update {
    max_parallel     = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    auto_revert      = false
    canary           = 0
  }

  group "website" {
    count = 2

    task "server" {
      driver = "docker"

      config {
        image        = "brianhicks/elm-lang.org:0.18.0"
        network_mode = "weave"

        port_map {
          http = 8000
        }
      }

      resources {
        cpu    = 250 # MHz
        memory = 256 # MB

        network {
          mbits = 10
          port  "http"{}
        }
      }

      service {
        name = "elm-lang"
        port = "http"

        tags = [
          "traefik.enable=true",
          "traefik.frontend.rule=Host:letsdosome.science",
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

  group "strip-www" {
    count = 1

    task "server" {
      driver = "docker"

      env {
        HOST = "letsdosome.science"
      }

      config {
        image        = "brianhicks/strip-www:1.0.0"
        network_mode = "weave"

        port_map {
          http = 80
        }
      }

      resources {
        cpu    = 100 # MHz
        memory = 64  # Mb

        network {
          port "http" {}
        }
      }

      service {
        name = "elm-lang-strip-www"
        port = "http"

        tags = [
          "traefik.enable=true",
          "traefik.frontend.rule=Host:www.letsdosome.science",
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
