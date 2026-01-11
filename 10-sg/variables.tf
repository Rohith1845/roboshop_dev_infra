variable "project_name" {
    default = "roboshop"
  
}

variable "environment" {
    default = "dev"
  
}

variable "sg_name" {
    default = [
        #databases
        "mongodb" , "mysql" , "redis" , "rabbitmq" ,
        #backend
        "catalogue" , "user" , "cart" , "shipping" , "payment" ,
        # frontend
        "frontend" ,
        #bastion
        "bastion" ,
        #load balancer
        "frontend_alb" ,
        "backend_alb"

    ]
  
}