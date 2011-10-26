require "spec_helper"

describe ActsAsAsync::BaseExtensions do
  it "should be included into ActiveRecord" do
    lambda { new_model.acts_as_async }.should_not raise_exception
  end

  describe ".acts_as_async" do
    it "should include the rest of the helper methods" do
      new_async_model.should respond_to(:async)
      new_async_model.should respond_to(:async_at)
      new_async_model.should respond_to(:async_in)
      new_async_model.new.should respond_to(:async)
      new_async_model.new.should respond_to(:async_at)
      new_async_model.new.should respond_to(:async_in)
    end

    context "when @queue is already set" do
      let(:model) do
        m = new_model
        m.instance_variable_set(:@queue, :old_queue)
        m
      end

      context "when :queue is passed as an option" do
        it "should override the @queue value to the value passed" do
          model.acts_as_async :queue => :new_queue
          model.instance_variable_get(:@queue).should == :new_queue
        end
      end

      context "when :queue isn't passed as an option" do
        it "should leave the existing @queue value alone" do
          model.acts_as_async
          model.instance_variable_get(:@queue).should == :old_queue
        end
      end
    end

    context "when @queue isn't set" do
      let (:model) { new_model }

      context "when :queue is passed as an option" do
        it "should set @queue to the value passed" do
          model.acts_as_async :queue => :foobar
          model.instance_variable_get(:@queue).should == :foobar
        end
      end

      context "when :queue isn't passed as an option" do
        it "should set @queue to :default" do
          model.acts_as_async
          model.instance_variable_get(:@queue).should == :default
        end
      end
    end
  end
end
