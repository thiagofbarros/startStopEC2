#!/bin/bash

getEC2Status() {
	aws --region $REGION ec2 describe-instances --instance-ids $EC2INSTANCE \
		--query "Reservations[].Instances[].State[].Name" --output text
}
startEC2() {
	aws --region $REGION ec2 start-instances --instance-ids $EC2INSTANCE
}
stopEC2() {
	aws --region $REGION ec2 stop-instances --instance-ids $EC2INSTANCE
}
showPublicIP() {
	aws --region $REGION ec2 describe-instances --instance-ids $EC2INSTANCE\
		--query "Reservations[].Instances[].PublicIpAddress" --output text
}
options() {
	echo "$0 [Options] instance-id"
	echo "Options: \n \
	start    	Start instance \n \
	stop     	Stop instance \n \
	status   	Show instance state \n \
	publicip 	Show Public IP"
}

if [ $# -ne 2 -o $# = 0 ]; then
	options
  	exit 2
fi

EC2INSTANCE=$2
REGION=us-east-1
EC2STATE=$(getEC2Status)

if [ "$1" = "start" ]; then
	if [ "$EC2STATE" = "running"  ]; then
		echo "Instance already running"
	else
		echo "Starting instance $EC2INSTANCE..."
		startEC2
		exit $?
	fi
elif [ "$1" = "stop" ]; then
	if [ "$EC2STATE" = "stopped"  ]; then
        echo "Instance already stopped"
		exit $?
    else
		echo "Stopping instance $EC2INSTANCE..."
        stopEC2
    fi
elif [ "$1" = "status" ]; then
	echo "Displaying state of $EC2INSTANCE"
	getEC2Status
	exit $?
elif [ "$1" = "publicip" ]; then
	echo "Public IP: $(showPublicIP)"
	exit $?
fi

exit $?
