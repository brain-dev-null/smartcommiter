# smartcommiter

Use this script to generate a [Bitbucket Smart Commit](https://support.atlassian.com/bitbucket-cloud/docs/use-smart-commits/) referencing a Jira Issue.

## Requirements

- [git](https://git-scm.com/)
- [fzf](https://github.com/junegunn/fzf)
- [jq](https://jqlang.github.io/jq/)

## Configuration

In order to load your Jira Issues, smartcommiter needs these environment variables to be set:

+ `DOMAIN`: The domain of your Jira Cloud instance like `evilcorp.atlassian.net`
+ `EMAIL`: Your Jira account's email address
+ `TOKEN`: An API Token for your Jira Account (Generate one [here](https://id.atlassian.com/manage-profile/security/api-tokens))

The script currently assumes these values to be present in a file at `$HOME/.jiraenv`.
If you set these environment variables in any other way, you should remove the `source` from the script.

## Run smartcommiter

You may want to place the script in a known directory, e.g. `$HOME/scripts`, and add an alias to your `bashrc`, `zshrc`, ... like `alias smartc=$HOME/scripts/smartcommiter.sh`

Then you can use `smartc` instead of `git commit` whenever you want to create a Smart Commit.

When running smartcommiter, you will be prompted to select a Jira issue via fzf.
Then, it will run `git commit` with a commit message pre-populated with the selected issues's id. 
