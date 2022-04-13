# Prerequire
 - awscli and account
 - terraform-cli
 - docker

 # Deployment
 ```
 make prepare
 make deploy
 ```
# Destroy
```
make destroy
```

 # Test
```
make build
make run 
SFTP_SERVER:xxxx.server.transfer.us-east-1.amazonaws.com
SFTP Username:ftp-user
Upload file:/opt/test-file.txt

sftp> put /opt/test-file.txt
Uploading /opt/test-file.txt to /test-clouddrove-sftp-bucket/incoming/test-file.txt
/opt/test-file.txt                                                                                                                                    100%   26     0.1KB/s   00:00    
Connected to xxx.server.transfer.us-east-1.amazonaws.com.
sftp> ls
f20-00000000000000000000  f20-11111111111111111111  
f20-22222222222222222222  f20-asd123asdsad
```