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

    def sorted_rows
      data.split("\n").map{ |row| Row.new(row) }.sort { |a, b|  a.date <=> b.date }
    end

  end
end
