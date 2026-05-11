require "rails_helper"

RSpec.describe Dbreap::Reap do
  let(:fixture_path) { File.expand_path("../fixtures/expected/widgets.yml", __dir__) }

  let!(:widget) do
    create(:widget,
      name:           "sprocket",
      quantity:       5,
      price:          9.99,
      active:         true,
      description:    "A fine sprocket",
      tags:           ["ruby", "gem"],
      metadata:       { "color" => "silver", "weight" => 42 },
      numeric_string: "123",
      created_at:     Time.utc(2024, 1, 1, 12, 0, 0),
      updated_at:     Time.utc(2024, 1, 1, 12, 0, 0)
    )
  end

  before { Widget.where.not(id: widget.id).delete_all }

  describe ".build_yml" do
    subject(:output) { YAML.safe_load(described_class.build_yml("widgets")) }

    it "keys rows as table_001, table_002, ..." do
      expect(output.keys).to eq(["widgets_001"])
    end

    it "preserves string values" do
      expect(output["widgets_001"]["name"]).to eq("sprocket")
    end

    it "preserves integer values" do
      expect(output["widgets_001"]["quantity"]).to eq(5)
    end

    it "preserves float values" do
      expect(output["widgets_001"]["price"]).to eq(9.99)
    end

    it "preserves boolean values (SQLite stores as 1/0)" do
      expect(output["widgets_001"]["active"]).to eq(1)
    end

    it "parses JSON arrays" do
      expect(output["widgets_001"]["tags"]).to eq(["ruby", "gem"])
    end

    it "parses JSON objects" do
      expect(output["widgets_001"]["metadata"]).to eq({ "color" => "silver", "weight" => 42 })
    end

    it "does not cast numeric strings to integers" do
      expect(output["widgets_001"]["numeric_string"]).to eq("123")
    end
  end

  describe ".cast_value" do
    it "returns strings as-is" do
      expect(described_class.cast_value("hello")).to eq("hello")
    end

    it "returns nil as nil" do
      expect(described_class.cast_value(nil)).to be_nil
    end

    it "parses JSON arrays" do
      expect(described_class.cast_value('["a","b"]')).to eq(["a", "b"])
    end

    it "parses JSON objects" do
      expect(described_class.cast_value('{"k":"v"}')).to eq({ "k" => "v" })
    end

    it "returns [] for empty JSON array" do
      expect(described_class.cast_value("[]")).to eq([])
    end

    it "returns {} for empty JSON object" do
      expect(described_class.cast_value("{}")).to eq({})
    end

    it "does not cast numeric strings" do
      expect(described_class.cast_value("123")).to eq("123")
    end

    it "does not cast boolean strings" do
      expect(described_class.cast_value("true")).to eq("true")
    end
  end

  describe "fixture match" do
    it "matches the expected YAML fixture" do
      actual   = YAML.safe_load(described_class.build_yml("widgets"))
      expected = YAML.safe_load(File.read(fixture_path))
      expect(actual.transform_values { |r| r.except("id") })
        .to eq(expected.transform_values { |r| r.except("id") })
    end
  end
end
