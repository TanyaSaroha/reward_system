module Rewards
  class ReferralMap
    attr_accessor :super_parent, :user_info

    def initialize(super_parent_name = nil)
      @super_parent = User.new(super_parent_name)
      @user_info = {}
    end

    def add_user(parent_id, child_id)
      parent = user_info[parent_id] ? user_info[parent_id] : insert(super_parent, parent_id, "joined")
      child = user_info[child_id]
      insert(parent, child_id, "invited") unless child
    end

    def reward_points(key)
      user = user_info[key]
      user.status = "accepted"
      add_points_to_parents(user, 1) if user.accepts?
      user
    end

    def user_points
      user_info.keys.each_with_object({}){ |k,h| h[k] = user_info[k].points if user_info[k].points > 0 }
    end

    private

    def insert(parent, value, status)
      return parent if parent.identifier == value

      new_user = User.new(value, parent, status)
      user_info[value] = new_user
      add_points_to_parents(new_user, 1) if new_user.accepts?
      new_user
    end

    def add_points_to_parents(user, points)
      return unless user.accepts?

      parent = user.parent
      parent.points += points
      add_points_to_parents(parent, points / 2.0)
    end
  end
end
