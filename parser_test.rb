require 'test/unit'
# require 'test/unit/assertions'
require './parser'
require 'json'

TEST_CASES = [
  {
    value: '"\\n"',
    compare_built_in: true
  },
  {
    value: '-0.012345',
    compare_built_in: true
  },
  {
    value: 'true',
    compare_built_in: true
  },
  {
    value: 'false',
    compare_built_in: true
  },
  {
    value: 'null',
    compare_built_in: true
  },
  {
    value: '0',
    compare_built_in: true
  },
  {
    value: '0',
    compare_built_in: true
  },
  {
    value: '0.0',
    compare_built_in: true
  },
  {
    value: '0.12',
    compare_built_in: true
  },
  {
    value: '-0.12',
    compare_built_in: true
  },
  {
    value: '["foo", true, false, null, 1234, 2.034, { "foo": "bar" }]',
    compare_built_in: true
  },
  {
    value: '{ "car" :"bar", "foo" : "baz", "key": { "lock": "duck" } }',
    compare_built_in: true
  },
  {
    value: '{ "car" : true, "null" : null }',
    compare_built_in: true
  },
  {
    value: '{ "d": "\\u1F6A"}',
    compare_built_in: true
  },
  {
    value: '"',
    to_error_with: 'Unexpected end of JSON input'
  },
  {
    value: "'",
    to_error_with: "unexpected token ' in JSON at position 0"
  },
  {
    value: '00.01',
    to_error_with: 'unexpected number 0 in JSON at position 1'
  },
  {
    value: '[',
    to_error_with: 'Unexpected end of JSON input'
  },
  {
    value: '}',
    to_error_with: 'unexpected token } in JSON at position 0'
  },
  {
    value: '{"foo"}',
    to_error_with: "colon(:) expected in JSON at position 6, got '}' instead"
  },
  {
    value: '{"new_line": "\\n", "carriage_return": "\\r", "tab": "\\t", "quote": "\\"", "solidus": "\\/", "reverse_solidus": "\\\\", "form_feed": "\\f"}',
    compare_built_in: true
  }
]

class ParserTest < Test::Unit::TestCase
  JSON_PARSER = JSONParser.new

  def test_parse
    TEST_CASES.each do |test_case|
      puts "testing case >>> '#{test_case}'"
      str = test_case[:value]

      assert_equal JSON_PARSER.parse(str), JSON.parse(str) if test_case[:compare_built_in]
      error = test_case[:to_error_with]
      next unless error

      exception = assert_raises RuntimeError do
        JSON_PARSER.parse(str)
      end
      assert_equal(exception.message, error)
    end
  end
end
