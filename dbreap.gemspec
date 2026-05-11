require_relative "lib/dbreap/version"

Gem::Specification.new do |spec|
  spec.name        = "dbreap"
  spec.version     = Dbreap::VERSION
  spec.authors     = ["Brent Greeff"]
  spec.email       = ["brent@example.com"]
  spec.summary     = "Reap database records to YAML fixtures and seed them back."
  spec.homepage    = "https://github.com/brentgreeff/dbreap"
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 3.3"

  spec.metadata = {
    "source_code_uri" => "https://github.com/brentgreeff/dbreap",
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:spec|test)/}) }
  end

  spec.add_dependency "activerecord", ">= 7.0"
  spec.add_dependency "railties",     ">= 7.0"
end
