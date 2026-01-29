#!/bin/bash
ALB_URL="http://starttech-alb-237429390.us-east-1.elb.amazonaws.com"
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" $ALB_URL)

if [ "$RESPONSE" -eq 200 ]; then
  echo "SUCCESS: Backend is healthy (HTTP 200)"
else
  echo "FAILED: Backend returned HTTP $RESPONSE"
  exit 1
fi