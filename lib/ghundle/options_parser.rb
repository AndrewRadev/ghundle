require 'optparse'
require 'ostruct'
require 'ghundle/version'

module Ghundle
  # Contains the logic for extracting command-line options. Relies on
  # 'optparse' from the standard library.
  class OptionsParser
    def initialize(args)
      @args = args
    end

    def usage
      [
        '',
        'Usage: ghundle <command> [options...]',
        '',
        'Commands:',
        '',
        '  ghundle list-all',
        '  ghundle run <hook-name>',
        '  ghundle fetch github.com/<username>/<repo>/<path/to/hook/dir>',
        '  ghundle install <hook-name>',
        '  ghundle install github.com/<username>/<repo>/<path/to/hook/dir>',
        '  ghundle list-installed',
        '  ghundle uninstall <hook-name>',
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
