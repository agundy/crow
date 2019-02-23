# Crow

Crow likes to collect remote repositories and make them local. For now it only
works with Github but will use the Github API to login, look for your
repositories and place them in your local file system. Example usage:

```
export GITHUB_ACCESS_TOKEN=<ACCESS_TOKEN>
crow backup
```

This will clone all repositories owned by you in the local directory under
`github/<Your Login>/repo_name.git`. Note these are bare repositories.

## Github Personal Access Token

1. Go to [https://github.com/settings/tokens](https://github.com/settings/tokens)
and click "Generate new token"
2. Give it full access to repositories
3. Copy password and save somewhere for later
