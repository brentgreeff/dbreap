require "rails_helper"

# Verifies that reap → seed → reap produces identical YAML.
# The ordering bug: after seeding, new auto-increment IDs are assigned.
# If ORDER BY id is used, the second reap has different ids and the
# fixture keys (widgets_001, widgets_002) may map to different rows.
RSpec.describe "reap → seed → reap round-trip" do
  let(:fixture_dir) { Dir.mktmpdir }
  let(:fixture_path) { File.join(fixture_dir, "widgets.yml") }

  before do
    Widget.delete_all
    create(:widget, name: "alpha", quantity: 1)
    create(:widget, name: "beta",  quantity: 2)
    create(:widget, name: "gamma", quantity: 3)
  end

  after { FileUtils.remove_entry(fixture_dir) }

  it "produces identical YAML on a second reap after seeding" do
    first_yaml = Dbreap::Reap.build_yml("widgets")
    File.write(fixture_path, first_yaml)

    Widget.delete_all
    ActiveRecord::FixtureSet.create_fixtures(fixture_dir, "widgets")

    second_yaml = Dbreap::Reap.build_yml("widgets")

    first  = YAML.safe_load(first_yaml).transform_values  { |r| r.except("id") }
    second = YAML.safe_load(second_yaml).transform_values { |r| r.except("id") }

    expect(second).to eq(first)
  end

  it "preserves row order (names map to same fixture keys on second reap)" do
    first_yaml = Dbreap::Reap.build_yml("widgets")
    File.write(fixture_path, first_yaml)

    Widget.delete_all
    ActiveRecord::FixtureSet.create_fixtures(fixture_dir, "widgets")

    second = YAML.safe_load(Dbreap::Reap.build_yml("widgets"))

    expect(second["widgets_001"]["name"]).to eq("alpha")
    expect(second["widgets_002"]["name"]).to eq("beta")
    expect(second["widgets_003"]["name"]).to eq("gamma")
  end
end
