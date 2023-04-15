// main_test.go

package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestMain(t *testing.T) {

	awsRegion := "ap-northeast-1"

	terraformOptions := &terraform.Options{TerraformDir: "../"}
	//defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	t.Run("TestVPC", func(t *testing.T) {
		testVPC(t, terraformOptions, awsRegion)
		testSubnets(t, terraformOptions, awsRegion)
	})
}
