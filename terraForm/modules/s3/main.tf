resource "aws_s3_bucket" "aiops-s3" {
  bucket = "aiops-s3"
  tags = {
    name = "aiops bucket"
    environment = "training"
  }
}