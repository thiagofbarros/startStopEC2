#!/bin/bash

### Definir região da AWS
REGION=us-east-1
EC2INSTANCE=$2

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
	publicip 	Show Public IP \n \
	help 		Show help"
}

EC2STATE=$(getEC2Status)

case "$1" in
	"start")
		if [ "$EC2STATE" = "running"  ]; then
			echo "Instance already running"
		else
			echo "Starting instance $EC2INSTANCE..."
			startEC2
			exit $?
		fi
	;;	
 	"stop")
		if [ "$EC2STATE" = "stopped"  ]; then
			echo "Instance already stopped"
			exit $?
		else
			echo "Stopping instance $EC2INSTANCE..."
			stopEC2
		fi
	;;	
	"status")
		echo "Displaying state of $EC2INSTANCE"
		getEC2Status
		exit $?
	;;	
 	"publicip")
		echo "Public IP: $(showPublicIP)"
		exit $?
	;;
	"help")
		options
	;;
	*)
		echo "Option not found!"
		options
	;;	
esac

exit $?
