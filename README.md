# powershell-stuff

## Import the module during your profile

Find where modules are located
```
 $env:PSModulePath -split ';'
 ```

 Pick one of these, I typically use the OneDrive one.  Put this repo in there.

 Add this to your profile
 ```
 Import-Module Tools
 ```

Name of the module folder can be anything, but that's what gets imported.
