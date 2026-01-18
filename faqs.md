---
outline: deep
prev: false
next: false
---

# FAQs

## Q: Why not just use docker?

While docker certainly plays in the space of "consistent and isolated
environments"; it does not spark a great deal of joy when used for
_development_ environments; the essential reason being: rebuilding images is
very slow.

While one _can_ do sophisticated things with layered images; in almost every
case it will be more complicated and worse than the equivalent Nix setup.

This is not to say that Nix and docker are incompatible; indeed, it is very
typical to provide "user-facing" docker images built directly from your Nix
project!


## Q: Does Nix replace my existing build tools?

No.

The main reason is that your language-specific tools are typically more
efficient, and maintain their own caches to allow for incremental building.
While some ecosystems are better than others; typically during development you
do don't want to be invoking `nix build ...`-style statements.

The main point is that the `nix build` produces a consistent output (i.e.
distributable executable) across all systems _and_ aligns with the output
of local development; without Nix, this simple property is very hard to
achieve!


## Q: Where can I find out what packages are available?

Here: [search.nixos.org](https://search.nixos.org/packages)

This is the "official" list of community-maintained packages; but part of the
beauty of the Nix ecosystem is that it is decentralised; you can install
packages from anywhere.
