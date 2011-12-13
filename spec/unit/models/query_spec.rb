require 'spec_helper'

describe Marbu::Models::Query do
  context "a new Query instace" do
    let(:query) { Marbu::Models::Query.new }

    it "returns false for present?" do
      query.present?.should be_false
    end

    context "with at least one attribute set" do
      it "returns true for present? with attribute condition set" do
        query.condition = 'abc'
        query.present?.should be_true
      end

      it "returns true for present? with attribute datetime_fields set" do
        query.datetime_fields = ['abc']
        query.present?.should be_true
      end
    end
  end
end