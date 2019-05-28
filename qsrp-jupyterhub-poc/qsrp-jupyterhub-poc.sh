#!/usr/bin/env bash

aws_cmd=${aws_cmd:-aws}

read -p "Enter project name and press [ENTER]: " ROOT_NAME

read -p "Enter AWS profile and press [ENTER]: " AWS_PROFILE

read -p "Enter AWS command and press [ENTER] (default to aws): " AWS_CMD
AWS_CMD=${AWS_CMD:-aws}

ROOT_NAME_LOWER=$(echo "$ROOT_NAME" | tr '[:upper:]' '[:lower:]')

# Create IAM Role
$AWS_CMD iam create-role --role-name $ROOT_NAM-EKSServiceRole --assume-role-policy-document file://eks-service-role-trust-policy.json > /tmp/iamUnauthRole
if [ $? -eq 0 ]
then
    echo "Service role successfully created"
else
    echo "Using the existing role ..."
    $aws_cmd iam get-role --role-name $ROOT_NAM-EKSServiceRole > /tmp/iamUnauthRole
    $aws_cmd iam update-assume-role-policy --role-name $ROOT_NAM-EKSServiceRole --policy-document file://eks-service-role-trust-policy.json
fi
$aws_cmd iam put-role-policy --role-name $ROOT_NAM-EKSServiceRole --policy-document file://eks-service-role-policy.json



# Create kubeconfig
KUBE_CONFIG_NAME=config-$ROOT_NAME_LOWER
cat kubeconfig | sed 's/PLACEHOLDER_CLUSTER_NAME/g'$ROOT_NAME'' | sed 's/PLACEHOLDER_AWS_PROFILE/g'$AWS_PROFILE'' > /tmp/$KUBE_CONFIG_NAME

export KUBECONFIG_SAVED=$KUBECONFIG

