output "ec2_public_ip"{
  #module.<name of the module>.<the name of the output of the module>.<desired attribute>
  value = module.myapp-server.webserver_instance.public_ip
}