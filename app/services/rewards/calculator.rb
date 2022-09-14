module Rewards
  class Calculator
    attr_reader :rows

    def initialize(rows)
      @rows = rows
    end

    def points
      #Converting all rows into user connections via referrals
      rows.each{ |row| row.recommends? ? referral_map.add_user(row.from, row.to) : referral_map.reward_points(row.from) }
      referral_map.user_points
    end

    private

    def referral_map
      #Creating a new Referral Map to manage all connections
      @referral_map ||= ReferralMap.new('SuperParent')
    end
  end
end
