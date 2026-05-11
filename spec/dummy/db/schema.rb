ActiveRecord::Schema.define do
  create_table :widgets, force: true do |t|
    t.string  :name
    t.integer :quantity
    t.float   :price
    t.boolean :active,      default: true
    t.text    :description
    t.json    :tags                        # JSON array
    t.json    :metadata                    # JSON object
    t.string  :numeric_string             # stores "123" — must NOT be cast to integer
    t.timestamps null: false
  end
end
