output repositories_urls {
  value = {
    for repo in aws_ecr_repository.ecr_repository : repo.name => repo.repository_url
  }
}

output repositories_arns {
  value = {
    for repo in aws_ecr_repository.ecr_repository : repo.name => repo.arn
  }
}
