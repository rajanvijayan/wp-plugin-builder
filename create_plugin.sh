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

    # Create plugin directory structure
    mkdir -p "$plugin_slug/src" "$plugin_slug/vendor" "$plugin_slug/languages" "$plugin_slug/assets/css" "$plugin_slug/assets/js" "$plugin_slug/assets/images" "$plugin_slug/templates" "$plugin_slug/tests"

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

if ( ! defined( 'ABSPATH' ) ) {
    exit; // Exit if accessed directly.
}

// PSR-4 autoloading
require __DIR__ . '/vendor/autoload.php';

use $vendor_name\\Core\\Main;

// Initialize the plugin
Main::init();
EOL

    # Create Core Main class file
    mkdir -p "$plugin_slug/src/Core"
    cat <<EOL > "$plugin_slug/src/Core/Main.php"
<?php

namespace $vendor_name\\Core;

class Main {
    public static function init() {
        // Add your initialization code here
        add_action('init', [__CLASS__, 'setup']);
    }

    public static function setup() {
        // Add your setup code here
    }
}
EOL

    # Create composer.json if required
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
            "$vendor_name\\\\": "src/"
        }
    },
    "require": {}
}
EOL
    fi

    echo "WordPress plugin '$plugin_name' created successfully."
}

# Call the function with the provided argument
create_plugin "$1"
