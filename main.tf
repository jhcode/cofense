provider "aws" {
  region = "${var.region}"
  profile = "cofense_keys"
}

resource "aws_s3_bucket" "my_log_bucket" {
  bucket = "${var.my_log_bucket}"
  acl = "log-delivery-write"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "${var.my_bucket}"
  acl = "private"
  logging {
    target_bucket = "${aws_s3_bucket.my_log_bucket.id}"
    target_prefix = "logs/"
  }
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = "${aws_s3_bucket.my_bucket.id}"
  policy = "${data.template_file.policy.rendered}"
}

resource "aws_sns_topic" "sns_topic" {
  name = "put-object-notifier"
}
