data "template_file" "policy" {
  template = "${file("${path.module}/templates/bucket_policy.tpl.json")}"

  vars {
    bucket_name = "${var.my_bucket}"
  }
}

data "template_file" "assume_policy" {
  template = "${file("${path.module}/templates/iam_user_assume_policy.tpl.json")}"

  vars {
    iam_role = "${aws_iam_role.role.id}"
  }
}

data "aws_iam_policy_document" "assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_user" "user" {
  name = "cofense-${var.environment}"
}

resource "aws_iam_access_key" "user-key" {
  user = "${aws_iam_user.user.name}"
}

resource "aws_iam_role" "role" {
  name               = "cofense_role"
  path               = "/system/"
  assume_role_policy = "${data.aws_iam_policy_document.assume-role-policy.json}"
}

resource "aws_iam_policy" "assume_policy" {
  name        = "assume-policy-cofense-bucket"
  description = "assume policy"
  policy      = "${data.template_file.assume_policy.rendered}"
}

resource "aws_iam_policy_attachment" "attach" {
  name       = "assume-attachment"
  users      = ["${aws_iam_user.user.name}"]
  policy_arn = "${aws_iam_policy.assume_policy.arn}"

}
