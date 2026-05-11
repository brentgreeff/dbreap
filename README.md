# dbreap

Share essential database records between developers, staging, and demo environments.

The idea: curate data in your database the way you normally would — through the UI or console — then reap it to YAML fixtures and commit those files. Teammates, staging, and demo servers can seed from them with a single command.

## Installation

```ruby
# Gemfile
gem "dbreap"
```

## Workflow

### 1. Create your data

Set up the records you want to share however you like — through the Rails console, the app UI, or seeds. Get it looking exactly right.

### 2. Reap to YAML

```bash
# Reap specific tables
rake db:reap FIXTURES=products,categories

# Reap everything
rake db:reap FIXTURES=ALL
```

Fixtures are written to `db/fixtures/<env>/`. Commit these files.

### 3. Seed on another machine

```bash
# Clear existing data, then seed from fixtures
rake db:empty
rake db:seed
```

`db:seed` uses Rails' standard `db/seeds.rb`. Run the install generator to set it up:

```bash
rails generate dbreap:install
```

This creates `db/fixtures/` and installs the seed loader into `db/seeds.rb` (appends if the file already exists).

## Rake tasks

| Task | Description |
|------|-------------|
| `rake db:reap FIXTURES=ALL` | Reap all tables to YAML |
| `rake db:reap FIXTURES=t1,t2` | Reap specific tables |
| `rake db:empty` | Delete all rows from all tables (preserves schema) |

## Notes

- Fixture files are ordered by `id` — reap → seed → reap produces identical output
- JSON columns are preserved as structured data
- String columns containing numeric values (e.g. `"123"`) are not cast to integers
- `schema_migrations` and `ar_internal_metadata` are always skipped
