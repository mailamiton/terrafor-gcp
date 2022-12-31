resource "aws_security_group" "alb_sg" {
  name        = "terraform_alb_security_group"
  description = "Terraform load balancer security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group"
  }
}

resource "aws_alb" "alblb" {
  name            = "alb-terraform"
  security_groups = ["${aws_security_group.alb_sg.id}"]
  subnets         = var.alb_subnet
  tags = {
    Name = "${var.alb_name}"
  }
}


resource "aws_lb_listener" "alb_lnr" {
  load_balancer_arn = aws_alb.alblb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.albtg.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "albtg" {
  name     = "alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  #target_type = "ip"

  depends_on = [
    aws_alb.alblb
  ]

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    port                = 80
    timeout             = "5"
    path                = "/"
    unhealthy_threshold = "3"
  }

  tags = {
    Name = "${var.alb_name}"
  }
}


# Attach an EC2 instance to the target group on port 80
resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_lb_target_group.albtg.arn
  target_id        = var.target_id
  port             = 80
}
