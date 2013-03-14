module SalesEngineWeb
  class Response
    attr_reader :body

    DEFAULT_BODY = {}.to_json

    def initialize(args = {})
      @body = args[:body] || DEFAULT_BODY
      @success = true
    end

    def success?
      @success
    end
  end
end