

# From: https://happygitwithr.com/https-pat
# Check credentials
git config --global user.name "ChuckBV"
git config --global user.email "r.dominica@gmail.com"
git config --global --list

# Create person access token (PAT) to use Git with HTTPS protocol
require(usethis)
usethis::create_github_token()
#    < Be sure to save in a password manager! >

# store the PAT
require(gitcreds)
gitcreds::gitcreds_set()