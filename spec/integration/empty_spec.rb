# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dbreap::Empty do
  before do
    create(:widget, name: 'sprocket')
    create(:widget, name: 'cog')
  end

  it 'deletes all rows from each table' do
    described_class.call
    expect(Widget.count).to eq(0)
  end

  it 'leaves the table intact' do
    described_class.call
    expect(ActiveRecord::Base.connection.table_exists?('widgets')).to be true
  end
end
