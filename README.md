This project is SFTP Server and based aws services like s3, lambda and transfer familty.
SFTP server use the s3 as backend. User can login SFTP server with ssh-key. 
After file uploaded s3  trigger notification to the lambda function.
The function reads 20 bytes of content and create new file in s3. The filename will be f20-$(first 20 bytes of content)

# Topology
![image](https://user-images.githubusercontent.com/53692719/163347163-39c8d927-f19f-4e54-b583-9f5b1c3046cf.png)


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
