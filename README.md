# cloudmux-cookbook

Setup and installation of Transcend Computing's [CloudMux](https://github.com/TranscendComputing/CloudMux)

## Supported Platforms

Ubuntu-12.04

## Attributes

- `node['cloudmux']['ruby_version']` - Defaults to '1.9.3-p484'
- `node['cloudmux']['home']` - Defaults to '/home/cloudmux'
- `node['cloudmux']['git_revision']` - Defaults to 'master'
- `node['cloudmux']['environment']` - Defaults to 'development' (or node.chef_environment if not '_default')
- `node['cloudmux']['db_user']` - Defaults to 'mongo'
- `node['cloudmux']['db_password']` - Defaults to 'mongo'
- `node['cloudmux']['mongo_port']` - Defaults to 27017

## Usage

### cloudmux::default

Include `cloudmux` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[cloudmux::default]"
  ]
}
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: TranscendComputing (<cstewart@momentumsi.com>)
