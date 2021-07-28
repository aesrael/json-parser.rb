module Constants
  # https://datatracker.ietf.org/doc/html/rfc7159#page-5
  WHITESPACE_CHARS = {
    ' ': true,
    '\n': true,
    '\t': true,
    '\r': true
  }.freeze

  # https://datatracker.ietf.org/doc/html/rfc7159#page-8
  ESCAPE_CHARS = {
    '"': '0022',
    'b': '0008',
    'f': '000C',
    'n': '000A',
    'r': '000D',
    't': '0009',
    '/': '002F',
    '\\': '005C'
  }.freeze

  # https://datatracker.ietf.org/doc/html/rfc7159#section-3
  LITERALS = {
    true: true,
    false: false,
    null: nil
  }.freeze

  COMMA = ','.freeze
  COLON = ':'.freeze
  UNEXPECTED_END_OF_JSON = 'Unexpected end of JSON input'.freeze
end
