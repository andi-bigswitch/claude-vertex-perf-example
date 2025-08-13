# Claude Code Vertex Performance Example

This repo demonstrates an issue with Claude Code and Google Vertex.

In our setup, Claude Code spends considerable time trying to connect to 169.254.169.254:80 (Google's metadata server).

This is avoided if the Google SDK is logged in via **both**

1. login with `gcloud auth application-default login` **and**
2. lgoin with `gcloud auth login` **and**
3. set project with `gcloud config set project`.

The first login is necessary - without it claude code errors out. However, with just the first login, Claude Code is slow (~16 sec for a simple command).

After logging in with both and setting the project, claude code is significantly faster.

## Instructions


```
make build run
```

