module "main" {
    source = "../terraform-roboshop-components"
    component = var.component
    rule_priority = var.rule_priority
}