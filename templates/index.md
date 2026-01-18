---
title: Nix templates
prev: false
next: false
---

<script setup>
const templates =
  [ { title: "Python via uv"
    , repo: "nix-python-uv"
    , details: "A full Python project setup, with dependencies specified and managed via the `uv` package manager."
    , icon: "fa-python"
    , live: true
    }
  , { title: "Python (simple)"
    , repo: "nix-python-simple"
    , details: "A very simple Python development environment, with Nix for package management."
    , icon: "fa-python"
    , live: true
  }
  , { title: "JavaScript (npm)"
    , repo: "nix-js-simple"
    , details: "A devShell with nodejs for use with any npm-based JavaScript environment."
    , icon: "fa-js"
    , live: true
    }
  , { title: "Rust"
    , repo: "nix-rust"
    , details: "A Nix environment for hacking and building binaries."
    , icon: "fa-rust"
    , live: true
    }
  , { title: "Go"
    , repo: "nix-go"
    , details: "Simple golang example to setup an environment to build a binary."
    , icon: "fa-golang"
    , live: true
    }
  , { title: "Julia"
    , repo: "nix-julia"
    , details: "Julia + Pluto environment for scientific computing."
    , live: true
    }
  ];
</script>


# Nix templates

We want you to get up and started with Nix as quickly as possible, in whatever
language you prefer to work in.

For this reason, we have a growing collection of Nix templates.

Let us know if you'd like us to add a specific language/environment!


## Templates

The following collection of templates provide development environment, (in Nix
called `devShells`) for building, running and making interactive changes
to the provided codebases: in other words, just the typical development tasks.

These devShells contain all the tools + libraries needed to get started in
the respective ecosystem.

<Templates :items=templates />
