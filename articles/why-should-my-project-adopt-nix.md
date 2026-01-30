---
title: Why should my project adopt Nix?
author: Noon van der Silk
date: 2026-01-07
next:
  text: Getting started with Nix (and Flakes)
  link: /articles/get-started-nix-flakes
prev: false
---

<ArticleHeader
  title="Why should my project adopt Nix?"
  author="Noon van der Silk"
  image="noon"
/>

Perhaps someone has submitted a PR adding a `flake.nix` to your repo. Perhaps
you have been reading about [Nix](https://nixos.org/); talking to your
friends, watching your colleagues, or even overheard a passer-by on the street
mention Nix. In any case, you are curious and inspired: What is Nix? Why might
you want to adopt it? Especially in a project that is otherwise seemingly
"working fine"?

Let's take a look, at a high level, and from the perspective of someone who
has not used Nix before, why you might consider it, and potential drawbacks.
But first, let's address the most natural question: _Why add yet another
package manager?_


## Is Nix just Yet Another Package Manager?

In some ways, yes. But, unlike your language-level package managers, Nix is
effectively a system-wide package manager. That is, it lets you _install_ the
language-level package managers you need! And in particular, in most cases, it
actually reads all the information it needs about compiling your project, from
the package manager you already use in your language of choice.

For example, in the Python ecosystem it is becoming popular to use
[uv](https://docs.astral.sh/uv/); a Nix-based Python project would use
[uv2nix](https://pyproject-nix.github.io/uv2nix/) to read the uv-specified
dependencies and load them into your environment.

What differentiates Nix from your typical (language-based) package managers is
that it can also install things _outside_ of that language; i.e. other
dependencies you may have; data-transformation tools, database clients,
websocket clients, etc. At this point, almost any package you can
dream of is available on what we called "[nixpkgs](https://github.com/NixOS/nixpkgs/)";
you can search for what you use here:
[search.nixos.org](https://search.nixos.org/packages). Feel free to try it out
right now; there's an extremely high chance your tool of choice is there!


::: info :eyes: Observation

Nix let's you declare and install _all_ of your projects dependencies, instead
of just the ones related to your language. This works across all[^all]
systems.

<br />

It is the last package manager you will ever need!

:::

With that out of the way, let's get into the benefits.


## Consistent, isolated development environments

Depending on what ecosystem's you've been working in; you might now have a
follow-up question: How do you get isolation of _system_-level dependencies? The
answer is, in essence, through the [Nix
store](https://nix.dev/manual/nix/2.24/store/). All the dependencies you
install end up in the store; organised by a hash of their contents.

This means that you get _re-use_ across different projects, if they depend on
the same version of certain packages! Contrast this with npm or Python, where
each virtual environment maintains it's own version of potentially the same
library.

::: info :eyes: Observation

Nix isolates dependencies in it's own store.

:::

The essence of the store, and in many ways Nix itself, is the idea of storing
packages in a folder named after the hash of the contents. This has a
surprising number of benefits; namely in re-use and caching.

In day to day use, the interaction and engagement with these development
environments can be completely seamless: you `cd` into the directory of your
project, and immediately all your tools are present and ready. You `cd` out;
and they are gone.

This is achieved through a combination of [Nix
flakes](https://nixos.wiki/wiki/flakes),
[devShells](https://nix.dev/tutorials/first-steps/declarative-shell.html) and
[direnv](https://direnv.net/).

An example of this:

``` sh
> node
zsh: command not found: node

> cd frontend
direnv: loading ~/dev/.../frontend/.envrc
direnv: using flake
direnv: nix-direnv: Using cached dev shell

> node
Welcome to Node.js v18.18.2.
Type ".help" for more information.
>

> cd ..
direnv: unloading
```

Note that merely entering into the directory gets me the tools that I need.
This setup is compatible with all IDEs.


## Reproducibility and caching (less compute! <span>❤️ 🌍</span>)

Because of Nix's hashing approach; it is a moderately simple matter to
determine if it needs to do work rebuilding, or if it can just use some
previously-built artifact. Nix does this automatically by simply computing the
hash of the entire dependency tree, and any point which has the same hash can
be re-used.

This can be hugely efficient.

Combined with using a Nix cache (either your own, or a hosted one, on the
popular service [cachix](https://www.cachix.org/)) you can wildly reduce
the amount of rebuilds that you do between peers.

::: info :eyes: Observation

Nix can share build resources by using content-based hashing; this
can mean faster and more reliable builds, and less compute resources required!
:::

## Provision of entrypoints, and other scripts

Imagine you'd like to provide a way for someone to run your project. Or, you'd
like to have some helper scripts to working with your repository. With an
appropriately-specified `flake.nix` file all of this comes for free.

Consider an example; the [HiGHS](https://github.com/ERGO-Code/HiGHS) linear
optimisation program. You can run it _directly_ from GitHub with the following
command:

``` sh
nix run github:ERGO-Code/HiGHS/v1.12.0 -- --version
```

This feature is extremely powerful. Note that above we have specified a
specific branch; so indeed you can specific any revision you like, and hence
very easily share different versions of your executables with users.

In general the power you get is to fully specify any binaries in the resulting
environment, and indeed even environment variables themselves, and in this way
you can define a consistent set of scripts to be used within your team.


## Simplified CI

Following immediately from above, with everything declared in appropriate nix
files, there is reduced need for complicated `ci` files: most of the logic can
live in the appropriate Nix expressions.

This not only keeps sophisticated logic out of vendor-specific CI runners; but
also makes it significantly easier to run CI locally.


## Deployment

We've already seen that you can provide executables directly via the
`flake.nix` file. But, you may also wish to, perhaps, provide your application
in a docker environment.

This turns out to be extremely trivial as well, with Nix's
[dockerTools](https://ryantm.github.io/nixpkgs/builders/images/dockertools/)
functions. It's outside the scope of this article to go into detail; but the
main point is, once you have an ability to construct and execute a binary,
many things follow very simply from there. This can even include capabilities
such as cross-compiling a binary for different architectures; or building
distributable static binaries, etc.


## Huge ecosystem of available packages

There is a _very_ active community bringing almost any program and package you
can dream of into Nix. Joyfully, it is also very simple to make use of them;
here is a collection of examples to run, say, the [QGIS](https://qgis.org/)
Geospatial analysis software; Python at version 3.13; the program
[Inkscape](https://en.wikipedia.org/wiki/Inkscape), and even Python with some
particular packages available.

Here's a selection of examples:

``` sh
nix run nixpkgs#qgis
nix run nixpkgs#python313
nix run nixpkgs#inkscape
```

Python3 + Jupyter + Pandas:

``` sh
> nix-shell -p "python3.withPackages ( ps: [ ps.jupyter ps.pandas ] )"
> jupyter notebook
...
```

Postgres:

``` sh
> nix-shell -p postgresql
> psql --version
psql (PostgreSQL) 17.7
```

Take a look for yourself:
[search.nixos.org](https://search.nixos.org/packages) the package you want is
almost certainly on there.


## Wildly simplified onboarding of new users

By reflecting on the above, you should now be able to see that onboarding new
users in this setup becomes much simpler.

- They can run your app through a simple `nix run ...`,
- They can immediately enter a working development shell with all tools
installed,
- There's no need to follow a list of instructions in the Readme about how to
get setup.

You can even provision full demo/testing environments with
[process-compose](https://github.com/F1bonacc1/process-compose) so that users
can immediately run what might be a complicated app with multiple startup
dependencies and initialisation scripts.


## Conclusion

Naturally, not all these benefits come easily or at not cost. Writing `.nix`
files can take a little work; and occasionally you will need to do some
hacking to get your exact case to work. But what I can promise is that the
investment in Nix pays off: you can always get things working eventually; and
the benefits are worth the effort.

If you're inspired to try, a good place to start would be our [Nix
templates](/templates/)!

[^all]: Here I'm referring to Linux and MacOS systems. This includes Windows
as well, when you build within WSL.
