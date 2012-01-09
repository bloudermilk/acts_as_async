class Model < ActiveRecord::Base
  acts_as_async

  def self.lol(foo = "hah", bar = "heh")
    # Do nothing
  end

  def smash!(value = "SMASHED")
    update_attribute :name, value
  end

private

  def a_private_method; end

end
