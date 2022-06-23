# Cloud-Terraform
Archivos Terraform (Infrastracture as Code) que permiten desplegar algunos de los recursos de la arquitectura planteada en el TP2.

## Pasos
`$> cd terraform-gcp`

`$> terraform init`

`$> terraform validate`

`$> terraform plan`

`$> terraform apply`

## Terraform Functions
- [format](https://www.terraform.io/language/functions/format)
- [file](https://www.terraform.io/language/functions/file)
- [map](https://www.terraform.io/language/functions/map)
- [base64encode](https://www.terraform.io/language/functions/base64encode)

## Terraform Meta-Arguments
- [depends_on](https://www.terraform.io/language/meta-arguments/depends_on)
- [for_each](https://www.terraform.io/language/meta-arguments/for_each)
- [lifecycle](https://www.terraform.io/language/meta-arguments/lifecycle)