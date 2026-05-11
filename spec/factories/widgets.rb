# frozen_string_literal: true

FactoryBot.define do
  factory :widget do
    name           { 'sprocket' }
    quantity       { 5 }
    price          { 9.99 }
    active         { true }
    description    { 'A fine sprocket' }
    tags           { %w[ruby gem] }
    metadata       { { 'color' => 'silver', 'weight' => 42 } }
    numeric_string { '123' }
    created_at     { Time.utc(2024, 1, 1, 12, 0, 0) }
    updated_at     { Time.utc(2024, 1, 1, 12, 0, 0) }
  end
end
