output "endpoint" {
  value       = module.sftp.*.transfer_server_endpoint 
  description = "The SFTP endpoint"
}
