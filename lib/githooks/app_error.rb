module Githooks
  class AppError < RuntimeError
    def usage
      <<EOF
Usage:

  githooks <command> [options...]

  <command> can currently be only "run", so

  githooks run <hook-name>

EOF
    end
  end
end
