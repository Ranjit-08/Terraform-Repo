module "ranjit" {
    source = "../day07-modulecode"
    ami = var.ami
    type = var.type
    name = var.name
}