resource "random_id" "bucket_id_pan1" {
  byte_length = 8
}


resource "aws_s3_bucket" "bucket_pan1" {
  bucket = "bootstrap-${random_id.bucket_id_pan1.hex}"
}

resource "aws_s3_bucket_acl" "bucket_pan1_acl" {
  bucket = aws_s3_bucket.bucket_pan1.id
  acl    = "private"
}



resource "aws_s3_object" "bootstrap_firewall1" {
  for_each = toset(var.bootstrap_directories)
  bucket  = aws_s3_bucket.bucket_pan1.id
  key     = format("%s", each.value)
  content = "/dev/null"
}

resource "aws_s3_object" "object_pan1" {
for_each = fileset(path.module, "s3/pan1/*")
bucket  = aws_s3_bucket.bucket_pan1.id
key = replace(each.value, "s3/pan1/", "config/")
source = each.value
}

variable "bootstrap_directories" {
  description = "The directories comprising the bootstrap package"
  default = [
    "config/",
    "content/",
    "software/",
    "license/",
    "plugins/"
  ]
}
