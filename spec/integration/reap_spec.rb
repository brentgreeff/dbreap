# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'db:reap rake task output' do
  before do
    Widget.delete_all
    create(:widget, name: 'sprocket', quantity: 5)
    create(:widget, name: 'cog', quantity: 12)
  end

  it 'exports all rows keyed by table_001, table_002' do
    data = YAML.safe_load(Dbreap::Reap.build_yml('widgets'))
    expect(data.keys).to contain_exactly('widgets_001', 'widgets_002')
  end

  it 'exports rows in id order' do
    data = YAML.safe_load(Dbreap::Reap.build_yml('widgets'))
    expect(data['widgets_001']['name']).to eq('sprocket')
    expect(data['widgets_002']['name']).to eq('cog')
  end
end
