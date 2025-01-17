locals {
  repositories = { for repo in var.repositories : repo.name => repo }

  untagged_images_rule = [{
    rulePriority = 1
    description = "Remove untagged images after ${var.days_to_remove_untagged_images} days."
    selection = {
      tagStatus = "untagged"
      countType = "sinceImagePushed"
      countUnit = "days"
      countNumber = var.days_to_remove_untagged_images
    }
    action = {
      type = "expire"
    }
  }]

  pull_request_images_rule = [{
    rulePriority = 2
    description = "Remove images created by pull-requests older than ${var.pr_image_count} days."
    selection = {
      tagStatus = "tagged"
      tagPatternList = ["*pull_request*"],
      countType = "imageCountMoreThan"
      countNumber = var.pr_image_count
    }
    action = {
      type = "expire"
    }
  }]
}
