module Retest
  class AutoFlagTest < MiniTest::Test
    SetupFake = Struct.new(:type)

    def setup
      @setup = SetupFake.new
      @output_stream = StringIO.new
      @subject = Options.new(['--auto'], output_stream: @output_stream, setup: @setup)
    end

    def read_ouput
      @output_stream.tap(&:rewind).read
    end

    def test_for_rspec_setup
      @setup.type = :rspec

      assert_equal 'bundle exec rspec <test>', @subject.command
      assert_equal <<~OUTPUT, read_ouput
        Setup identified: [RSPEC]. Using command: 'bundle exec rspec <test>'
      OUTPUT
    end

    def test_for_rails_setup
      @setup.type = :rails

      assert_equal 'bundle exec rails test <test>', @subject.command
      assert_equal <<~OUTPUT, read_ouput
        Setup identified: [RAILS]. Using command: 'bundle exec rails test <test>'
      OUTPUT
    end

    def test_for_ruby_setup
      @setup.type = :ruby

      assert_equal 'bundle exec ruby <test>', @subject.command
      assert_equal <<~OUTPUT, read_ouput
        Setup identified: [RUBY]. Using command: 'bundle exec ruby <test>'
      OUTPUT
    end

    def test_for_rake_setup
      @setup.type = :rake

      assert_equal 'bundle exec rake test TEST=<test>', @subject.command
      assert_equal <<~OUTPUT, read_ouput
        Setup identified: [RAKE]. Using command: 'bundle exec rake test TEST=<test>'
      OUTPUT
    end

    def test_for_unknown_setup
      @setup.type = :unknown

      assert_equal 'bundle exec ruby <test>', @subject.command
      assert_equal <<~OUTPUT, read_ouput
        Setup identified: [UNKNOWN]. Using command: 'bundle exec ruby <test>'
      OUTPUT
    end
  end

  class AutoAllFlagTest < MiniTest::Test
    SetupFake = Struct.new(:type)

    def setup
      @setup = SetupFake.new
      @output_stream = StringIO.new
      @subject = Options.new(['--auto', '--all'], output_stream: @output_stream, setup: @setup)
    end

    def read_ouput
      @output_stream.tap(&:rewind).read
    end

    def test_for_rspec_setup
      @setup.type = :rspec

      assert_equal 'bundle exec rspec', @subject.command
      assert_equal <<~OUTPUT, read_ouput
        Setup identified: [RSPEC]. Using command: 'bundle exec rspec'
      OUTPUT
    end

    def test_for_rails_setup
      @setup.type = :rails

      assert_equal 'bundle exec rails test', @subject.command
      assert_equal <<~OUTPUT, read_ouput
        Setup identified: [RAILS]. Using command: 'bundle exec rails test'
      OUTPUT
    end

    def test_for_ruby_setup
      @setup.type = :ruby

      assert_equal 'bundle exec ruby <test>', @subject.command
      assert_equal <<~OUTPUT, read_ouput
        Setup identified: [RUBY]. Using command: 'bundle exec ruby <test>'
      OUTPUT
    end

    def test_for_rake_setup
      @setup.type = :rake

      assert_equal 'bundle exec rake test', @subject.command
      assert_equal <<~OUTPUT, read_ouput
        Setup identified: [RAKE]. Using command: 'bundle exec rake test'
      OUTPUT
    end

    def test_for_unknown_setup
      @setup.type = :unknown

      assert_equal 'bundle exec ruby <test>', @subject.command
      assert_equal <<~OUTPUT, read_ouput
        Setup identified: [UNKNOWN]. Using command: 'bundle exec ruby <test>'
      OUTPUT
    end
  end
end