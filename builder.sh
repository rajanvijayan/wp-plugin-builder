#!/bin/bash

# Function to create plugin
create_plugin() {
    local plugin_name=$1
    local plugin_slug=${plugin_name// /-}

    # Prompt for Vendor Name
    read -p "Vendor Name (default: src): " vendor_name
    vendor_name=${vendor_name:-src}

    # Prompt for package.json requirement
    read -p "Is required package.json? (default: no): " require_package_json
    require_package_json=${require_package_json:-no}

    # Prompt for Project Description
    read -p "Project Description (default: A WordPress Plugin): " project_description
    project_description=${project_description:-"A WordPress Plugin"}

    # Prompt for Plugin URL
    read -p "Plugin URL: " plugin_url

    # Prompt for Author Name
    read -p "Author Name: " author_name

    # Prompt for Author URL
    read -p "Author URL: " author_url

    # Create plugin directory
    mkdir -p "$plugin_slug/$vendor_name"

    # Create main plugin file
    cat <<EOL > "$plugin_slug/$plugin_slug.php"
<?php
/**
 * Plugin Name: $plugin_name
 * Description: $project_description
 * Plugin URI: $plugin_url
 * Author: $author_name
 * Author URI: $author_url
 * Text Domain: $plugin_slug
 * Domain Path: /languages
 */

// PSR-4 autoloader
spl_autoload_register(function (\$class) {
    \$prefix = '$vendor_name\\';
    \$base_dir = __DIR__ . '/$vendor_name/';
    \$len = strlen(\$prefix);
    if (strncmp(\$prefix, \$class, \$len) !== 0) {
        return;
    }
    \$relative_class = substr(\$class, \$len);
    \$file = \$base_dir . str_replace('\\\\', '/', \$relative_class) . '.php';
    if (file_exists(\$file)) {
        require \$file;
    }
});
EOL

    # Create composer.json if package.json is required
    if [ "$require_package_json" == "yes" ]; then
        cat <<EOL > "$plugin_slug/composer.json"
{
    "name": "$plugin_slug",
    "description": "$project_description",
    "type": "wordpress-plugin",
    "authors": [
        {
            "name": "$author_name",
            "homepage": "$author_url"
        }
    ],
    "autoload": {
        "psr-4": {
            "$vendor_name\\\\": "$vendor_name/"
        }
    },
    "require": {}
}
EOL
    fi

    echo "WordPress plugin '$plugin_name' created successfully."
}

# Function to create module inside plugin
create_module() {
    local plugin_name=$1
    local module_name=$2
    local module_path=$plugin_name/$module_name

    # Create module directory
    mkdir -p "$module_path"

    # Create example module class file
    local module_class_name=$(echo "$module_name" | awk -F/ '{print $NF}')
    cat <<EOL > "$module_path/$module_class_name.php"
<?php

namespace $module_name;

class $module_class_name {
    public function __construct() {
        // Module constructor code here
    }
}
EOL

    echo "Module '$module_name' created successfully inside plugin '$plugin_name'."
}

# Main script logic
case "$1" in
    create)
        case "$2" in
            plugin)
                create_plugin "$3"
                ;;
            module)
                create_module "$3" "$4"
                ;;
            *)
                echo "Invalid command. Usage: builder.sh create {plugin|module} {name}"
                ;;
        esac
        ;;
    *)
        echo "Invalid command. Usage: builder.sh create {plugin|module} {name}"
        ;;
esac
