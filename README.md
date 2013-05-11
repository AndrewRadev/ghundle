*This project is not completely done yet. The README describes ideas for the future API.*

## Usage

Fetch a hook from the local filesystem (see below for directory format):

    $ githooks fetch ~/projects/hooks/ctags
    >> Copying hook to ~/.githooks/post-merge/ctags...

Fetch a hook from a remote github repo (NOT DONE):

    $ githooks fetch github.com/AndrewRadev/my-magical-hooks/ctags
    >> Copying hook to ~/.githooks/post-merge/ctags...

List all hooks, installed in the project (NOT DONE):

    $ githooks list

    post-merge/rails-migrations :: github.com/AndrewRadev/githooks-storage/rails-migrations
      Runs `rake db:migrate` if any new migrations were added.

    post-merge/ruby-bundler :: github.com/AndrewRadev/githooks-storage/ruby-bundler
      Runs `bundle install` if Gemfile.lock was changed.

    <hook-type>/<hook-name> :: <remote-source>
      <description>

Install a new hook in the project from the githooks storage in `~/.githooks`
(this will eventually automatically fetch & install whenever possible):

    $ githooks install post-merge/ruby-bundler
    $ githooks install <hook-type>/<hook-name>

Run a hook manually (it would need some arguments to work, see `man githooks`):

    $ githooks run post-merge/rails-migrations <args>

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
type: <hook-type>
description: <description of the hook's effect>
```

Fetching from a remote repo is still not implemented.

Each hook is written to the relevant `.git/hooks/*` file. For example, with the
abovementioned `post-merge/ruby-bundler` and `post-merge/rails-migrations`
would result in the `.git/hooks/post-merge` file looking like this:

    ## Start of githooks scripts
    githooks run post-merge/ruby-bundler
    githooks run post-merge/rails-migrations
    ## End of githooks scripts
