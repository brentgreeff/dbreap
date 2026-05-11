namespace :db do
  desc "Deletes everything in the database."
  task empty: :environment do
    Dbreap::Empty.call
  end
end
