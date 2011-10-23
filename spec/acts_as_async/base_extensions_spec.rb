require "spec_helper"

describe ActsAsAsync::BaseExtensions do
  it "should be included into ActiveRecord"

  describe ".acts_as_async" do
    it "should include the rest of the helper methods"

    context "when @queue is already set" do
      context "when :queue is passed as an option" do
        it "should override the @queue value to the value passed"
      end

      context "when :queue isn't passed as an option" do
        it "should leave the existing @queue value alone"
      end
    end

    context "when @queue isn't set" do
      context "when :queue is passed as an option" do
        it "should set @queue to the value passed"
      end

      context "when :queue isn't passed as an option" do
        it "should set @queue to :default"
      end
    end
  end
end
