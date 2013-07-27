# Ghundle

A package manager for git hooks.

*Note: This project is not completely "ready" yet and the API is still in flux.*

## Usage

Fetch a hook from the local filesystem, useful for testing (see below for
directory format):

    $ ghundle fetch ~/projects/hooks/ctags
    >> Copying hook to ~/.ghundle/ctags...

Fetch a hook from a remote github repo:

    $ ghundle fetch github.com/AndrewRadev/my-hooks-repo/ctags
    >> Copying hook to ~/.ghundle/ctags...

List all available hooks:

    $ ghundle list-all

    ctags
      - types:       post-checkout
      - description: Regenerates a project's tag files whenever a `git checkout` is run.

    ruby-bundler
      - types:       post-merge, post-rewrite
      - description: Runs a `bundle install` on every merge (this includes pulls).

    <hook-name>
      - types:       <type1>, <type2>, ...
      - description: <description>

List all hooks, installed in the project:

    $ ghundle list-installed

    ctags
      - types:       post-checkout
      - description: Regenerates a project's tag files whenever a `git checkout` is run.

Install a new hook in the project from the ghundle storage in `~/.ghundle`
(this automatically fetches if given a fetch-compatible url):

    $ ghundle install ruby-bundler
    $ ghundle install <hook-name>

    $ ghundle install github.com/AndrewRadev/my-hooks-repo/ctags
    $ ghundle install <anything that `ghundle fetch` accepts>

Uninstall a hook:

    $ ghundle uninstall ruby-bundler
    $ ghundle uninstall <hook-name>

Run a hook manually (it would need some arguments to work, see `man githooks`):

    $ ghundle run rails-migrations <args>

## Internals

The format of the source of a ghundle hook is a directory with the following
structure:

    hook-name/
      meta.yml
      run

After running `ghundle fetch hook-name`, the `run` file and the metadata in
`meta.yml` will be processed and stored in `~/.ghundle`. The `run` file is the
actual script to run and it can be written any way you like. The `meta.yml`
file contains metadata and should have the form:

``` yaml
---
types: [<hook-type1>, <hook-type2>, ...]
version: <major>.<minor>.<patch>
description: <description of the hook's effect>
```

Each hook is written to the relevant `.git/hooks/*` file. For example, with the
abovementioned `ruby-bundler` and `rails-migrations`
would result in the `.git/hooks/post-merge` file looking like this:

    ## Start of ghundle scripts
    ghundle run ruby-bundler $*
    ghundle run rails-migrations $*
    ## End of ghundle scripts

## TODO

- Don't fetch only `meta.yml` and `run`, fetch whole directories. That way more complicated hooks can be built.
- `ghundle skeleton` command for generating hook and repo skeletons.
- Better CLI integration with good help for the different commands, possibly manpages
- Upgrade paths for hooks. Currently, they have versions, but these are ignored.
- Hook repos, enabling (for example) searching for hooks.
