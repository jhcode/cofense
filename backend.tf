terraform {
  backend "s3" {
        bucket = "cofense-prod-state-files"
        key = "cofense/terraform.tfstate"
        region = "us-west-2"
        lock_table = "cofense-prod-terraform-lock"
  }
}

# Assumption here is that there's a state bucket that cofense uses to maintain terraform states for all project-envs