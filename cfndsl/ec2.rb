CloudFormation do
  Description("AWS CloudFormation Sample Template EC2InstanceSample: Create an Amazon EC2 instance running the Amazon Linux AMI. The AMI is chosen based on the region in which the stack is run. This example uses the default security group, so to SSH to the new instance using the KeyPair you enter, you will need to have port 22 open in your default security group. **WARNING** This template an Amazon EC2 instances. You will be billed for the AWS resources used if you create a stack from this template.")
  AWSTemplateFormatVersion("2010-09-09")

  Parameter("KeyName") do
    Description("Name of an existing EC2 KeyPair to enable SSH access to the instance")
    Type("String")
  end

  Parameter("IAMname") do
    Description("Name of an existing IAM account to enable AWS CLI to the instance")
    Type("String")
  end

  Mapping("RegionMap", {
  "ap-northeast-1" => {
    "AMI" => "ami-dcfa4edd"
  },
  "ap-southeast-1" => {
    "AMI" => "ami-74dda626"
  },
  "ap-southeast-2" => {
    "AMI" => "ami-b3990e89"
  },
  "eu-west-1"      => {
    "AMI" => "ami-24506250"
  },
  "sa-east-1"      => {
    "AMI" => "ami-08111162"
  },
  "us-east-1"      => {
    "AMI" => "ami-7f418316"
  },
  "us-west-1"      => {
    "AMI" => "ami-951945d0"
  },
  "us-west-2"      => {
    "AMI" => "ami-16fd7026"
  }
})

  Resource("Ec2Instance") do
    Type("AWS::EC2::Instance")
    Property("KeyName", Ref("KeyName"))
    Property("ImageId", FnFindInMap("RegionMap", Ref("AWS::Region"), "AMI"))
    Property("IamInstanceProfile", Ref("IAMname"))
    Property("UserData", FnBase64(FnJoin("", [
        "#!/bin/bash",
        "\n",
        "aws s3 get s3://awstraining-d2/jdk-7u79-linux-x64.rpm",
        "\n",
        "aws s3 get s3://awstraining-d2/jenkins-1.656-1.1.noarch.rpm",
        "\n",
        "rpm -ivh jdk-7u79-linux-x64.rpm",
        "\n",
        "rpm -ivh jenkins-1.656-1.1.noarch.rpm"
        ])))

  end

  Output("InstanceId") do
    Description("InstanceId of the newly created EC2 instance")
    Value(Ref("Ec2Instance"))
  end

  Output("AZ") do
    Description("Availability Zone of the newly created EC2 instance")
    Value(FnGetAtt("Ec2Instance", "AvailabilityZone"))
  end

  Output("PublicIP") do
    Description("Public IP address of the newly created EC2 instance")
    Value(FnGetAtt("Ec2Instance", "PublicIp"))
  end

  Output("PrivateIP") do
    Description("Private IP address of the newly created EC2 instance")
    Value(FnGetAtt("Ec2Instance", "PrivateIp"))
  end

  Output("PublicDNS") do
    Description("Public DNSName of the newly created EC2 instance")
    Value(FnGetAtt("Ec2Instance", "PublicDnsName"))
  end

  Output("PrivateDNS") do
    Description("Private DNSName of the newly created EC2 instance")
    Value(FnGetAtt("Ec2Instance", "PrivateDnsName"))
  end
end