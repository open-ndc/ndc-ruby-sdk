module NDCClient

  module NDCErrors

    class NDCError < RuntimeError
      attr_accessor :message

      def initialize(message)
        self.message = message
      end

      def to_s
        @message
      end
    end

    class NDCUnsupportedMethod < NDCError; end
    class NDCUnknownMethod < NDCError; end
    class NDCInvalidServerResponse < NDCError; end
    class NDCInvalidResponseFormat < NDCError; end
    class NDCWrongBodyWrapping < NDCError; end
    class NDCParseError < NDCError; end

  end

end
