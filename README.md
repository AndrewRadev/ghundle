*This project is not completely done yet and the API is still in flux.*

## Usage

Fetch a hook from the local filesystem, useful for testing (see below for
directory format):

    $ githooks fetch ~/projects/hooks/ctags
    >> Copying hook to ~/.githooks/ctags...

Fetch a hook from a remote github repo:

    $ githooks fetch github.com/AndrewRadev/my-hooks-repo/ctags
    >> Copying hook to ~/.githooks/ctags...

List all available hooks:

    $ githooks list-all

    ctags
      - types:       post-checkout
      - description: Regenerates a project's tag files whenever a `git checkout` is run.

    ruby-bundler
      - types:       post-merge, post-rewrite
      - description: Runs a `bundle install` on every merge (this includes pulls).

    <hook-name>
      - type:        <type>
      - description: <description>

List all hooks, installed in the project:

    $ githooks list-installed

    ctags
      - types:       post-checkout
      - description: Regenerates a project's tag files whenever a `git checkout` is run.

Install a new hook in the project from the githooks storage in `~/.githooks`
(this automatically fetches if given a fetch-compatible url):

    $ githooks install ruby-bundler
    $ githooks install <hook-name>

    $ githooks install github.com/AndrewRadev/my-hooks-repo/ctags
    $ githooks install <anything that `githooks fetch` accepts>

Uninstall a hook:

    $ githooks uninstall ruby-bundler
    $ githooks uninstall <hook-name>

Run a hook manually (it would need some arguments to work, see `man githooks`):

    $ githooks run rails-migrations <args>

## Internals

The format of the source of a githooks hook is a directory with the following
structure:

    hook-name/
      meta.yml
      run

After running `githooks fetch hook-name`, the `run` file and the metadata in
`meta.yml` will be processed and stored in `~/.githooks`. The `run` file is the
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

    ## Start of githooks scripts
    githooks run ruby-bundler
    githooks run rails-migrations
    ## End of githooks scripts
