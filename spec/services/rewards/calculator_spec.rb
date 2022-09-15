require 'rails_helper'

RSpec.describe Rewards::Calculator do
  describe 'points' do
    context 'success' do
      it "Should calculate user points" do
        input_string = "2018-06-12 09:41 A recommends B
        2018-06-13 09:41  B accepts"

        File.open('input_file', 'w') { |file| file.write(input_string) }
        file = File.open('input_file')
        validator = Rewards::ValidateInput.new(file)
        validator.invalid?

        rows = validator.data.split("\n").map{ |row| Rewards::Row.new(row) }.sort { |a, b|  a.date <=> b.date }
        points = Rewards::Calculator.new(rows).points

        expect(points).to be_present
        expect(points["A"]).to eq(1)
        File.delete(file)
      end

      it "Calculating user points for given test case" do
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
        validator.invalid?

        rows = validator.data.split("\n").map{ |row| Rewards::Row.new(row) }.sort { |a, b|  a.date <=> b.date }
        points = Rewards::Calculator.new(rows).points

        expect(points).to be_present
        expect(points["A"]).to eq(1.75)
        expect(points["B"]).to eq(1.5)
        expect(points["C"]).to eq(1)
        File.delete(file)
      end

      it "Calculating user points for repeating acceptance" do
        input_string = "2018-06-12 09:41 A recommends B
        2018-06-14 09:41 B accepts
        2018-06-16 09:41 B recommends C
        2018-06-17 09:41 C accepts
        2018-06-25 09:41 C accepts"        

        File.open('input_file', 'w') { |file| file.write(input_string) }
        file = File.open('input_file')
        validator = Rewards::ValidateInput.new(file)
        validator.invalid?

        rows = validator.data.split("\n").map{ |row| Rewards::Row.new(row) }.sort { |a, b|  a.date <=> b.date }
        points = Rewards::Calculator.new(rows).points

        expect(points).to be_present
        expect(points["A"]).to eq(1.5)
        expect(points["B"]).to eq(1)
        expect(points["C"]).to eq(nil)
        File.delete(file)
      end

      it "Calculating user points for repeating invites and repeating accepts" do
        input_string = "2018-06-12 09:41 A recommends B
        2018-06-14 09:41 B accepts
        2018-06-16 09:41 B recommends C
        2018-06-16 09:41 A recommends C
        2018-06-17 09:41 C accepts
        2018-06-25 09:41 C accepts"        

        File.open('input_file', 'w') { |file| file.write(input_string) }
        file = File.open('input_file')
        validator = Rewards::ValidateInput.new(file)
        validator.invalid?

        rows = validator.data.split("\n").map{ |row| Rewards::Row.new(row) }.sort { |a, b|  a.date <=> b.date }
        points = Rewards::Calculator.new(rows).points

        expect(points).to be_present
        expect(points["A"]).to eq(1.5)
        expect(points["B"]).to eq(1)
        expect(points["C"]).to eq(nil)
        File.delete(file)
      end

    end
  end
end
