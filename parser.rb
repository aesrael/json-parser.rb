require './constants'

# JSON parser class
#  - guidelines : https://datatracker.ietf.org/doc/html/rfc7159
#  - usage -
#     str =  '{"foo": [1, true, "bar"]}'
#     JSON = JSONParser.new
#     puts JSON.parse(str)
class JSONParser
  include Constants

  def parse(input)
    @pos = 0
    @input = input
    parse_value
  end

  def parse_value
    skip_whitespace
    value = parse_string || parse_number || parse_object || parse_array || parse_literals
    skip_whitespace

    raise unexpected_token if value == :nil

    value
  end

  def char
    @input[@pos]
  end

  # https://datatracker.ietf.org/doc/html/rfc7159#section-4
  def parse_object
    return nil unless char == '{'

    @pos += 1
    skip_whitespace

    first_field = true
    hash = {}

    until char == '}'
      raise unexpected_end unless char

      skip_comma_and_whitespace unless first_field
      first_field = false

      key = parse_hash_key
      value = parse_value
      expect 'hash value' if value == :nil

      hash[key] = value
    end

    @pos += 1

    hash
  end

  # https://datatracker.ietf.org/doc/html/rfc7159#section-5
  def parse_array
    return nil unless char == '['

    @pos += 1

    skip_whitespace

    array = []

    first_value = true
    until char == ']'
      raise unexpected_end unless char

      parse_comma unless first_value
      value = parse_value

      next if value == :nil

      array << value

      first_value = false
    end
    @pos += 1

    array
  end

  # https://datatracker.ietf.org/doc/html/rfc7159#section-6
  def parse_number
    start = @pos
    is_float = false

    if char == '-'
      @pos += 1
      raise unexpected_token unless number?
    end

    if char == '0'
      @pos += 1
      unexpected_token 'number' if char == '0'
    elsif number?(true)
      @pos += 1
      @pos += 1 while number?
    end

    if char == '.'
      @pos += 1
      is_float = true
      unexpected_token 'number' unless number?
    end

    @pos += 1 while number?

    if @pos > start
      no = @input[start, @pos]
      is_float ? no.to_f : no.to_i
    end
  end

  # https://datatracker.ietf.org/doc/html/rfc7159#section-3
  def parse_literals
    LITERALS.each do |key, value|
      len = key.to_s.length
      match = key.to_s == @input[@pos, len]

      next unless match

      @pos += len
      return value
    end
    :nil
  end

  # https://datatracker.ietf.org/doc/html/rfc7159#section-7
  def parse_string
    return nil unless char == '"'

    value = ''
    @pos += 1

    until char == '"'
      raise unexpected_end unless char

      # \\n, \\r ...
      if char == '\\'
        @pos += 1
        if ESCAPE_CHARS[char&.to_sym]
          value += ESCAPE_CHARS[char&.to_sym].to_i(16).chr(Encoding::UTF_8)
        # if unicode character -> u hex hex hex hex eg u1F6A
        elsif char == 'u'
          chars = @input[@pos + 1, 4]
          valid_hex_sequence = chars.chars.select(&hexadecimal?).count == 4

          unless valid_hex_sequence
            @pos += 1 # to show meaningful error
            expect 'unicode character'
          end
          value += chars.to_i(16).chr(Encoding::UTF_8)
          @pos += 4
        else
          expect 'escape character'
        end
      else
        value += char
      end
      @pos += 1
    end
    @pos += 1
    value
  end

  def hexadecimal?
    lambda do |c|
      return c >= '0' && c <= '9' || c.downcase >= 'a' && c.downcase <= 'f'
    end
  end

  # check if a given string is a (natural) number between 0 - 9
  def number?(natural = false)
    return nil unless char

    char >= (natural ? '1' : '0') && char <= '9'
  end

  def skip_whitespace
    @pos += 1 while WHITESPACE_CHARS[char&.to_sym]
    nil
  end

  def parse_comma
    expect 'comma(,)' unless char == COMMA
    @pos += 1
    nil
  end

  def parse_colon
    expect 'colon(:)' unless char == COLON
    @pos += 1
    nil
  end

  def raise_unexpected_char
    raise("value expected #{char}")
  end

  def parse_hash_key
    key = parse_string
    skip_whitespace

    parse_colon
    skip_whitespace
    key
  end

  def skip_comma_and_whitespace
    parse_comma
    skip_whitespace
  end

  def expect(value)
    raise "#{value} expected in JSON at positon #{@pos}, got '#{char}' instead"
  end

  def unexpected_token(type = 'token')
    raise "unexpected #{type} #{char} in JSON at positon #{@pos}"
  end

  def unexpected_end
    raise UNEXPECTED_END_OF_JSON
  end
end
