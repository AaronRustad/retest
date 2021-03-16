class FlagTest < Minitest::Test
  def setup
  end

  def teardown
    end_retest @output, @pid
  end

  def test_with_no_command
    @output, @pid = launch_retest 'retest'

    assert_match <<~OUTPUT, @output.read
      Setup identified: [RSPEC]. Using command: 'bundle exec rspec <test>'
      Launching Retest...
      Ready to refactor! You can make file changes now
    OUTPUT

    modify_file('lib/bottles.rb')

    assert_match "Test File Selected: spec/bottles_spec.rb", @output.read
  end

  def test_help
    @output, @pid = launch_retest 'retest --help'

    assert_match <<~EXPECTED, @output.read
      Usage: retest  [OPTIONS] [COMMAND]

      Watch a file change and run it matching spec.
    EXPECTED
  end
end