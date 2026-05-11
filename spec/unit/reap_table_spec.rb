require "rails_helper"

RSpec.describe "Dbreap::Reap.write_fixture" do
  let(:fixture_dir) { Dir.mktmpdir }

  before do
    Widget.delete_all
    create(:widget, name: "sprocket", quantity: 5)
    FileUtils.mkdir_p("#{fixture_dir}/db/fixtures/test")
  end

  after { FileUtils.remove_entry(fixture_dir) }

  it "writes a YAML file to db/fixtures/<env>/<table>.yml" do
    Dbreap::Reap.write_fixture("widgets", root: fixture_dir, env: "test")
    expect(File).to exist("#{fixture_dir}/db/fixtures/test/widgets.yml")
  end

  it "file contains the reaped rows" do
    Dbreap::Reap.write_fixture("widgets", root: fixture_dir, env: "test")
    data = YAML.safe_load(File.read("#{fixture_dir}/db/fixtures/test/widgets.yml"))
    expect(data["widgets_001"]["name"]).to eq("sprocket")
  end

  it "strips trailing whitespace from each line" do
    Dbreap::Reap.write_fixture("widgets", root: fixture_dir, env: "test")
    lines = File.readlines("#{fixture_dir}/db/fixtures/test/widgets.yml")
    expect(lines).to all(satisfy { |l| l == l.rstrip + "\n" || l == "\n" })
  end

  it "prints the table name to stdout" do
    expect { Dbreap::Reap.write_fixture("widgets", root: fixture_dir, env: "test") }
      .to output(/Reaped widgets/).to_stdout
  end
end
