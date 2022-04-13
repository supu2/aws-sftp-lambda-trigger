#!/bin/sh
echo -n "SFTP_SERVER:"
read -r SFTP_SERVER 
echo -n "SFTP Username:"
read -r USERNAME
echo -n "Upload file:"
read -r UPLOADFILE
echo "put ${UPLOADFILE}" | sftp -i ssh/id_rsa  $USERNAME@$SFTP_SERVER
sleep 10 
echo 'ls' | sftp -i ssh/id_rsa  $USERNAME@$SFTP_SERVER