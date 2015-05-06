To deploy a new version of the app

### First make the AMI

The AMI is a machine image which has the web server binaries, static
assets, nginx config, auxiliary utilities and cron jobs ready to go.
You can use old AMIs to roll back to previous deploys. Generally
building the AMI can take time but deploying it is fast.

So let's make the one for the goodtimes machine.


```bash
git pull --recurse-submodules
cd packer
packer build -var 'aws_access_key=foo' -var 'aws_secret_key=bar' goodtimes.json
```

(For more detailed info about running packer see the readme of the
[microservice-template](https://github.com/begriffs/microservice-template))

Packer build will output an AMI identifier at the end. Remember it.

### Next select a production environment

The name you select for terraform remote indicates which live cluster
you will modify. You should test all infrastructure changes on
`looprecur/gt_development` and only later modify `looprecur/gt_production`
if everything is good.

The state of what-is-deployed-where is shared between everyone at
Loop Recur via Atlas.  We each use individual Atlas access tokens.
Ask Joe or Taylor to get your own then `export ATLAS_TOKEN=xyz`

You can spin up a new goodtimes cluster or make changes to the
existing one. To select the cluster to affect, set the terraform remote.

```bash
# choose deployment environment
terraform remote config -backend=Atlas -backend-config="name=looprecur/gt_development"

# now retrieve microservice-template modules
terraform get

# look at current deployment state
terraform show

# see what terraform will do when you run it for real
terraform plan
```

Remember to check `terraform plan` before doing things, and think
twice about what will happen.

### Pull the trigger

Once you have chosen which environment to deploy into it's time to
make the changes. You determine the parameters of a deploy through
the `terraform.tvfars` file.

1. Start by creating `terraform.tfvars` based on `terraform.tfvars.example`.
2. Fill in the AMI identifier you built for the goodtimes machine.
3. Fill in the username password and name of the database. We use `goodtimes`
   for production and `goodtimes-dev` for staging.
4. Fill out the remaining blank fields.
5. Run `terraform plan` and see if it looks sensible. Green items will be
   created, yellow changed, and red deleted. If you're merely pushing a new
   goodtimes instance you should see the instance be modified as well as some
   DNS entries.
6. Run `terraform apply`
