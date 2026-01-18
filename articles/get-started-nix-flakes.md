---
title: Getting started with Nix (and flakes)
author: Noon van der Silk
date: 2026-01-18
next: false
prev:
  text: Why should my project adopt Nix?
  link: /articles/why-should-my-project-adopt-nix
---

# Getting started with Nix (and flakes)

If you want to work with Nix in the modern age, you're going to need to do
slightly more then the website suggests; we need to enable a few extra options
to get the most convenient experience

So, let's go through it.

#### 1. Download Nix

This is pretty straightforward; just follow the relevant section for your OS
from the Nix website: [Download Nix](https://nixos.org/download/).


#### 2. Enable flakes and other features in `nix.conf`

You can create/edit `~/.config/nix/nix.conf` and add the following
line:

::: code-group

``` txt [nix.conf]
experimental-features = nix-command flakes recursive-nix ca-derivations
```

This enables flakes, the `nix` command, and a few other features that are
handy.

:::


#### 3. Test it

You can check that the _nix-command_ feature is working by trying
to run any program on nixpkgs; for example, jq:

``` sh
nix run nixpkgs#jq -- --help
```

You can test that the _flakes_ feature is active by loading a development
shell for a simple JavaScript project, from our templates:

``` sh
nix develop github:InvariantClub/nix-js-simple
> node
```


#### 4. _optional_ &mdash; Use [direnv](https://direnv.net)

While this is not strictly necessary; it's something I use all the time, and
has wildly improved and simplified my Nix life.

[direnv](https://direnv.net/) is a program that reads `.envrc` files and
follows instructions there-in. You will notice in all our [nix
templates](/templates/) we provide `.envrc` with the simple statement:

``` txt [.envrc]
use flake
```

This means that whenever you `cd` into the directory, the `nix develop` shell
will be loaded automatically. This is _extremely_ convenient!

Steps:

1. Install [direnv](https://direnv.net/)
2. Install [nix-direnv](https://github.com/nix-community/nix-direnv)


#### 5.Start hacking!

You're all set! You've now got a perfect Nix setup for exploring and extending
one of our [templates](/templates/)!
