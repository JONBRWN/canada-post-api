module CanadaPost
  class Credentials
    include Helpers

    attr_reader :username, :password, :customer_number, :mode

    def initialize(options={})
      requires!(options, :username, :password, :customer_number, :mode)
      @username         = options[:username]
      @password         = options[:password]
      @customer_number  = options[:customer_number]
      @mode             = options[:mode]
    end

  end

end