sudo apt update
sudo apt install jq
FILE=./instanceinfo.json
if test -f "$FILE"; then
    echo "removing existing $FILE file  "
    rm  $FILE
fi
FILE=./addresses.json
if test -f "$FILE"; then
    echo "removing existing $FILE file "
    rm  $FILE
fi

aws ec2 run-instances --image-id ami-0989fb15ce71ba39e --count 1 --instance-type t3.micro --key-name "afaq's jupyter key" --security-group-ids sg-0337283ec58633850 --subnet-id subnet-01e37a5ce5ffacd11 --user-data file://jupyterhub-user-data.txt >> instanceinfo.json
INSTANCEID=$(jq -r ".Instances[0].InstanceId" instanceinfo.json)
echo "EC2 Instance Launched with ID: $INSTANCEID"
aws ec2 create-tags --resources $INSTANCEID --tags Key=Name,Value=JupyterHUBScript
aws ec2 describe-addresses >> addresses.json
ELASTICIP=$(jq -r ".Addresses[0].PublicIp" addresses.json)
aws ec2 associate-address --public-ip 13.50.171.25 --instance-id "$INSTANCEID"
echo "ELASTICIP $ELASTICIP associated with instance id $INSTANCEID"
