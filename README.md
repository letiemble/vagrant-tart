# VagrantPlugins::Tart

Vagrant-tart is a [Vagrant](http://www.vagrantup.com) plugin that adds a
[Tart](https://tart.run/) provider to Vagrant, allowing Vagrant to
control and provision machines via Tart command line tool.

## Installation & Usage

Refer to the [documentation](https://letiemble.github.io/vagrant-tart/) for detailed installation and usage instructions.

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `bundle exec rake spec` to run the tests.

To install this gem into your local Vagrant installation, run:

```bash
bundle exec rake build
bundle exec vagrant plugin install ./pkg/vagrant-tart-$VERSION.gem
bundle exec vagrant plugin list
```

Once the plugin is installed, you can use Vagrant with the Tart provider.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/letiemble/vagrant-tart. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/letiemble/vagrant-tart/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the VagrantPlugins::Tart project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/letiemble/vagrant-tart/blob/main/CODE_OF_CONDUCT.md).
