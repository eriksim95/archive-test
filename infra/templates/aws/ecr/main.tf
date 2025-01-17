resource "aws_ecr_repository" "ecr_repository" {
  for_each = local.repositories
  name     = each.key
	
  image_scanning_configuration {
	scan_on_push = true
  }

  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "default_policy" {
  for_each   = local.repositories
  repository = aws_ecr_repository.ecr_repository[each.key].name

  policy = jsonencode({rules = concat(local.untagged_images_rule, local.pull_request_images_rule)}) #local.remove_max_images_rule

  depends_on = [
    aws_ecr_repository.ecr_repository
  ]
}
