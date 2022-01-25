#! /bin/bash
echo `pwd`
ssh -i '../test.pem' ubuntu@10.10.10.10 'ls /home/ubuntu/server/server-*.jar'
