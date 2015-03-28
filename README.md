### Infrastructure-as-code

Using this repo you can spin up a new goodtimes cluster or make
changes to the existing one.

To select the cluster to affect, set the terraform remote.

```bash
# choose deployment environment
terraform remote -name=looprecur/goodtimes -access-token=xyz

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
`looprecur/goodtimes-dev` and only later modify `looprecur/goodtimes`
if everything is good.
