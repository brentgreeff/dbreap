module Dbreap
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Sets up db/seeds.rb and db/fixtures/ for dbreap."

      def create_fixtures_directory
        empty_directory "db/fixtures"
      end

      def install_seeds
        seeds_path = File.join(destination_root, "db/seeds.rb")
        if File.exist?(seeds_path) && !File.read(seeds_path).strip.empty?
          append_to_file "db/seeds.rb", "\n" + File.read(File.join(self.class.source_root, "seeds.rb"))
          say "Appended dbreap seed loader to db/seeds.rb", :green
        else
          copy_file "seeds.rb", "db/seeds.rb"
          say "Created db/seeds.rb", :green
        end
      end
    end
  end
end
