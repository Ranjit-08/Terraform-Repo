resource "aws_instance" "name" {
  # ami = "ami-07860a2d7eb515d9a"
    ami = "ami-0bdd88bd06d16ba03"
    instance_type = "t3.micro"
    tags = {
      Name = "lifecycle-ec2"
    }
    lifecycle {
     create_before_destroy = true
    }
    #lifecycle {
    #  prevent_destroy = true
    #}
    # lifecycle {
    #   ignore_changes = [tags]
    # }

    

}


