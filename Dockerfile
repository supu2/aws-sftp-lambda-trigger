FROM alpine:3.14
COPY test.sh /usr/local/bin/ 
RUN apk add openssh-client=8.6_p1-r3 --no-cache && adduser -D sftp  --home /home/sftp \
    && chmod +x /usr/local/bin/test.sh
USER sftp
CMD ["test.sh"]