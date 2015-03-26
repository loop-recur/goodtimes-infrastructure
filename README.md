### Infrastructure-as-code

Using this repo you can spin up a new goodtimes cluster or make
changes to the existing one.

To select the cluster to affect, set the terraform remote.

```bash
# to adjust production
terraform remote -name=looprecur/goodtimes -access-token=xyz
```

We will each use individual access tokens. Ask Joe or Taylor
to get your own.

If you want to run your own isolated cluster use local state
rather than remote state.

#### Environments

The name you select for terraform remote indicates which live cluster
you will modify. Once people are using this project you should test
all infrastructure changes on `looprecur/goodtimes-staging` and
then update `looprecur/goodtimes` if everything is good.
