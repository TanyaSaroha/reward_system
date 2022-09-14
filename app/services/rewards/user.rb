module Rewards
  class User
    attr_reader :identifier
    attr_accessor :status, :points, :parent

    STATUSES = %w[joined invited accepted].freeze

    def initialize(identifier = nil, parent = nil, status = "joined")
      @identifier = identifier
      @points = 0
      @parent = parent
      @status = status
    end

    def accepts?
      status == "accepted"
    end
    
  end
end
