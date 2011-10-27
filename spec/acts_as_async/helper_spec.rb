require "spec_helper"

describe ActsAsAsync::Helper do
  describe ".perform" do
    context "when no ID is passed" do
      let(:model) do
        new_async_model
      end

      it "should call class methods" do
        model.should_receive(:foobar)
        model.perform "foobar"
      end

      it "should pass arguments" do
        model.should_receive(:foobar).with("foo", "bar")
        model.perform "foobar", "foo", "bar"
      end
    end

    context "when an ID is passed" do
      let(:instance) { Model.create }

      it "should call instance methods" do
        Model.perform instance.id, "smash!"
        instance.reload.name.should == "SMASHED"
      end

      it "should pass arguments" do
        Model.perform instance.id, "smash!", "LOL"
        instance.reload.name.should == "LOL"
      end
    end
  end

  describe ".async" do
    let(:model) { new_async_model }

    it "should enqueue the current class" do
      Resque.should_receive(:enqueue).with(model, anything)
      model.async :foo
    end

    it "should enqueue the passed method" do
      Resque.should_receive(:enqueue).with(anything, :foo)
      model.async :foo
    end

    it "should append any additional arguments" do
      Resque.should_receive(:enqueue).with(anything, anything, "foo", "bar")
      model.async :foo, "foo", "bar"
    end
  end

  describe ".async_at" do
    let(:model) { new_async_model }
    let(:time) { Time.now }
    
    it "should enqueue at the passed time" do
      Resque.should_receive(:enqueue_at).with(time, anything, anything)
      model.async_at time, :foo
    end

    it "should enqueue the current class" do
      Resque.should_receive(:enqueue_at).with(anything, model, anything)
      model.async_at time, :foo
    end

    it "should enqueue the passed method" do
      Resque.should_receive(:enqueue_at).with(anything, anything, :foo)
      model.async_at time, :foo
    end

    it "should append any additional arguments" do
      Resque.should_receive(:enqueue_at).with(anything, anything, anything, "bar", "baz")
      model.async_at time, :foo, "bar", "baz"
    end
  end

  describe ".async_in" do
    let(:model) { new_async_model }
    let(:interval) { 10.minutes }
    
    it "should enqueue at the passed time interval" do
      Resque.should_receive(:enqueue_in).with(interval, anything, anything)
      model.async_in interval, :foo
    end

    it "should enqueue the current class" do
      Resque.should_receive(:enqueue_in).with(anything, model, anything)
      model.async_in interval, :foo
    end

    it "should enqueue the passed method" do
      Resque.should_receive(:enqueue_in).with(anything, anything, :foo)
      model.async_in interval, :foo
    end

    it "should append any additional arguments" do
      Resque.should_receive(:enqueue_in).with(anything, anything, anything, "bar", "baz")
      model.async_in interval, :foo, "bar", "baz"
    end
  end

  describe "#async" do
    let (:instance) { Model.create }

    it "should enqueue the current class" do
      Resque.should_receive(:enqueue).with(instance.class, anything, anything)
      instance.async :foo
    end

    it "should enqueue the current instance" do
      Resque.should_receive(:enqueue).with(anything, instance.id, anything)
      instance.async :foo
    end

    it "should enqueue the passed method" do
      Resque.should_receive(:enqueue).with(anything, anything, :foo)
      instance.async :foo
    end

    it "should append any additional arguments" do
      Resque.should_receive(:enqueue).with(anything, anything, anything, "bar", "baz")
      instance.async :foo, "bar", "baz"
    end
  end

  describe "#async_at" do
    let (:instance) { Model.create }
    let (:time) { Time.now }
    
    it "should enqueue at the passed time" do
      Resque.should_receive(:enqueue_at).with(time, anything, anything, anything)
      instance.async_at time, :foo
    end

    it "should enqueue the current class" do
      Resque.should_receive(:enqueue_at).with(anything, instance.class, anything, anything)
      instance.async_at time, :foo
    end

    it "should enqueue the current instance" do
      Resque.should_receive(:enqueue_at).with(anything, anything, instance.id, anything)
      instance.async_at time, :foo
    end

    it "should enqueue the passed method" do
      Resque.should_receive(:enqueue_at).with(anything, anything, anything, :foo)
      instance.async_at time, :foo
    end

    it "should append any additional arguments" do
      Resque.should_receive(:enqueue_at).with(anything, anything, anything, anything, "bar", "baz")
      instance.async_at time, :foo, "bar", "baz"
    end
  end

  describe "#async_in" do
    let (:instance) { Model.create }
    let (:interval) { 10.minutes }
    
    it "should enqueue at the passed time interval" do
      Resque.should_receive(:enqueue_in).with(interval, anything, anything, anything)
      instance.async_in interval, :foo
    end

    it "should enqueue the current class" do
      Resque.should_receive(:enqueue_in).with(anything, instance.class, anything, anything)
      instance.async_in interval, :foo
    end

    it "should enqueue the current instance" do
      Resque.should_receive(:enqueue_in).with(anything, anything, instance.id, anything)
      instance.async_in interval, :foo
    end

    it "should enqueue the passed method" do
      Resque.should_receive(:enqueue_in).with(anything, anything, anything, :foo)
      instance.async_in interval, :foo
    end

    it "should append any additional arguments" do
      Resque.should_receive(:enqueue_in).with(anything, anything, anything, anything, "bar", "baz")
      instance.async_in interval, :foo, "bar", "baz"
    end
  end
  
  describe "::METHOD_REGEXP" do
    let(:regexp) { ActsAsAsync::Helper::SharedMethods::METHOD_REGEXP }

    it "should match async_foobar" do
      "async_foobar".should match(regexp)
    end

    it "should match async_foobar!" do
      "async_foobar!".should match(regexp)
    end

    it "should match async_foobar_at" do
      "async_foobar_at".should match(regexp)
    end

    it "should match async_foobar_at!" do
      "async_foobar_at!".should match(regexp)
    end

    it "should match async_foobar_in" do
      "async_foobarin".should match(regexp)
    end

    it "should match async_foobar_in!" do
      "async_foobar_in!".should match(regexp)
    end

    it "should not match async_123" do
      "async_123".should_not match(regexp)
    end

    it "should capture the method name" do
      match = "async_foobar".match regexp
      match[1].should == "foobar"
    end

    it "should capture a trailing '_at'" do
      match = "async_foobar_at".match regexp
      match[2].should == "_at"
    end

    it "should capture a trailing '_in'" do
      match = "async_foobar_in".match regexp
      match[2].should == "_in"
    end

    it "should capture a trailing '!'" do
      match = "async_foobar!".match regexp
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
        let (:time) { Time.now }
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
        let (:interval) { 10.minutes }
        it "should call async_at with the extracted method" do
          Model.should_receive(:async_in).with(interval, "lol")
          Model.async_lol_in interval
        end

        it "should order the arguments properly" do
          Model.should_receive(:async_in).with(interval, "lol", "foo", "bar")
          Model.async_lol_in interval, "foo", "bar"
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
