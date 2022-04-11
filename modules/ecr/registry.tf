resource "aws_ecr_repository" "ecrCreate"{
  name                 = "ecr-repo1"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

#   provisioner "local-exec" {
#     command = <<EOT
       
#     docker login --username AWS -p $(aws ecr get-login-password --region ${var.region}) ${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com
#     docker images
#     docker push ${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.repository-name}
    
#     EOT
#     # docker tag ${var.image_id} ${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.repository-name}:${var.image_tag}
#     # docker push ${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.repository-name}
#     #aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com
#     #docker login --username AWS -p $(aws ecr get-login-password --region ${var.region}) ${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com
#     #aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${aws_account_id}.dkr.ecr.${region}.amazonaws.com
#     interpreter = ["PowerShell", "-Command"]
#   }
# }


}

resource "null_resource" "upload_image" {

 provisioner "local-exec" {
    
    command = <<EOT
       
    docker login --username AWS -p $(aws ecr get-login-password --region ${var.region}) ${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com
    docker images
    docker push ${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.repository-name}
    
    EOT

     interpreter = ["PowerShell", "-Command"]
  }

  depends_on = [
    aws_ecr_repository.ecrCreate,
  ]
}

resource "aws_ecr_repository_policy" "ecrPolicy" {
  repository = aws_ecr_repository.ecrCreate.name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "new policy",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}