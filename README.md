# iNZightVIT Windows Installer

## Build release

To build, create a new release pointing to the master branch. This will automatically build the windows installer containing the latest iNZight package version on the repository and upload the exe to the release.

## Build developmental release

- Create a new branch (or use an existing one)
- Specify versions to install 
    - default is lastest, which fetches from https://r.docker.stat.auckland.ac.nz
    - otherwise, is the name of a branch/tag on github, which is installed using `devtools::install_github('package_name/$BRANCH')`


