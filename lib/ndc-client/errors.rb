module NDCErrors

  class NDCUnsupportedMethod < RuntimeError; end
  class NDCUnknownMethod < RuntimeError; end
  class NDCInvalidServerResponse < RuntimeError; end
  class NDCInvalidResponseFormat < EncodingError; end
  class NDCWrongBodyWrapping < EncodingError; end
  class NDCParseError < EncodingError; end

  class NDCError < StandardError
    attr_accessor :code, :message

    def initialize(code, message)
      self.code = code
      self.message = message
    end

    def code=(new_code)
      @code = new_code.to_i
    end

    def to_s
      "#{code}: #{message}"
    end
  end

  class Errors
    attr_accessor :messages

    def initialize
      self.messages = {}
    end

    def add(code, message)
      messages[code] = message
    end

    def clear; messages.clear; end
    def length; messages.length; end
    def count; messages.count; end

    def to_a(include_codes = true)
      messages.map { |k,v| include_codes ? "#{v} (#{k})" : v }
    end
  end

end
