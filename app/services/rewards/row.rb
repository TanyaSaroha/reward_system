module Rewards
  class Row
    attr_reader :date, :to, :from, :action, :row

    def initialize(row_data)
      @row = row_data.strip
      @date = parse_date(row)
      @action = fill_action(row)
      @from = fill_from(row)
      @to = fill_to(row)
    end

    def accepts?
      action == :accepts
    end

    def recommends?
      action == :recommends
    end

    private

    def fill_action(row)
      row.include?('accepts') ? :accepts : :recommends
    end

    def fill_from(row)
      row.split(' ')[2]
    end

    def fill_to(row)
      return unless recommends?

      row.split(' ')[4]
    end

    def parse_date(row)
      strtime = row.strip.first(16)
      Time.zone.parse(strtime)
    end

  end
end
