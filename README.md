*This project is very not done yet. The README simply describes an idea for the future API.*

## Usage

List all hooks, installed in the project

    $ githooks list

    # result:

    post-merge/rails-migrations :: AndrewRadev/githooks-storage/rails-migrations
      Runs `rake db:migrate` if any new migrations were added.

    post-merge/ruby-bundler :: AndrewRadev/githooks-storage/ruby-bundler
      Runs `bundle install` if Gemfile.lock was changed.

    post-checkout/rebuild-ctags :: AndrewRadev/githooks-storage/rebuild-ctags
      Rebuilds project tags upon changing branches.

Install a new hook

    $ githooks install username/reponame/path/to/hook

Run a hook manually (it would probably need some environment variables to work):

    $ githooks run post-merge/rails-migrations

## Internals

Each hook is written to the relevant `.git/hooks/*` file. For example, with the abovementioned `post-merge/ruby-bundler` and `post-merge/rails-migrations` would result in the `.git/hooks/post-merge` file looking like this:

    ## Start of githooks scripts

    githooks run post-merge/ruby-bundler
    githooks run post-merge/rails-migrations

    ## End of githooks scripts
