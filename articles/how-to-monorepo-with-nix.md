---
title: How to monorepo with Nix
author: Noon van der Silk
date: 2026-02-18
prev:
  text: Packaging 128 languages with Nix
  link: /articles/packaging-128-programming-languages-with-nix
next: false
---

<ArticleHeader
  title="How to monorepo with Nix"
  author="Noon van der Silk"
  image="noon"
/>

## You are standing in a monorepo ...

``` txt
You've read all the articles. You've discussed it at length and from all
angles. You've considered all the tradeoffs. You've created the repo and
you're ready to hack ...

> look around

You feel comfortable surrounded by all the code you will need to achieve
your dream. To the left you see a cosy JavaScript project. To your right
you see one or more backend codebases. Directly ahead of you are various
docker files ready to run all the services you care about.

You are, of course, standing in a monorepo.

What do you want to do next?

> ...
```

Perhaps you would like to ...

- _Run_ something?
- _Test_ something?
- _Demo_ something?
- _Build_ something?
- _Fix_ something?
- _Break_ something?!

Whichever it is, you almost certainly need all of the dependencies of the
projects installed and ready to go; at the right version for each project;
potentially even with conflicting dependencies, depending on how the lifetime
of the particular sub project.

So, with excitement in our body and optimism in our hearts, let's get into it.

## Nixing the monorepo

### The setup

Your particular codebase may differ in languages; but for the purposes of
exploring the idea, let's go with a concrete setup:

1. A vuejs-based JavaScript frontend,
3. A python project for some data analysis,
4. A rust backend,
5. A docker-compose file for some database services.

The scheme will work for however rich an environment you choose to make.

### Choices

Given we've agreed to use Nix, we know we'll be following a
[flake.nix-style](/articles/get-started-nix-flakes.html)
setup.

But, how should we structure it? It might at first seem obvious to just go
with a single big `flake.nix` file; but we should at least look at the other
options:

| | :one: Single flake.nix  | :two: Multiple flake.nix's |
| - | - | - |
| :shell: **Single devShell** | Simple?  | ??? |
| :shell: :shell: **Multiple devShells** | Confusing? | Natural? |

Let's explore the pros and cons a little bit.

1. :one: :shell: &mdash; **Single flake.nix / Single devShell**

    This is the most natural idea; especially if you are starting from not
    having Nix at all. In our example world, we would add nodejs, ruby,
    python, rust, ... all at once.

    _Pros:_
      - Simple
      - Clear
      - Easily run anything at any time
      - Shared configuration is easy
      - Access to any tool at any time
      - Interdependencies easy to express

    _Cons:_
      - Potential overhead if you never touch certain areas
      - Potential for conflict between changes of disconnected areas
      - Harder to isolate review requirements


2. :two: :shell: :shell: &mdash; **Multiple flake.nix's / Multiple devShells**

    At the other end of the spectrum, if you consider a monorepo as "merely" a
    place where you put all your (perhaps indepenent) projects, then this idea
    is very natural: Just consider each project independently; and define the
    necessary dependencies.

    In our setup, we have maybe ~5 "base" folders; so we could have one
    `flake.nix` for each.

    _Pros_:
      - Simple
      - Best possible isolation: fast hacking, no overlap problems, etc
      - "Reversible" - it could look a little like you copy-and-pasted all your
      independent repos in one big one. Easy to undo.

    _Cons_:
      - Lose ability to easily interact with other components
      - Potentially lots of redundancy


3. :two: :shell: &mdash; **Multiple flake.nix's / Single devShell**

    While one _could_ do this, I'm just going to immediately rule it out as
    not particularly interesting because we can basically interpret it as the
    same idea as above, but arbitrarily definine one extra top-level flake.nix
    and a mega devShell.


4. :one: :shell: :shell:  &mdash; **Single flake.nix / Multiple devShells**

    ::: info Spoiler
    I'm going to argue for this one. But note that the first two options above
    are very legitimate; and there's nothing really wrong with picking them.
    This one just lets us explore something new, so it's why we will spend
    most of our time here!
    :::

    The idea here would be to define a single top-level `flake.nix`, but
    design it in a way for maximum seperation, while allowing re-use. This
    means potentially a couple of devShells, some conveniences to make sure
    you always have what you need; but enough isolation to avoid conflicts
    with changes that you don't care about at the present moment.

    _Pros_:
      - Isolation
      - Convenience
      - Interdependence
      - Freedom to hack where you need

    _Cons_:
      - Interdependence
      - Not breaking it becomes very important
      - _Can_ incur overhead

## What it looks like

If you want to jump straight to the code:
[InvariantClub/monorepo-with-nix](https://github.com/InvariantClub/monorepo-with-nix).

We've got the following rough structure (excluding a bunch of busywork files):

``` txt
.
├── analytics
│   ├── analytics_stuff
│   │   └── main.py
│   ├── nix
│   │   └── outputs.nix
│   ├── pyproject.toml
│   └── uv.lock
├── backend
│   ├── nix
│   │   └── outputs.nix
│   ├── Cargo.toml
│   └── ...
├── flake.nix
├── frontend
│   ├── nix
│   │   └── outputs.nix
│   ├── package.json
│   ├── ...
├── infra
│   ├── docker-compose.yaml
│   └── nix
│       └── outputs.nix
├── nix
│   ├── formatting.nix
│   ├── pkgs.nix
│   └── serve.nix
└── flake.nix
```

The contents is the following:

- `./analytics`: A uv-based Python project.
- `./backend`: A simple Rust webserver backend (via
    [warp](https://docs.rs/warp/latest/warp/)) with a Cargo.toml
- `./frontend`: A vite-based vuejs frontend
- `./infra`: Docker-based setup
- `./nix`: Project-wide Nix derivations

In such sub-folder, we also have a `./nix` folder that gets referrenced in the
single top-level `flake.nix`. This folder defines all the "outputs" for that
specific component; i.e. perhaps a `package` or a `devShell`.

For the first three, the `outputs.nix` is basically exactly what you see in
the `./nix` folder of the respective templates:
[nix-python-uv](https://github.com/InvariantClub/nix-python-uv),
[nix-rust](https://github.com/InvariantClub/nix-rust),
[nix-javascript](https://github.com/InvariantClub/nix-js-simple).

The more interesting situation happens when you want interdependencies between
the projects; so let's see an example.


### The frontend requires the backend

It's pretty natural that the frontend of your app will, at some point, wish to
talk to the backend.

Let's see the options here.

#### Option 0. No backend

Probably your app needs to handle when there's no backend at all. This would
just be jumping into the `frontend` folder and simply running:

``` sh
npm run dev
```

You'll perhaps have some errors


#### Option 1. Backend running _inside_ the devShell

1. `cd backend && cargo run`
2. `cd frontend && npm run dev` ...

This is natural. You run the backend first in some terminal, then you run the
frontend.

This is especially convenient if you're iterating on both at the same time;
but perhaps is a little bit annoying if you _just_ want to iterate on the
frontend. It also becomes quadratically more annoying if you have more than
one service to coordinate. You need to make sure that everything matches up
(with environment variables, etc.)

So, this remains possible here, but is only recommended when specifically
hacking on both services.


#### Option 2. Use [process-compose](https://github.com/F1bonacc1/process-compose)

We've defined
[process-compose](https://github.com/InvariantClub/monorepo-with-nix/blob/main/nix/serve.nix#L26)
setup in `serve.nix` that runs the backand and frontend together.

You can run both like:

``` sh
nix run .#serve
```

Or, _just_ the backend like:

``` sh
nix run .#serve -- run backend
```

One advantage here is that, with proper caching, you won't need to do any
rebuilding if you're not actually hacking on the backend. But perhaps more
importantly, it's typical that any given setup requires _many_ backend
services: a database, a queue, etc, etc. These can all be specified in the
process-compose style, to make for a very convenient way of spinning up what's
necessary.


#### Option 3. Use docker compose

A more typical setup would have you use a `docker-compose.yaml` file that
perhaps builds docker images from the source directly; or otherwise obtains
images for various services and spins up all (or part) of the environment.

While this can be effective; unless done in a very careful way, it's very easy
for rebuilds to take a very long time; and depending on your world, you can
even forget to rebuild and face annoyances about not using the right version
of the image, etc.

Nevertheless, it can still be very useful to integrate with this style; if
only because it allows for gradual adoption.

For that reason, we provide a docker compose configuration file; but more
interestingly, in `infra/outputs.nix` we provide Nix derivations that
_actually_ build docker images!

The image for the rust backend is so concise that we can repeat it entirely
here:

``` nix
# ./infra/nix/outputs.nix
...
packages.backend-image = pkgs.dockerTools.streamLayeredImage {
  name = "monorepo-with-nix-${self'.packages.backend.pname}";
  tag = "latest";
  created = "now";
  contents = [ self'.packages.backend ];
  config = {
    Entrypoint = [ "backend" ];
  };
};
...
```

Then, you can build the image with:

``` sh
nix build .#backend-image && ./result | docker load
```

In any setting, it's very useful to have a docker image for whatever you wish
to deploy; and here, we use these images directly in the `docker-compose.yaml`
file:

``` yaml
# docker-compose.yaml
services:
  backend:
    image: monorepo-with-nix-backend
    ports:
      - 3030:3030
...
```

and that's it! You can interact with this in the normal way you would any
docker service. But do not forget to rebuild the image on any code change!
Note that the rebuild requirement means this isn't as joyful as the other
three options, but may still be useful to have around to support certain
use-cases.


### Interdepdenencies

The main benefit of a unified Nix representation, is how easy it is to express
interdependencies. In fact, if the baseline is that your project is already
nixified as a flake; it's actually very easy to do. The only downside is, as
is often the case, things become annoying when you're doing development on all
the different places at once.

Here, this is immediately addressed; because all the definitions are
available, and anything that needs to be changed or accessed can be.


## Conclusion

Here we've presented a concrete example of how to set up a "monorepo" style
environment using Nix: [InvariantClub/monorepo-with-nix](https://github.com/InvariantClub/monorepo-with-nix).

We've shown a couple of different other options; and that all have interesting
options and drawbacks.

Hopefully this gives you some food for thought!

<ReachOut />
