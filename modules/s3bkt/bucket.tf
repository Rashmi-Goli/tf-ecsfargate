resource "aws_s3_bucket" "s3-bkt"{
    bucket = var.bucket_name
    # acl    = "public"
    
}