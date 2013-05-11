require 'githooks/command'

module Githooks
  class Install < Command
    def call
      hook = args.first
      validate_hook(hook)

      hook_type, _ = hook.split('/')
      validate_hook_type(hook_type)

      prepare_git_hook(hook_type)
      install_git_hook(hook_type, hook)
    end

    def prepare_git_hook(type)
      validate_git_repo
      validate_hook_type(type)

      git_hook_file = ".git/hooks/#{type}"

      if not File.exists?(git_hook_file)
        File.open(git_hook_file, 'w') do |f|
          f.puts '#! /bin/sh'
          f.puts ''
        end
        File.chmod(0755, git_hook_file)
      end
    end

    def install_git_hook(type, hook)
      git_hook_file   = ".git/hooks/#{type}"
      hook_invocation = "githooks run #{hook} $*"

      lines         = File.readlines(git_hook_file).map(&:rstrip)
      existing_hook = lines.find { |l| l.include?(hook_invocation) }

      if existing_hook
        say "Hook already installed"
        return
      end

      say "Installing hook #{hook}"
      end_line_index = lines.rindex { |l| l =~ /^# End of githooks scripts/ }

      if end_line_index
        lines.insert(end_line_index, hook_invocation)
      else
        lines << '# Start of githooks scripts'
        lines << hook_invocation
        lines << '# End of githooks scripts'
      end

      File.open(git_hook_file, 'w') do |f|
        f.write(lines.join("\n"))
      end
    end

    def validate_git_repo
      if not File.directory?('.git/hooks')
        error "Can't find `.git/hooks` directory, are you in a git repository?"
      end
    end

    # TODO (2013-05-11) Duplicated, refactor
    def validate_hook_type(type)
      if not possible_hook_types.include?(type)
        error "The type of the script needs to be one of: #{possible_hook_types.join(', ')}."
      end
    end

    def validate_hook(hook)
      if not hook
        error "No hook given"
      end

      script_name = config.hook_path(hook)

      if not File.exist?(script_name) or not File.executable?(script_name)
        error "File `#{script_name}` doesn't exist or is not executable."
      end
    end

    private

    # TODO (2013-05-11) Duplicated, refactor
    def possible_hook_types
      %w{
        applypatch-msg
        commit-msg
        post-applypatch
        post-checkout
        post-commit
        post-merge
        post-receive
        post-rewrite
        post-update
        pre-applypatch
        pre-auto-gc
        pre-commit
        pre-push
        pre-rebase
        pre-receive
        prepare-commit-msg
        update
      }
    end
  end
end
