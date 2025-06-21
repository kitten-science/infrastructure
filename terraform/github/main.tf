locals {
  organization = "kitten-science"
}

data "github_repositories" "repositories" {
  query = "fork:true org:${local.organization}"
}

data "github_repository" "repository" {
  for_each  = toset(data.github_repositories.repositories.full_names)
  full_name = each.key
}

resource "github_repository_ruleset" "default_branch" {
  for_each    = { for _ in data.github_repository.repository : _.name => _ if !_.private }
  name        = "default-branch"
  repository  = each.key
  target      = "branch"
  enforcement = "disabled" # "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  bypass_actors {
    actor_id    = 5
    actor_type  = "RepositoryRole"
    bypass_mode = "always"
  }

  rules {
    branch_name_pattern {
      name     = "Enforce 'main' as default branch name."
      operator = "regex"
      pattern  = "^main$"
    }
    creation                = false
    update                  = false
    deletion                = true
    required_linear_history = true
    required_signatures     = true
    non_fast_forward        = true

    #required_deployments {
    #  required_deployment_environments = ["test"]
    #}

    pull_request {
      dismiss_stale_reviews_on_push     = true
      require_code_owner_review         = false # Everyone with write permission can review.
      require_last_push_approval        = true
      required_approving_review_count   = 1
      required_review_thread_resolution = true
    }
  }
}

resource "github_repository_ruleset" "release_tags" {
  for_each    = { for _ in data.github_repository.repository : _.name => _ if !_.private }
  name        = "release-tags"
  repository  = each.key
  target      = "tag"
  enforcement = "disabled" # "active"

  conditions {
    ref_name {
      include = ["~ALL"]
      exclude = []
    }
  }

  bypass_actors {
    actor_id    = 5
    actor_type  = "RepositoryRole"
    bypass_mode = "always"
  }

  rules {
    tag_name_pattern {
      name     = "Enforce prefixed, semantic version."
      operator = "regex"
      pattern  = "^v\\d+\\.\\d+\\.\\d+$"
    }
    creation                = false
    update                  = true
    deletion                = true
    required_signatures     = true
    required_linear_history = true
    non_fast_forward        = true

    #required_deployments {
    #  required_deployment_environments = ["test"]
    #}
  }
}

#output "test" {
#  value = { for _ in data.github_repository.repository : _.full_name => _ }
#}
