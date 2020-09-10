provider "aws" {}

provider "random" {}

provider "tls" {}

provider "rke" {}

provider "rancher2" {
  alias = "bootstrap"
}
