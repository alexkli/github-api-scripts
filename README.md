Github API Scripts
==================

This is a collection of shell scripts using curl to manage things with the [Github REST API](https://developer.github.com/v3/). Works with Github enterprise installations.

* [Installation](#installation)
* [General usage](#general-usage)
* [Labels](#labels)

Installation
------------

Requirements:

* bash version 4+
* [curl](https://curl.haxx.se)
* [jq](https://stedolan.github.io/jq/)

Clone the repository, download a source zip or copy the shell scripts as needed, and add the folder to your `$PATH`.

General usage
-------------

All scripts require to pass username, personal access token and the API endpoint URL.

Example for public [github.com](https://github.com):

```
<github-script.sh> alexkli:1234567890abcdefgh https://api.github.com/api ...
```

Example for a Github Enterprise installation

```
<github-script.sh> alexkli:1234567890abcdefgh https://git.corp.mycompany.com ...
```

### Token Authentication

You need to create a [personal token](https://github.com/settings/tokens) (public github link). In your Github Enterprise you can find it under _User drop down top right_ > _Settings_ > _Developer Settings_ > _Personal access tokens_.

The scopes to select depend on the particular feature, see below. `repo` is a typical one.

The scripts take the authentication as first argument in the format `user:token`, where `user` is your github user id and `token` is the personal access token.

### API endpoint

For public github.com use:

```
https://api.github.com
```

For a Github Enterprise instance it depends, check the documentation or ask your admins. Make sure it's v3 of the rest API. It might look like this:

```
https://git.mycompany.com/api/v3
```

### Repository

Most scripts require to specify a repository in the form of

```
org/repo
```

For example, for <https://github.com/alexkli/github-api-scripts> it would be `alexkli/github-api-scripts`.

Org can be your personal space on github, or a github organization.

Labels
------

Manage issue labels. Required token scope: `repo`.

### Download labels

Outputs all labels from a repository as one JSON.

```
github-get-labels.sh <user:token> <api-url> <org/repo> > labels.json
```

### Push labels

Creates or updates multiple labels in a repository from a local JSON file (same format as in [Download Labels](#download-labels)). This will not delete any labels.

```
github-push-labels.sh <user:token> <api-url> labels.json <org/repo>
```

### Delete all labels

Deletes all labels in a repository. Useful to remove the default labels if you want to start from scratch. This will show the labels and ask for confirmation before it actually deletes them.

```
github-delete-all-labels.sh <user:token> <api-url> <org/repo>
```

### Delete label(s)

Deletes one or multiple labels in a repository. You have to specify the name of the labels on the command line. Note this will NOT ask for confirmation.

Make sure to use the URL escaped name that you find in the `url` in the label JSON returned from Github, for example, a label with a space such as `help wanted` needs to be referenced as `help%20wanted`.

```
github-delete-labels.sh <user:token> <api-url> <org/repo> <label>...
```

Repos
------

### List all repos of an organization

To get the full repo json for each repo in an organization:

```
github-get-org-repos.sh <user>:<token> <github-api-url> <org> [type]
```

To get just the repo names, use with `jq`:

```
github-get-org-repos.sh <user>:<token> <github-api-url> <org> [type] | jq -r .[].name
```