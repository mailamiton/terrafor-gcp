
resource "aws_launch_configuration" "alconfig" {
  name_prefix   = "auto-launch-config"
  image_id      = var.image_id
  instance_type = var.asg_instance_type

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "asg" {
  name                      = "auto-scaling-group"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  termination_policies      = ["OldestInstance"]
  force_delete              = true
  launch_configuration      = aws_launch_configuration.alconfig.name
  vpc_zone_identifier       = var.asgsubnets

  initial_lifecycle_hook {
    name                 = "foobar"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 2000
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

    notification_metadata = <<EOF
{
  "foo": "bar"
}
EOF

    #notification_target_arn = "arn:aws:sqs:us-east-1:444455556666:queue1*"
    #role_arn                = "arn:aws:iam::123456789012:role/S3Access"
  }

  tag {
    key                 = "foo"
    value               = "bar"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "lorem"
    value               = "ipsum"
    propagate_at_launch = false
  }
}
