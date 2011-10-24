require "spec_helper"

describe ActsAsAsync::Helper do
  it "should include the SharedMethods as instance methods"
  it "should extend the SharedMethods as class methods"

  describe ".perform" do
    context "when no ID is passed" do
      it "should call class methods"
    end

    context "when an ID is passed" do
      it "should call instance methods"
    end
  end

  describe ".async" do
    it "should enqueue the current class"
    it "should enqueue the passed method"
    it "should append any additional arguments"
  end

  describe ".async_at" do
    it "should enqueue at the passed time"
    it "should enqueue the current class"
    it "should enqueue the passed method"
    it "should append any additional arguments"
  end

  describe ".async_in" do
    it "should enqueue at the passed time interval"
    it "should enqueue the current class"
    it "should enqueue the passed method"
    it "should append any additional arguments"
  end

  describe "#async" do
    it "should enqueue the current class"
    it "should enqueue the current instance"
    it "should enqueue the passed method"
    it "should append any additional arguments"
  end

  describe "#async_at" do
    it "should enqueue at the passed time"
    it "should enqueue the current class"
    it "should enqueue the current instance"
    it "should enqueue the passed method"
    it "should append any additional arguments"
  end

  describe "#async_in" do
    it "should enqueue at the passed time interval"
    it "should enqueue the current class"
    it "should enqueue the current instance"
    it "should enqueue the passed method"
    it "should append any additional arguments"
  end
  
  describe "::METHOD_REGEXP" do
    it "should match async_foobar"
    it "should match async_foobar!"
    it "should match async_foobar_at"
    it "should match async_foobar_at!"
    it "should match async_foobar_in"
    it "should match async_foobar_in!"
    it "should not match async"
    it "should not match async_at"
    it "should not match async_in"
    it "should not match async_123"
    it "should capture the method name"
    it "should capture a trailing '_at'"
    it "should capture a trailing '_in'"
    it "should capture a trailing '!'"
  end

  describe "method_missing" do
    context "when the missing method doesn't match" do
      it "should call super"
    end

    context "when the extracted method exists" do
      context "when the method matches async" do
        it "should call async with the extracted method"
      end

      context "when the method matches async_at" do
        it "should call async_at with the extracted method"
        it "should order the arguments properly"
      end

      context "when the method matches async_in" do
        it "should call async_in with the extracted method"
        it "should order the arguments properly"
      end
    end
    
    context "when the extracted method doesn't exist" do
      it "should raise NoMethodError"
    end
  end

  if RUBY_VERSION >= "1.9.2"
    describe "respond_to_missing?" do
      it "should return true if the passed method matches"
      it "should call super if the passed method doesn't match"
    end
  else
    describe "respond_to?" do
      it "should return true if the passed method matches"
      it "should call super if the passed method doesn't match"
    end
  end
end
