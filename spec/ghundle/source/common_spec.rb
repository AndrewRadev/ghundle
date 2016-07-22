require 'spec_helper'
require 'ghundle/source/common'

module Ghundle
  module Source
    describe Common do
      describe "(subclass instance)" do
        let(:source) { Class.new(Common).new }

        %w[hook_name metadata].each do |m|
          it "needs an implementation for #{m}" do
            expect { source.send(m) }.to raise_error(NotImplementedError)
          end
        end

        %w[fetch fetched?].each do |m|
          it "needs an implementation for #{m}" do
            expect { source.send(m, '/foo') }.to raise_error(NotImplementedError)
          end
        end
      end
    end
  end
end
