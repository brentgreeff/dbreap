# dbreap

[![CI](https://github.com/brentgreeff/dbreap/actions/workflows/ci.yml/badge.svg)](https://github.com/brentgreeff/dbreap/actions/workflows/ci.yml)

Namespaced seed data - saved in YML. Much easier to see what's going on with your seed data than a bunch of ruby code that no-one maintains.

Share essential database records between developers, staging, and demo environments.

## Installation

```ruby
# Gemfile
gem "dbreap"
```

```bash
bundle install
rails generate dbreap:install
```

This creates `db/fixtures/` and installs the seed loader into `db/seeds.rb` (appends if the file already exists).

## Workflow

### 1. Create your data

Working on a new feature - Does having some example data help other developers on dev work with and test your new code in the UI?

Create your data in the UI or console - and commit the seed YML alongside the feature code.

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

`db:seed` uses Rails' standard `db/seeds.rb`, configured by the install generator.

## Rake tasks

| Task | Description |
|------|-------------|
| `rake db:reap FIXTURES=ALL` | Reap all tables to YAML |
| `rake db:reap FIXTURES=t1,t2` | Reap specific tables |
| `rake db:empty` | Delete all rows from all tables (preserves schema) |

## Development

```bash
bundle install
bundle exec lefthook install  # installs pre-commit hooks
bundle exec rspec
```

## Notes

- Fixture files are ordered by `id` — reap → seed → reap produces identical output
- JSON columns are preserved as structured data
- String columns containing numeric values (e.g. `"123"`) are not cast to integers
- `schema_migrations` and `ar_internal_metadata` are always skipped
- `db:empty` uses `DELETE` (not `TRUNCATE`) — schema and sequences are preserved, no DDL lock
- Run `db:empty` before `db:seed` to avoid duplicate records on repeated seeds
- Fixture files are namespaced by environment (`db/fixtures/<env>/`) — development, staging, and demo data can coexist
