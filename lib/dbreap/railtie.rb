module Dbreap
  class Railtie < Rails::Railtie
    rake_tasks do
      load "db/reap.rake"
      load "db/empty.rake"
    end
  end
end
