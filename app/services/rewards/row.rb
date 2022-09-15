module Rewards
  class Row
    attr_reader :date, :receiver, :sender, :action, :row

    def initialize(row_data)
      @row = row_data.strip
      @action = row.include?('accepts') ? :accepts : :recommends
      @sender = row.split(' ')[2]
      @receiver = row.split(' ')[4] if recommends?
      @date = parse_date(row)
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
