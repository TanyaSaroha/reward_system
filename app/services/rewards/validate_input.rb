module Rewards
  class ValidateInput
    include ActiveModel::Model

    attr_accessor :data, :file

    ACTIONS = ["recommends", "accepts"]

    validates :file, presence: true
    validate :validate_file, :validate_each_row, :order_of_rows

    def initialize(file)
      @file = file
      @receivers = []
    end

    private

    def validate_file
      @data = File.open(file, 'r').map{|row| row}.join
    end

    def validate_each_row
      data.split("\n").each.with_index do |row, line|
        row.strip!
        validate_date(row, line)
        validate_users(row, line)
        validate_actions(row, line)
      end
    end

    def order_of_rows
      errors.add(:date, 'Order is incorrect. Must be in chronological order.') unless dates_are_in_order?
    end

    def all_dates
      data.split("\n").map do |row|
        row.strip!
        parse_date(row)
      end
    end

    def dates_are_in_order?
      return true if all_dates.size < 2
      all_dates.map.with_index do |date, line|
        date <=> all_dates[line + 1]
      end.uniq.first.negative?
    end

    def validate_date(row, line)
      date = parse_date(row)
      return if date
      errors.add(:date, "missing at line #{line}")
      throw(:abort)
    rescue ArgumentError
      errors.add(:date, "Invalid at line #{line}")
      throw(:abort)
    end

    def parse_date(row)
      strtime = "#{row.split(' ')[0]} #{row.split(' ')[1]}"
      Time.zone.parse(strtime)
    end

    def validate_actions(row, line)
      return if ACTIONS.select do |keyword|
        row.downcase.include?(keyword)
      end.any?

      errors.add(:action, "is invalid at line #{line}")
      throw(:abort)
    end

    def validate_users(row, line)
      validate_sender_receiver(row, line) if row.include?('recommends')
      validate_invite_accepter(row, line) if row.include?('accepts')
    end

    def validate_sender_receiver(row, line)
      details = row.split(" ") 
      return if details.size == 5 && receiver_present?(details)

      errors.add(:base, "Invalid data at line #{line}. Both sender and receiver must be present")
      throw(:abort)
    end

    def receiver_present?(details)
      @receivers << details[4] if details[4].present?
      details[3] == "recommends" && details[4].present?
    end

    def validate_invite_accepter(row, line)
      details = row.split(" ")
      return if details.size == 4 && acceptor_valid?(details)

      errors.add(:base, "Sender invalid at line #{line}.")
      throw(:abort)
    end

    def acceptor_valid?(details)
      details[2].present? && details[3] == "accepts" && @receivers.include?(details[2])
    end

  end
end