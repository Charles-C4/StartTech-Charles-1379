#!/bin/bash
ASG_NAME="terraform-20260129153936970800000005"
echo "Initiating Rollback: Refreshing instances to last stable state..."
aws autoscaling start-instance-refresh --auto-scaling-group-name $ASG_NAME