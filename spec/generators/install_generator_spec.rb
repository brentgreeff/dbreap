require "rails_helper"
require "rails/generators"
require "rails/generators/testing/behavior"
require "rails/generators/testing/setup_and_teardown"
require "generators/dbreap/install/install_generator"

RSpec.describe Dbreap::Generators::InstallGenerator do
  include Rails::Generators::Testing::Behavior
  include FileUtils

  tests Dbreap::Generators::InstallGenerator
  destination File.expand_path("../../tmp/generator", __dir__)

  before { prepare_destination }

  let(:seeds_path)    { File.join(destination_root, "db/seeds.rb") }
  let(:fixtures_path) { File.join(destination_root, "db/fixtures") }

  describe "creates db/fixtures/" do
    before { run_generator }

    it { expect(File.directory?(fixtures_path)).to be true }
  end

  describe "empty seeds.rb" do
    before { run_generator }

    it "creates db/seeds.rb" do
      expect(File.exist?(seeds_path)).to be true
    end

    it "contains the fixture loader" do
      expect(File.read(seeds_path)).to include("ActiveRecord::FixtureSet.create_fixtures")
    end
  end

  describe "existing seeds.rb" do
    before do
      FileUtils.mkdir_p(File.join(destination_root, "db"))
      File.write(seeds_path, "# existing seeds\n")
      run_generator
    end

    it "appends without overwriting existing content" do
      content = File.read(seeds_path)
      expect(content).to include("# existing seeds")
      expect(content).to include("ActiveRecord::FixtureSet.create_fixtures")
    end
  end
end
