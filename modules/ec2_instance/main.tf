resource "aws_instance" "example" {
    ami           =  var.ami
    instance_type = var.instance_type
    subnet_id     = var.subnet_id
    vpc_security_group_ids = [aws_security_group.example_sg.id]  # Attach security group
    

    
  
    tags = {
      Name = "r2-instance"
    }
}




