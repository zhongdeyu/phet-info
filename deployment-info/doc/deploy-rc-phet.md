**Simulation Deployment Guidelines**
=====================================

Variables to replace in the instructions below:

```
$SIM = the name of your sim's repo
$VERSION = the identifier of your sim, eg "1.0.0-rc.2"
$USERNAME = your username on spot, figaro, and phet-server
$HOME = your home directory
```

**Build process configuration**

Before building or deploying a simulation, familiarize yourself with configuration options for PhET's build process.

Your default build configuration is specified in `$HOME/.phet/build-local.json`. Describing or identifying the entries in `build-local.json` is beyond the scope of this document; ask a PhET developer for help in setting up this file. At a minimum you will need `devUsername` and `buildServerAuthorizationCode`.

Run `grunt --help` for a list of build tasks and their options. Values specified on the `grunt` command line typically override values specified in `build-local.json`.

(Optional) Create an ssh key if you'd like to avoid entering your password for dev-related build tasks:

- create an rsa key in ~/.ssh (run "ssh-keygen -t rsa" to generate a key if you don't already have one).
- add an entry for spot in ~/.ssh/config like so (you may need to create this file):

```
Host spot
   HostName spot.colorado.edu
   User [identikey]
   Port 22
   IdentityFile ~/.ssh/id_rsa
```
- On spot, you'll need to add your public key (found in ~/.ssh/id_rsa.pub) to a file ~/.ssh/authorized_keys
**Steps to publish a 'rc' (release candidate) version**

The latest fully-tested SHAs (use these if appropriate): https://github.com/phetsims/atomic-interactions/blob/1.0/dependencies.json

The latest SHAs under testing (use these if appropriate): https://github.com/phetsims/forces-and-motion-basics/blob/2.1/dependencies.json

RC versions are deployed to spot.colorado.edu at http://www.colorado.edu/physics/phet/dev/html/

If this is the first release candidate on a release branch:

- [ ] Create a release branch and switch to it, e.g.: `git checkout -b 1.0`. The branches are named using major and minor version numbers, eg "1.0".

If this is not the first release candidate on a release branch:

- [ ] Check out the release branch, e.g.: `git checkout 1.0`
- [ ] Check out the correct shas for dependencies: `grunt checkout-shas`
- [ ] If you've branched (for the purposes of patching) any of the dependency repositories since the last rc version was
published, you'll need to explicitly checkout those branches. For example, if you branched vegas for the 1.1 release of
graphing-lines, do `cd ../vegas ; git checkout graphing-lines-1.1`.

After setting up the release-candidate branches, continue the build and deploy:

- [ ] Update the version identifier in package.json, commit and push. The version should be something like "1.0.0-rc.2".
- [ ] Run the build process: `grunt`
- [ ] Deploy to spot using the build server: `grunt deploy-rc`
- [ ] Test the deployed RC on spot to make sure it is working properly. If the build server is having issues,
you can ssh into phet and look at the build-server logs with: `sudo journalctl -fu build-server`. Launch the sim and make sure it is working correctly.
- [ ] After following these steps, please update the "latest SHAs under testing" above, if appropriate.
- [ ] Check out master for dependencies: `grunt checkout-master` (optional)