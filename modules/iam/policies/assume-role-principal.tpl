{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
     "Principal": {
        "AWS": ["arn:aws:iam::685306736016:user/testuseriam"],
        "Service" : ["ec2.amazonaws.com"]
      }
  }
}
