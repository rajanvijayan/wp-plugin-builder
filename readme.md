# wp-plugin-builder

`wp-plugin-builder` is a CLI tool designed to streamline the creation of WordPress plugins and modules using the PSR-4 model. It provides an easy way to generate a standardized plugin structure and PSR-4 compliant modules within your plugins.

## Installation

To install `wp-plugin-builder`, you need to have [Node.js](https://nodejs.org/) and [npm](https://www.npmjs.com/) installed on your machine. Once you have them, you can install `wp-plugin-builder` globally using the following command:

``` bash
npm install -g wp-plugin-builder
```
## Usage

### Create a New Plugin

To create a new WordPress plugin, use the `create plugin` command followed by the plugin name. This command will prompt you for additional information such as Vendor Name, Project Description, Plugin URL, Author Name, and Author URL.

```
builder create plugin my_plugin_name
```
#### Example
```
$ builder create plugin my_plugin_name
Vendor Name (default: src): 
Is required package.json? (default: no): yes
Project Description (default: A WordPress Plugin): My custom WordPress plugin
Plugin URL: https://example.com
Author Name: John Doe
Author URL: https://example.com/johndoe
```
### Create a New Module

To create a new module within an existing plugin, use the `create module` command followed by the plugin name and module name. This command will prompt you for the Vendor Name.
```
builder create module my_plugin_name Post/Meta
```
## Templates

The plugin structure is generated using templates located in the `templates` directory:

-   `main_plugin_file.template`: Template for the main plugin file.
-   `core_main_class.template`: Template for the core Main class.
-   `composer_json.template`: Template for the composer.json file.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any changes or improvements.

## Contact

If you have any questions, feel free to reach out:

-   Email: me@rajanvijayan.com
-   GitHub: [rajanvijayan](https://github.com/rajanvijayan)