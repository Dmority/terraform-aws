// aws_helper.go

package test

import (
	"fmt"
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
)

func getVpcInfo(t *testing.T, vpcID string, region string) (*ec2.Vpc, error) {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(region)},
	)

	if err != nil {
		return nil, err
	}
	svc := ec2.New(sess)
	input := &ec2.DescribeVpcsInput{
		VpcIds: []*string{
			aws.String(vpcID),
		},
	}

	result, err := svc.DescribeVpcs(input)
	if err != nil {
		return nil, err
	}

	if len(result.Vpcs) == 0 {
		return nil, fmt.Errorf("no VPCs found with the provided VPC ID")
	}

	return result.Vpcs[0], nil
}

func getVpcEnableDnsHostnames(t *testing.T, vpcID string, region string) (bool, error) {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(region)},
	)

	if err != nil {
		return false, err
	}

	svc := ec2.New(sess)
	input := &ec2.DescribeVpcAttributeInput{
		Attribute: aws.String("enableDnsHostnames"),
		VpcId:     aws.String(vpcID),
	}

	result, err := svc.DescribeVpcAttribute(input)
	if err != nil {
		return false, err
	}

	return *result.EnableDnsHostnames.Value, nil
}

func getVpcEnableDnsSupport(t *testing.T, vpcID string, region string) (bool, error) {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(region)},
	)

	if err != nil {
		return false, err
	}

	svc := ec2.New(sess)
	input := &ec2.DescribeVpcAttributeInput{
		Attribute: aws.String("enableDnsSupport"),
		VpcId:     aws.String(vpcID),
	}

	result, err := svc.DescribeVpcAttribute(input)
	if err != nil {
		return false, err
	}

	return *result.EnableDnsSupport.Value, nil
}

func getSubnetsInfo(t *testing.T, subnetID string, region string) (*ec2.Subnet, error) {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(region)},
	)

	if err != nil {
		return nil, err
	}

	svc := ec2.New(sess)
	input := &ec2.DescribeSubnetsInput{
		SubnetIds: []*string{
			aws.String(subnetID),
		},
	}
	result, err := svc.DescribeSubnets(input)
	if err != nil {
		return nil, err
	}
	if len(result.Subnets) == 0 {
		return nil, fmt.Errorf("no subnet found with the given ID: %s", subnetID)
	}

	return result.Subnets[0], nil
}
