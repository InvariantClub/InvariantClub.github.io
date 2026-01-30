# invariant.club

> The website at https://invariant.club


## Local development

``` sh
npm run dev
```


## Build

``` sh
nix build .
```


## Serve the built sourcecode

``` sh
nix run .#serve
```


## Deploy

``` sh
./deploy
```


## Todo

- [ ] Check homepage on mobile
- [ ] About/Contact page
- [ ] Default font size


## Article ideas

- "Gateways into Nix"
  - Just use `nix run ...` or `nix profile install` ... to get binaries
     without installing them.
  - NixOS
  - Package projects you like into nixpkgs
  - Submit PRs to projects you use
  - ...

## Template ideas

- [ ] clojure
- [ ] ruby
- [ ] agda
- [ ] lean
- [ ] java
    - https://fzakaria.com/2020/07/20/packaging-a-maven-application-with-nix.html
    - 6 years old!
- [ ] rstudio

## Other ideas

- "Nix oneliners"

  - `rstudioWrapper.override{ packages = with rPackages; [ ggplot2 dplyr xts ]; };`

- nix flake check --override-input ...
