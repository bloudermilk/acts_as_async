require "spec_helper"

describe ActsAsAsync::BaseExtensions do
  it "should be included into ActiveRecord" do
    lambda { BareModel.acts_as_async }.should_not raise_exception
  end

  describe ".acts_as_async" do
    it "should include the rest of the helper methods" do
      AsyncModel.should respond_to(:async)
      AsyncModel.should respond_to(:async_at)
      AsyncModel.should respond_to(:async_in)
      AsyncModel.new.should respond_to(:async)
      AsyncModel.new.should respond_to(:async_at)
      AsyncModel.new.should respond_to(:async_in)
    end

    context "when @queue is already set" do
      let :model { BareModel }

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
