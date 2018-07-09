# dynamodb tables for Terraform locking
resource "aws_dynamodb_table" "terraform-lock" {
  name           = "${var.project}-${var.environment}-terraform-lock"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
