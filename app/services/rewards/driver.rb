module Rewards
  class Driver
    attr_reader :data, :validator, :errors, :calculator, :file

    delegate :data, to: :validator

    def initialize(file)
      @file = file
      @validator = ValidateInput.new(file)
      @errors = @validator.errors if @validator.invalid?
    end

    def get_points
      @calculator = Rewards::Calculator.new(sorted_rows)
      @calculator.points
    end

    private

    def formatted_rows
      @formatted_rows ||= data.split("\n").map do |row|
        Row.new(row)
      end
    end

    def sorted_rows
      formatted_rows.sort { |a, b|  a.date <=> b.date }
    end

  end
end
