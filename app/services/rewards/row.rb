module Rewards
  class Row
    attr_reader :date, :to, :from, :action, :row

    def initialize(row_data)
      @row = row_data.strip
      @date = parse_date(row)
      @action = row.include?('accepts') ? :accepts : :recommends
      @from = row.split(' ')[2]
      @to = row.split(' ')[4] if recommends?
    end

    def accepts?
      action == :accepts
    end

    def recommends?
      action == :recommends
    end

    private

    def parse_date(row)
      strtime = "#{row.split(' ')[0]} #{row.split(' ')[1]}"
      Time.zone.parse(strtime)
    end

  end
end
