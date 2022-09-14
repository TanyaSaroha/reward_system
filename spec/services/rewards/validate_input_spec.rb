require 'rails_helper'

RSpec.describe Rewards::ValidateInput do
  it "should be successful" do
    input_string = "2018-06-12 09:41 A recommends B
    2018-06-14 09:41 B accepts
    2018-06-16 09:41 B recommends C
    2018-06-17 09:41 C accepts
    2018-06-19 09:41 C recommends D
    2018-06-23 09:41 B recommends D
    2018-06-25 09:41 D accepts"

    File.open('input_file', 'w') { |file| file.write(input_string) }
    file = File.open('input_file')
    validator = Rewards::ValidateInput.new(file)

    expect(validator.invalid?).to be_falsy
    expect(validator.errors).to_not be_present
    File.delete(file)
  end

  context "fails" do

    it "when invite sender is invalid" do
      input_string = "2018-06-12 09:41 A recommends"

      File.open('input_file', 'w') { |file| file.write(input_string) }
      file = File.open('input_file')
      validator = Rewards::ValidateInput.new(file)

      expect(validator.invalid?).to be_truthy
      expect(validator.errors).to be_present
      expect(validator.errors.full_messages).to include("Invalid data at line 0. Both sender and receiver must be present")
      File.delete(file)
    end

    it "should not allow recommends input without sender" do
      input_string = "2018-06-12 09:41  recommends B"

      File.open('input_file', 'w') { |file| file.write(input_string) }
      file = File.open('input_file')
      validator = Rewards::ValidateInput.new(file)

      expect(validator.invalid?).to be_truthy
      expect(validator.errors).to be_present
      expect(validator.errors.full_messages).to include("Invalid data at line 0. Both sender and receiver must be present")
      File.delete(file)
    end

    it "when invite sender is present with accepts actions" do
      input_string = "2018-06-12 09:41 A accepts B"

      File.open('input_file', 'w') { |file| file.write(input_string) }
      file = File.open('input_file')
      validator = Rewards::ValidateInput.new(file)

      expect(validator.invalid?).to be_truthy
      expect(validator.errors).to be_present
      expect(validator.errors.full_messages).to include("Sender invalid at line 0.")
      File.delete(file)
    end

    it "should not allow accepts actions without user" do
      input_string = "2018-06-12 09:41  accepts"

      File.open('input_file', 'w') { |file| file.write(input_string) }
      file = File.open('input_file')
      validator = Rewards::ValidateInput.new(file)

      expect(validator.invalid?).to be_truthy
      expect(validator.errors).to be_present
      expect(validator.errors.full_messages).to include("Sender invalid at line 0.")
      File.delete(file)
    end

    it "should not allow input like A invites B, C accepts" do
    end

    it "when action is invalid" do
      input_string = "2018-06-12 09:41 A helps B"

      File.open('input_file', 'w') { |file| file.write(input_string) }
      file = File.open('input_file')
      validator = Rewards::ValidateInput.new(file)

      expect(validator.invalid?).to be_truthy
      expect(validator.errors).to be_present
      expect(validator.errors.full_messages).to include("Action is invalid at line 0")
      File.delete(file)
    end

    it "when date format is invalid" do
      input_string = "2018-20-20 20:20 A recommends B"
  
      File.open('input_file', 'w') { |file| file.write(input_string) }
      file = File.open('input_file')
      validator = Rewards::ValidateInput.new(file)
  
      expect(validator.invalid?).to be_truthy
      expect(validator.errors).to be_present
      expect(validator.errors.full_messages).to include("Date Invalid at line 0")
      File.delete(file)
    end

    it "when date sequence is invalid" do
      input_string = "2018-06-12 09:41 A recommends B\n2018-06-10 09:41 B accepts"
  
      File.open('input_file', 'w') { |file| file.write(input_string) }
      file = File.open('input_file')
      validator = Rewards::ValidateInput.new(file)
  
      expect(validator.invalid?).to be_truthy
      expect(validator.errors).to be_present
      expect(validator.errors.full_messages).to include("Date Order is incorrect. Must be in chronological order.")
      File.delete(file)
    end

  end
end