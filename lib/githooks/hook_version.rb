module Githooks
  class HookVersion
    attr_reader :major, :minor, :patch

    def initialize(string)
      @major, @minor, @patch = string.split('.').map(&:to_i)
    end

    def to_s
      "#{major}.#{minor}.#{patch}"
    end

    def ==(other)
      to_s == other.to_s
    end

    include Comparable

    def <=>(other)
      to_s <=> other.to_s
    end
  end
end
