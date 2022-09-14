module Rewards
  class ValidateInput
    include ActiveModel::Model

    attr_accessor :data, :file

    ACTIONS = ["recommends", "accepts"]

    validates :file, presence: true
    validate :validate_each_row, :order_of_rows

    def initialize(file)
      @file = file
      @data = File.open(file, 'r').map{|row| row}.join
    end

    private

    def validate_each_row
      data.split("\n").each.with_index do |row, line|
        row.strip!
        validate_date(row, line)
        validate_users(row, line)
        validate_actions(row, line)
      end
    end

    def order_of_rows
      errors.add(:date, 'Order of Dates is incorrect. Must be in chronological order.') unless dates_are_in_order?
    end

    def all_dates
      data.split("\n").map do |row|
        row.strip!
        parse_date(row)
      end
    end

    def dates_are_in_order?
      all_dates.map.with_index do |date, line|
        date <=> all_dates[line + 1]
      end.uniq.first.negative?
    end

    def validate_date(row, line)
      parse_date(row)
    rescue ArgumentError
      errors.add(:date, "Invalid Date given at #{line} line")
      throw(:abort)
    end

    def validate_actions(row, line)
      return if ACTIONS.select do |keyword|
        row.downcase.include?(keyword)
      end.any?

      errors.add(:action, "Invitation is invalid at #{line} line")
      throw(:abort)
    end

    def validate_users(row, line)
      validate_recommends(row, line)
      validate_accepts(row, line)
    end

    def validate_recommends(row, line)
      return unless row.include?('recommends')
      return if inviter_found?(row)

      errors.add(:action, "Sender invalid at #{line} line")
      throw(:abort)
    end

    def validate_accepts(row, line)
      return unless row.include?('accepts')
      return if no_inviter?(row)

      errors.add(:action, "Sender invalid at #{line} line")
      throw(:abort)
    end

    def inviter_found?(row)
      action_line = row.index('recommends')
      row[action_line..-1].delete('recommends').gsub(/\s+/, '').present?
    end

    def no_inviter?(row)
      action_line = row.index('accepts')
      row[action_line..-1].delete('accepts').gsub(/\s+/, '').blank?
    end

    def parse_date(row)
      strtime = row.strip.first(16)
      Time.zone.parse(strtime)
    end

  end
end