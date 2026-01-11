resource "aws_lb" "backend_alb" {
    name               = "${local.common_name_suffix}-backend-alb"
    internal           = true
    load_balancer_type = "application"
    security_groups    = [local.backend_alb_sg_id]
    subnets            = local.public_subnet_ids

    enable_deletion_protection = false #prevention of accidental deletion

    tags = merge(
        local.common_tags,{
            Name = "${var.project_name}-${var.environment}-backend-alb"
        }
    )
}

# backend alb listening on port 80
resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hi i'm from backend Alb HTTP"
      status_code  = "200"
    }
  }
}