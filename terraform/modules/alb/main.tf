# Application Load Balancer
resource "aws_lb" "this" {
  name               = "${var.project_name}-alb-nandini"
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.alb_sg_id]
}

# Blue Target Group
resource "aws_lb_target_group" "blue" {
  name        = "${var.project_name}-blue-nandini"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 5
  }
}

# Green Target Group
resource "aws_lb_target_group" "green" {
  name        = "${var.project_name}-green-nandini"
  port        = 1337
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 5
  }
}

# HTTP Listener (default → Blue)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}