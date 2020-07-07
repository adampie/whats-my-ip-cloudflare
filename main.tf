# What's my IP?

provider "cloudflare" {
  version = "~> 2.0"
}

## Cloudflare Worker
resource "cloudflare_worker_script" "whats_my_ip" {
  name = "ip"
  content = file("script.js")
}

resource "cloudflare_worker_route" "route" {
  zone_id = var.zone_id
  pattern = "ip.${var.domain_name}"
  script_name = cloudflare_worker_script.whats_my_ip.name
}

## Route to enable Worker route
resource "cloudflare_record" "ip" {
  zone_id = var.zone_id
  name    = "ip"
  value   = "192.0.2.1"
  type    = "A"
  proxied = true
}

## Variables
variable "zone_id" {
  description = "Cloudflare Domain Zone ID"
}

variable "domain_name" {
  description = "Domain name assigned to zone_id"
}
