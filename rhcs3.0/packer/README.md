## Preparing a build environment

To build an image you need:

- Access to AWS EC2 with VPC and EBS
- An activation key on RHSM that is associated with subscription providing OCP and RHGS repositories (usually the Employee SKU for System Type = Virtual)
- A Workstation with packer and ansible installed

### Configure your build environment

Prepare a file called `packer_var_file.json` - like this:

```
{
    "aws_ami": "ami-0af1378dc29c40afb",
    "instructor_pub_key_file": "/Users/.../work/ceph-test-drive-bootstrap/rhcs3.0/packer/fetch/instructor_key.pub",
    "rhn_user": "YOUR_RHN_USER",
    "rhn_pass": "YOUR_RHN_PASS",
    "aws_access_key": "YOUR_AWS_ACCESS",
    "aws_secret_key": "YOUR_AWS_SECRET",
    "aws_region": "eu-central-1"
}
```

Modify the variables to your liking... DO NOT check this file into git.

You also need the CSV file containing all the Red Hat fleet accounts reserved on Qwiklab. Suppose it's in ~/Downloads/redhat_new_fleet_hosted_zones.csv run the following to option the value containing all comma-separated AWS account id's:

```
awk 'BEGIN { FS=","; OFS=","; } {print $1}' ~/Downloads/redhat_new_fleet_hosted_zones.csv | sed -n -e 's/^\([0-9].*\)\.aws\.testdrive\.openshift\.com\./\"\1\"/p' | paste -d, -s - -
```

Replace XXXX into "ami_users": ["XXXX"] in packer-multi-region_user.json with this value.

### Launching Packer

#### Single region AMI

Use this approach to build a single AMI in a single region - great for prototyping an update to the already existing image

```
time packer build -var-file packer_var_file.json packer.json
```
This takes 50-60 minutes.


#### Single region AMI

After ensuring that all the steps work for a single region - use this to create globally distributed AMIs for use in Qwiklabs:

```
time packer build -var-file packer_var_file.json packer-multi-region_user.json
```