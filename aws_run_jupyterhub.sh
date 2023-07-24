#!/bin/bash
sudo apt update
sudo apt install jq
INSTANCENAME=JupyterHUBScript
IMAGEID=ami-0989fb15ce71ba39e
INSTANCETYPE=t3.micro
KEYNAME=afaq_jupyter_key
SECURITYGROUP=sg-0337283ec58633850
SUBNETID=subnet-01e37a5ce5ffacd11 
INSTANCEID=$(aws ec2 run-instances --image-id $IMAGEID --count 1 --instance-type $INSTANCETYPE --key-name $KEYNAME  --security-group-ids $SECURITYGROUP --subnet-id $SUBNETID  --query "Instances[0].InstanceId" --output text --user-data file://jupyterhub-user-data.txt)
echo "EC2 Instance Launched with ID: $INSTANCEID"
aws ec2 create-tags --resources $INSTANCEID --tags Key=Name,Value=$INSTANCENAME
ELASTICIP=$(aws ec2 describe-addresses --query Addresses[0].PublicIp --output text)
aws ec2 associate-address --public-ip $ELASTICIP --instance-id "$INSTANCEID"
echo "ELASTICIP $ELASTICIP associated with instance id $INSTANCEID"
