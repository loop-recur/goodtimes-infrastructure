### Infrastructure-as-code

Using this repo you can spin up a new goodtimes cluster or make
changes to the existing one.

To select the cluster to affect, set the terraform remote.

```bash
# choose deployment environment
terraform remote -name=looprecur/gt_development -access-token=xyz

# now retrieve microservice-template modules
terraform get

# look at current deployment state
terraform show

# see what terraform will do when you run it for real
terraform plan
```

We will each use individual access tokens. Ask Joe or Taylor
to get your own.

Remember to check `terraform plan` before doing things, and
think twice about what will happen.

#### Environments

The name you select for terraform remote indicates which live cluster
you will modify. You should test all infrastructure changes on
`looprecur/gt_development` and only later modify `looprecur/gt_production`
if everything is good.

### Goodtimes machine

To deploy new code from
[looprecur/goodtimes](https://github.com/loop-recur/goodtimes) you
need to build it into a new machine image for the ec2 cluster. The
build is controlled by a Packer definition at `packer/goodtimes.json`.

1. Pull down the chef recipe submodules: `git pull --recurse-submodules`
2. Build the AMI from within the packer directory. `packer build
-var 'aws_access_key=foo' -var 'aws_secret_key=bar' goodtimes.json`
3. Update `terraform.tfvars` with the name of the AMI you built.

For more detailed docs about building AMIs see the readme for the
[microservice-template](https://github.com/begriffs/microservice-template)
