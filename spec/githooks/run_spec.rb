module Githooks
  describe Run do
    it "can run a script" do
      create_test_script('post-merge/test-hook', <<-EOF)
        #! /bin/sh
        echo "OK" > test-hook-result
      EOF

      Run.call('post-merge/test-hook')

      File.exists?('test-hook-result').should be_true
      File.read('test-hook-result').strip.should eq 'OK'
    end

    it "gives the positional arguments to the script" do
      create_test_script('post-merge/test-hook', <<-EOF)
        #! /bin/sh
        echo "$1 $2" > test-hook-result
      EOF

      Run.call('post-merge/test-hook', 'one', 'two')

      File.exists?('test-hook-result').should be_true
      File.read('test-hook-result').strip.should eq 'one two'
    end
  end
end
