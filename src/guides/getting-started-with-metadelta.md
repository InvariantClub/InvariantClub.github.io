---
previewImage: /images/blog/github-action.webp
title: "Getting started with Metadelta &mdash; Setting up a GitHub action"
authors:
 - Noon van der Silk
date: 2024-02-24
tags:
  - github
  - metadelta
summary: |
  If you've had a look at the demos and your keen to see how Metadelta looks
  with your own database, probably the easiest way is just to set up the
  GitHub action integration! Let's go over how to implement this step-by-step.
---

## Motivation

Metadelta's main function is to compute _differences_ between different Hasura
versions. The most natural place to compute such a difference is, if you use
GitHub, during a Pull Request (PR): You compare the permission changes that a
PR seeks to introduce.

This, then, is what we will implement in what follows: We will set up an
action that comments with a link to the Metadelta UI, showing the diff of that
particular PR. A new link will be provided each time the PR branch is updated.

## The setup

The essential requirement is that you have in your repo somewhere a `hasura`
folder with something like the following structure:

```shell
./hasura/metadata
  - actions.graphql
  - actions.yaml
  ...
  databases/
  ...
  - version.yaml
```

If you'd like to follow along with our repo instead of your own, you can start
with our [demo-database](https://github.com/InvariantClub/demo-database) which
has everything you need.

## The details

So, the set up is pretty straightfoward. If you just want to view the finished
[GitHub workflow
file](https://github.com/InvariantClub/demo-database/blob/main/.github/workflows/compute-permission-diff.yaml)
you can; but otherwise, we'll go through all the steps.

**The header**

We start with a simple workflow that runs on pull requests. We require two
kinds of permissions: we need to write `contents` as we're going to upload an
artifact later, and we want to write to the pull-request to comment on it.

```yaml
name: Compute permission diff on PR

on:
  pull_request:


jobs:
  compute-diff:
    permissions:
      contents: write
      pull-requests: write
    runs-on: ubuntu-latest
    steps:
```

The first steps:

**1. Check out the two versions of the code**

Pretty simple; we just check out the respective versions to an `/old` and
`/new` path.

```yaml
      - name: Checkout the PR as the 'new' source
        uses: actions/checkout@v4
        with:
          path: ./new
          ref: ${{ github.event.pull_request.head.sha }}

      - name: Checkout `main` as the 'old' source
        uses: actions/checkout@v4
        with:
          path: ./old
          ref: main
```

**2. Run Metadelta to produce a `diff.json` file**

The juicy part; we run Metadelta, from <a
href="https://github.com/InvariantClub/metadelta/pkgs/container/metadelta">our
docker image</a>, referring to the `./old` and `./new` paths we checked out
earlier.

A few detalis:

- We set some labels so that it displays nicely in the UI and is clear what
commits it is referencing,
- We compute a small check to test whether we _actually_ found a difference,
  In subsequent steps this will be used to check if we upload an artifact and
  post a comment on GitHub.

```yaml
      - name: Run metadelta comparing old and new
        id: metadelta
        run: |
          docker run -i \
            -v $PWD:/work \
            ghcr.io/invariantclub/metadelta \
            diff \
            -o /work/old/hasura/metadata/ \
            --oldLabel 'main' \
            -n /work/new/hasura/metadata/ \
            --newLabel '${{ github.event.pull_request.head.label }} @ ${{ github.event.pull_request.head.sha }}' \
            --newLink '${{ github.event.pull_request.html_url }}' \
            >diff.json || true
          echo "anythingDifferent=$(test -s diff.json || echo 'true')" >> "$GITHUB_OUTPUT"
```

**3. Upload the `diff.json` file as a GitHub artifact**

Pretty straightforward: We are going to upload it so that it can be downloaded
by the UI later on. The only thing to note is that we only do the upload if
the previous step found a difference. In reality, it's probably far more
common for PRs to _not_ be changing permissions; so it's important to skip any
extra work in those cases.


```yaml
      - name: Uploading the diff as an artifact
        uses: actions/upload-artifact@v4
        id: artifact
        if:
          # Only run if we detected changes.
          ${{ steps.metadelta.outputs.anythingDifferent != 'true' }}
        with:
          name: metadelta-diff
          path: diff.json
          retention-days: 5
```

**4. Comment on the PR with a link**

This is the final step. The Metadelta UI can load a GitHub artifact completely
client-side, (supposing you have configured the UI, in the [settings tab](https://metadelta.invariant.club/settings), with a GitHub access
token, which is, unfortunately, [a requirement for querying GitHub artifacts,
even public ones](https://docs.github.com/en/rest/actions/artifacts?apiVersion=2022-11-28#download-an-artifact)); so all we need to do is prepare an appropriate URL, and post
that as a comment on the PR.

As the above step was run conditionally, so too we want to run this one on the
condition that the previous step was completed.

```yaml
      - name: Comment with Metadelta link
        uses: peter-evans/create-or-update-comment@v4.0.0
        if:
          # Only run if we uploaded an artifact
          ${{ steps.artifact.outcome == 'success' }}
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          issue-number: ${{ github.event.pull_request.number }}
          body: |
            [View the permission diff in Metadelta :eyes:](https://metadelta.invariant.club/explorer?githubArtifact=${{ steps.artifact.outputs.artifact-id }}/${{ github.repository_owner }}/${{ github.event.repository.name }})

            This is was triggered from GitHub Actions [run ${{ github.run_number }}](https://github.com/${{ github.repository_owner }}/${{ github.event.repository.name }}/actions/runs/${{ github.run_id }}/).
```


## That's it!

Putting that all together in [a single workflow file, perhaps called
`compute-permission-diff.yaml`](https://github.com/InvariantClub/demo-database/blob/main/.github/workflows/compute-permission-diff.yaml)
does the job!

You are now computing diffs on all PRs, and you will be notified when the
permissions have changed in any way, and if so, you will receive a link to
review those diffs in the Metadelta UI!

Hopefully this has been useful :)
