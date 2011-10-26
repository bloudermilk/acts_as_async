ActiveRecord::Schema.define :version => 0 do
  create_table :async_models, :force => true do |t|
    t.string :name
  end

  create_table :bare_models, :force => true do |t|
    t.string :name
  end  
end
