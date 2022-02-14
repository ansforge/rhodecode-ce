project = "ans/rhodecode"

# Labels can be specified for organizational purposes.
labels = { "domaine" = "ans" }

runner {
  enabled = true
  data_source "git" {
    ref = var.datacenter
  }
  poll {
    enabled = true
  }
}

# An application to deploy.
app "ans/rhodecode" {

  # Build specifies how an application should be deployed.
  build {
    build {
        use "docker-pull" {
           image = "ans/rhodecode-ce"
	   tag = "latest"
        }
    }
  }

  # Deploy to Nomad
  deploy {
    use "nomad-jobspec" {
      jobspec = templatefile("${path.app}/rhodecode.nomad.tpl", {
        datacenter = var.datacenter
        proxy_host = var.proxy_host
        proxy_port = var.proxy_port
		name_volume_db = var.name_volume_db
		name_volume_repos = var.name_volume_repos
		size_volume_db = var.size_volume_db
		size_volume_repos = var.size_volume_repos
		cpu = var.cpu
		memory = var.memory
      })
    }
  }
}

variable "datacenter" {
  type    = string
  default = "dc1"
}

variable "dockerfile_path" {
  type = string
  default = "Dockerfile"
}

variable "registry_path" {
  type = string
  default = "registry.repo.proxy-dev-forge.asip.hst.fluxus.net/ans"
}

variable "proxy_host" {
  type = string
  default = ""
}

variable "proxy_port" {
  type = string
  default = ""
}

variable "name_volume_db" {
  type = string
  default = "rhodecode-db"
}

variable "name_volume_repos" {
  type = string
  default = "rhodecode-repos"
}

variable "size_volume_db" {
  type = string
  default = "10"
}

variable "size_volume_repos" {
  type = string
  default = "100"
}

variable "cpu" {
  type = string
  default = "5000"
}

variable "memory" {
  type = string
  default = "2048"
}
