require 'rails_helper'

RSpec.describe Rewards::ReferralMap do
  describe '#initialize' do
    it 'returns Node object' do
      referral_map = described_class.new('SuperParent')
      expect(referral_map.super_parent).to be_present
      super_parent = referral_map.super_parent
      
      expect(super_parent.identifier).to eq("SuperParent")
      expect(super_parent.points).to eq(0)
      expect(super_parent.status).to eq("joined")
    end
  end

  describe '#add_user' do
    before do
      @referral_map = described_class.new('SuperParent')
      @referral_map.add_user("parent_id", "child_id")
    end

    it 'adds new user' do
      user_info = @referral_map.user_info
      expect(user_info).to be_present
      expect(user_info["child_id"]).to be_present
      expect(user_info["parent_id"]).to be_present
    end

    it 'adds super parent as parent of user joining without invite' do
      user_info = @referral_map.user_info
      expect(user_info).to be_present
      expect(user_info["parent_id"]).to be_present
      expect(user_info["parent_id"].parent).to be_present
      expect(user_info["parent_id"].parent.identifier).to eq("SuperParent")
    end

    it 'adds invite sender as parent of user being invited' do
      user_info = @referral_map.user_info
      expect(user_info).to be_present
      expect(user_info["child_id"]).to be_present
      expect(user_info["child_id"].parent).to be_present
      expect(user_info["child_id"].parent.identifier).to eq("parent_id")
    end
  end

  describe '#reward_points' do
    before do
      @referral_map = described_class.new('SuperParent')
      @referral_map.add_user("parent_id", "child_id")
    end

    it "increases points when valid invite is accepted" do
      @referral_map.reward_points("child_id")
      user_info = @referral_map.user_info
      expect(user_info["child_id"].parent.points).to eq(1)
    end

    it "dont increase points when invite is accepted twice" do
      @referral_map.reward_points("child_id")
      @referral_map.reward_points("child_id")

      user_info = @referral_map.user_info
      expect(user_info["child_id"].parent.points).to eq(1)
    end

    it "increase points when indirect invite is accepted" do
      @referral_map.reward_points("child_id")
      @referral_map.add_user("child_id", "second_child_id")
      @referral_map.reward_points("second_child_id")

      user_info = @referral_map.user_info
      expect(user_info["child_id"].parent.points).to eq(1.5)
      expect(user_info["second_child_id"].parent.points).to eq(1)
    end

  end


end
