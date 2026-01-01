# powershell-stuff

## Powershell utilities

### env
```env``` prints the environment variables, similar to ```set``` in CMD or env in BASH

### Get-PortProcess
Prints what processes have a port open, good for troubleshooting.  Took the idea from https://github.com/pranshuparmar/witr

```
Get-PortProcess 8888
```

### wget
Says it all, to do this in PS is too much typing :O

```
wget https://www.google.com
```

### build
This is my container builder using Podman on my Windows machine.   
- Check that podman machine is started (start if not)
- Look for ```IMAGE``` file for name of container image, if not, needs to be parameter -ImageName
- Look for ```VERSION``` file for container tag, required
- ```-push``` to push to remote repo, optional

```
build ghcr.io/jfmatth/hugobuilder -push
```
Would build it via Podman and push to the Github repo's package


## Installing into PowerShell modules folder

Find where modules are located
```
$env:PSModulePath -split ';'
```
Pick one of these, I typically use the OneDrive one.  Put this repo in there.

```
cd \User\john\OneDrive\Documents\PowerShell\Modules
git clone <this repo> Tools
```
This will create a new folder in modules called Tools

Then link to it via a junction (doesn't need admin)

```New-Item -ItemType Junction -Path "C:\Users\john\development\powershell-stuff" -Target "C:\Users\john\OneDrive\Documents\PowerShell\Modules\Tools\"```

Then I can CD into development\powershell-stuff and it modifies the files in the modules\Tools folder

### Add this to your profile

Edit your powershell profile - ```code $profile```

At the end of the file, add

```
Import-Module Tools
```