require "spec_helper"

describe ActsAsAsync::Helper do
  describe ".perform" do
    context "when no ID is passed" do
      subject { new_async_model }

      it "should call class methods" do
        subject.should_receive(:foobar)
        subject.perform "foobar"
      end

      it "should pass arguments" do
        subject.should_receive(:foobar).with("foo", "bar")
        subject.perform "foobar", "foo", "bar"
      end
    end

    context "when an ID is passed" do
      subject { Model.create }

      it "should call instance methods" do
        Model.perform subject.id, "smash!"
        subject.reload.name.should == "SMASHED"
      end

      it "should pass arguments" do
        Model.perform subject.id, "smash!", "LOL"
        subject.reload.name.should == "LOL"
      end
    end
  end

  describe ".async" do
    subject { new_async_model }

    it "should enqueue the current class" do
      Resque.should_receive(:enqueue).with(subject, anything)
      subject.async :foo
    end

    it "should enqueue the passed method" do
      Resque.should_receive(:enqueue).with(anything, :foo)
      subject.async :foo
    end

    it "should append any additional arguments" do
      Resque.should_receive(:enqueue).with(anything, anything, "foo", "bar")
      subject.async :foo, "foo", "bar"
    end
  end

  describe ".async_at" do
    subject { new_async_model }
    let(:time) { Time.now }

    it "should enqueue at the passed time" do
      Resque.should_receive(:enqueue_at).with(time, anything, anything)
      subject.async_at time, :foo
    end

    it "should enqueue the current class" do
      Resque.should_receive(:enqueue_at).with(anything, subject, anything)
      subject.async_at time, :foo
    end

    it "should enqueue the passed method" do
      Resque.should_receive(:enqueue_at).with(anything, anything, :foo)
      subject.async_at time, :foo
    end

    it "should append any additional arguments" do
      Resque.should_receive(:enqueue_at).with(anything, anything, anything, "bar", "baz")
      subject.async_at time, :foo, "bar", "baz"
    end
  end

  describe ".async_in" do
    subject { new_async_model }
    let(:interval) { 10.minutes }

    it "should enqueue at the passed time interval" do
      Resque.should_receive(:enqueue_in).with(interval, anything, anything)
      subject.async_in interval, :foo
    end

    it "should enqueue the current class" do
      Resque.should_receive(:enqueue_in).with(anything, subject, anything)
      subject.async_in interval, :foo
    end

    it "should enqueue the passed method" do
      Resque.should_receive(:enqueue_in).with(anything, anything, :foo)
      subject.async_in interval, :foo
    end

    it "should append any additional arguments" do
      Resque.should_receive(:enqueue_in).with(anything, anything, anything, "bar", "baz")
      subject.async_in interval, :foo, "bar", "baz"
    end
  end


  describe ".inherited" do
    context "when @queue isn't set" do
      let(:model) { new_async_model }
      subject { Class.new model }

      it "should set @queue to the value of the parent" do
        subject.instance_variable_get(:@queue).should == :default
      end
    end
  end

  describe "#async" do
    subject { Model.create }

    it "should enqueue the current class" do
      Resque.should_receive(:enqueue).with(subject.class, anything, anything)
      subject.async :foo
    end

    it "should enqueue the current instance" do
      Resque.should_receive(:enqueue).with(anything, subject.id, anything)
      subject.async :foo
    end

    it "should enqueue the passed method" do
      Resque.should_receive(:enqueue).with(anything, anything, :foo)
      subject.async :foo
    end

    it "should append any additional arguments" do
      Resque.should_receive(:enqueue).with(anything, anything, anything, "bar", "baz")
      subject.async :foo, "bar", "baz"
    end

    it "should raise an error if the instance isn't saved" do
      subject = Model.new
      proc { subject.async :foo }.should raise_error(ActsAsAsync::MissingIDError)
    end
  end

  describe "#async_at" do
    subject { Model.create }
    let(:time) { Time.now }

    it "should enqueue at the passed time" do
      Resque.should_receive(:enqueue_at).with(time, anything, anything, anything)
      subject.async_at time, :foo
    end

    it "should enqueue the current class" do
      Resque.should_receive(:enqueue_at).with(anything, subject.class, anything, anything)
      subject.async_at time, :foo
    end

    it "should enqueue the current instance" do
      Resque.should_receive(:enqueue_at).with(anything, anything, subject.id, anything)
      subject.async_at time, :foo
    end

    it "should enqueue the passed method" do
      Resque.should_receive(:enqueue_at).with(anything, anything, anything, :foo)
      subject.async_at time, :foo
    end

    it "should append any additional arguments" do
      Resque.should_receive(:enqueue_at).with(anything, anything, anything, anything, "bar", "baz")
      subject.async_at time, :foo, "bar", "baz"
    end

    it "should raise an error if the instance isn't saved" do
      subject = Model.new
      proc { subject.async_at time, :foo }.should raise_error(ActsAsAsync::MissingIDError)
    end
  end

  describe "#async_in" do
    subject { Model.create }
    let(:interval) { 10.minutes }

    it "should enqueue at the passed time interval" do
      Resque.should_receive(:enqueue_in).with(interval, anything, anything, anything)
      subject.async_in interval, :foo
    end

    it "should enqueue the current class" do
      Resque.should_receive(:enqueue_in).with(anything, subject.class, anything, anything)
      subject.async_in interval, :foo
    end

    it "should enqueue the current instance" do
      Resque.should_receive(:enqueue_in).with(anything, anything, subject.id, anything)
      subject.async_in interval, :foo
    end

    it "should enqueue the passed method" do
      Resque.should_receive(:enqueue_in).with(anything, anything, anything, :foo)
      subject.async_in interval, :foo
    end

    it "should append any additional arguments" do
      Resque.should_receive(:enqueue_in).with(anything, anything, anything, anything, "bar", "baz")
      subject.async_in interval, :foo, "bar", "baz"
    end

    it "should raise an error if the instance isn't saved" do
      subject = Model.new
      proc { subject.async_in interval, :foo }.should raise_error(ActsAsAsync::MissingIDError)
    end
  end

  describe "::METHOD_REGEXP" do
    subject { ActsAsAsync::Helper::SharedMethods::METHOD_REGEXP }

    it "should match async_foobar" do
      subject.should match("async_foobar")
    end

    it "should match async_foobar!" do
      subject.should match("async_foobar!")
    end

    it "should match async_foobar_at" do
      subject.should match("async_foobar_at")
    end

    it "should match async_foobar_at!" do
      subject.should match("async_foobar_at!")
    end

    it "should match async_foobar_in" do
      subject.should match("async_foobarin")
    end

    it "should match async_foobar_in!" do
      subject.should match("async_foobar_in!")
    end

    it "should not match async_123" do
      subject.should_not match("async_123")
    end

    it "should capture the method name" do
      match = "async_foobar".match subject
      match[1].should == "foobar"
    end

    it "should capture a trailing '_at'" do
      match = "async_foobar_at".match subject
      match[2].should == "_at"
    end

    it "should capture a trailing '_in'" do
      match = "async_foobar_in".match subject
      match[2].should == "_in"
    end

    it "should capture a trailing '!'" do
      match = "async_foobar!".match subject
      match[3].should == "!"
    end
  end

  describe "method_missing" do
    context "when the missing method doesn't match" do
      it "should call super" do
        lambda { Model.nonexistant_method }.should raise_error(NoMethodError)
      end
    end

    context "when the extracted method exists" do
      context "when the method matches async" do
        it "should call async with the extracted method" do
          Model.should_receive(:async).with("lol")
          Model.async_lol
        end

        it "should order the arguments properly" do
          Model.should_receive(:async).with("lol", "foo", "bar")
          Model.async_lol("foo", "bar")
        end
      end

      context "when the method matches async_at" do
        let(:time) { Time.now }

        it "should call async_at with the extracted method" do
          Model.should_receive(:async_at).with(time, "lol")
          Model.async_lol_at time
        end

        it "should order the arguments properly" do
          Model.should_receive(:async_at).with(time, "lol", "foo", "bar")
          Model.async_lol_at time, "foo", "bar"
        end
      end

      context "when the method matches async_in" do
        let(:interval) { 10.minutes }

        it "should call async_at with the extracted method" do
          Model.should_receive(:async_in).with(interval, "lol")
          Model.async_lol_in interval
        end

        it "should order the arguments properly" do
          Model.should_receive(:async_in).with(interval, "lol", "foo", "bar")
          Model.async_lol_in interval, "foo", "bar"
        end
      end

      context "when the matched method is private" do
        subject { Model.create }

        it "should still work" do
          lambda { subject.async_a_private_method }.should_not raise_error
        end
      end
    end

    context "when the extracted method doesn't exist" do
      it "should raise NoMethodError" do
        lambda { Model.async_nonexistant_method }.should raise_error(NoMethodError)
      end
    end
  end

  describe "respond_to?" do
    it "should return true if the passed method matches" do
      Model.respond_to?(:async_something).should == true
    end

    it "should call super if the passed method doesn't match" do
      Model.respond_to?(:something_totally_whack).should == false
    end
  end
end
