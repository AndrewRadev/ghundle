require 'optparse'
require 'ostruct'
require 'githooks/version'

module Githooks
  # Contains the logic for extracting command-line options. Relies on
  # 'optparse' from the standard library.
  class OptionsParser
    def initialize(args)
      @args = args
    end

    def usage
      [
        '',
        'Usage: githooks <command> [options...]',
        '',
        'Commands:',
        '',
        '  githooks list-all',
        '  githooks run <hook-name>',
        '  githooks fetch github.com/<username>/<repo>/<path/to/hook/dir>',
        '  githooks install <hook-name>',
        '  githooks install github.com/<username>/<repo>/<path/to/hook/dir>',
        '  githooks list-installed',
        '  githooks uninstall <hook-name>',
        '',
        'Options:',
        '',
      ].join("\n")
    end

    def parse
      options = OpenStruct.new

      parser = OptionParser.new do |o|
        o.banner = usage

        o.on_tail("-h", "--help", "Show this message") do
          puts o
          exit
        end

        o.on_tail("--version", "Show version") do
          puts VERSION
          exit
        end
      end

      parser.parse!(@args)
      options
    end
  end
end
