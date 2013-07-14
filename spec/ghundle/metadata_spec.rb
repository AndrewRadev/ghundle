require 'spec_helper'
require 'ghundle/metadata'

module Ghundle
  describe Metadata do
    it "can be serialized to a hash and read back from it" do
      raw_data = {
        'types'       => ['one', 'two', 'three'],
        'version'     => '0.1.0',
        'description' => 'Lorem ipsum',
      }

      unserialized = Metadata.new(raw_data).to_h
      unserialized.should eq raw_data

      Metadata.new(unserialized).to_h.should eq raw_data
    end
  end
end
