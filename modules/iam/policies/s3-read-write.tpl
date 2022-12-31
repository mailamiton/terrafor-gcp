{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowToSeeAllBucket",
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "*"
        },
        {
            "Sid": "AllowToGetObjectInBucket",
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "*"
        },
        {
            "Sid": "AllowToPutObjectInBucket",
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": "*"
        },
        {
            "Sid": "AllowToListObjectInBucket",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "*"
        }
    ]
}