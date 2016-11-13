# Pinfluence

## Installation

Make a copy of `.env.development.example` to `.env.development`, and configure the
database informations.

This is a Ruby project, so it is nice to have [RVM](https://rvm.io/) or [Rbenv](https://github.com/rbenv/rbenv) installed.

```bash
$ gem install bundler
$ bundle
```

After creating database user with database creation privilege, and
configuring `.env.development`:

```bash
$ bundle exec hanami db create
$ bundle exec hanami db migrate
```

Or, if you want to create database manually, just run:

```bash
$ bundle exec hanami db migrate
```

To run server:

```bash
$ bundle exec hanami server
```

Website will be available in [http://localhost:2300](http://localhost:2300)

## Usage

The project has three apps:

- WEB (`/`), which has all code to show public information, like Map;
- API (`/api`), is a public API which `web` app make use;
- ADMIN (`/admin`), where all informations are registered. This is a restrict area.

When you run the server, you run the entire project.

To create an access to admin, just create an user using `hanami console`:

```bash
$ bundle exec hanami console

new_admin = User.new(name: "Admin name", email: "login@email.com", password: "admin_password")
UserRepository.create new_admin
```

And done. You now have access to local admin area.

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## License

Copyright © 2016 Rafael Soares – Released under MIT License
