// terraform_network_test.go

package test

import (
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func testVPC(t *testing.T, terraformOptions *terraform.Options, awsRegion string) {

	vpcOutputAll := terraform.OutputMap(t, terraformOptions, "vpc_output_all")

	expectedVpcCidrBlock := "192.168.0.0/16"
	expectedTags := map[string]string{
		"Name":       "sample-test-vpc",
		"ManagedBy":  "terraform",
		"CostCenter": "poc",
		"repo":       "Dmority/terraform-aws",
	}

	actualVpcInfo, err := getVpcInfo(t, vpcOutputAll["vpc_id"], awsRegion)
	if err != nil {
		t.Fatal(err)
	}
	actualVpcEnableDnsHostnames, err := getVpcEnableDnsHostnames(t, vpcOutputAll["vpc_id"], awsRegion)
	if err != nil {
		t.Fatal(err)
	}

	actualVpcEnableDnsSupport, err := getVpcEnableDnsSupport(t, vpcOutputAll["vpc_id"], awsRegion)
	if err != nil {
		t.Fatal(err)
	}

	assert.Equal(t, expectedVpcCidrBlock, *actualVpcInfo.CidrBlock)
	assert.True(t, actualVpcEnableDnsHostnames)
	assert.True(t, actualVpcEnableDnsSupport)

	actualTags := aws.GetVpcById(t, vpcOutputAll["vpc_id"], awsRegion).Tags
	assert.Equal(t, expectedTags["Name"], actualTags["Name"])
	assert.Equal(t, expectedTags["ManagedBy"], actualTags["ManagedBy"])
	assert.Equal(t, expectedTags["CostCenter"], actualTags["CostCenter"])
	assert.Equal(t, expectedTags["repo"], actualTags["repo"])

}

func testSubnets(t *testing.T, terraformOptions *terraform.Options, awsRegion string) {

	vpcOutputAll := terraform.OutputMap(t, terraformOptions, "vpc_output_all")

	expectedPublicSubnetA := map[string]string{
		"cidr":  "192.168.0.0/24",
		"az":    "ap-northeast-1a",
		"az_id": "apne1-az4",
	}
	expectedPublicSubnetC := map[string]string{
		"cidr":  "192.168.1.0/24",
		"az":    "ap-northeast-1c",
		"az_id": "apne1-az1",
	}
	expectedPrivateSubnetA := map[string]string{
		"cidr":  "192.168.10.0/24",
		"az":    "ap-northeast-1a",
		"az_id": "apne1-az4",
	}
	expectedPrivateSubnetC := map[string]string{
		"cidr":  "192.168.11.0/24",
		"az":    "ap-northeast-1c",
		"az_id": "apne1-az1",
	}

	publicSubnetList := strings.Split(strings.Trim(vpcOutputAll["public_subnets"], "[]"), " ")
	privateSubnetList := strings.Split(strings.Trim(vpcOutputAll["private_subnets"], "[]"), " ")
	actualPublicSubnetAInfo, err := getSubnetsInfo(t, publicSubnetList[0], awsRegion)
	if err != nil {
		t.Fatal(err)
	}
	t.Log(*actualPublicSubnetAInfo)
	actualPublicSubnetCInfo, err := getSubnetsInfo(t, publicSubnetList[1], awsRegion)
	if err != nil {
		t.Fatal(err)
	}
	t.Log(actualPublicSubnetCInfo)
	actualPrivateSubnetAInfo, err := getSubnetsInfo(t, privateSubnetList[0], awsRegion)
	if err != nil {
		t.Fatal(err)
	}
	actualPrivateSubnetCInfo, err := getSubnetsInfo(t, privateSubnetList[1], awsRegion)
	if err != nil {
		t.Fatal(err)
	}

	assert.Equal(t, expectedPublicSubnetA["cidr"], *actualPublicSubnetAInfo.CidrBlock)
	assert.Equal(t, expectedPublicSubnetA["az"], *actualPublicSubnetAInfo.AvailabilityZone)
	assert.Equal(t, expectedPublicSubnetA["az_id"], *actualPublicSubnetAInfo.AvailabilityZoneId)

	assert.Equal(t, expectedPublicSubnetC["cidr"], *actualPublicSubnetCInfo.CidrBlock)
	assert.Equal(t, expectedPublicSubnetC["az"], *actualPublicSubnetCInfo.AvailabilityZone)
	assert.Equal(t, expectedPublicSubnetC["az_id"], *actualPublicSubnetCInfo.AvailabilityZoneId)

	assert.Equal(t, expectedPrivateSubnetA["cidr"], *actualPrivateSubnetAInfo.CidrBlock)
	assert.Equal(t, expectedPrivateSubnetA["az"], *actualPrivateSubnetAInfo.AvailabilityZone)
	assert.Equal(t, expectedPrivateSubnetA["az_id"], *actualPrivateSubnetAInfo.AvailabilityZoneId)

	assert.Equal(t, expectedPrivateSubnetC["cidr"], *actualPrivateSubnetCInfo.CidrBlock)
	assert.Equal(t, expectedPrivateSubnetC["az"], *actualPrivateSubnetCInfo.AvailabilityZone)
	assert.Equal(t, expectedPrivateSubnetC["az_id"], *actualPrivateSubnetCInfo.AvailabilityZoneId)
}
