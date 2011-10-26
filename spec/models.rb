class Model < ActiveRecord::Base
  acts_as_async

  def smash!(value = "SMASHED")
    update_attribute :name, value
  end
end
