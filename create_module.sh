#!/bin/bash

# Function to create module inside plugin
create_module() {
    local plugin_name=$1
    local module_name=$2
    local plugin_slug=${plugin_name// /-}
    local module_path="$plugin_slug/src/$module_name"

    # Prompt for Vendor Name
    read -p "Vendor Name (default: src): " vendor_name
    vendor_name=${vendor_name:-src}

    # Replace slashes with backslashes for namespace
    local namespace=$(echo "$module_name" | sed 's/\//\\/g')

    # Check if module already exists
    if [ -d "$module_path" ]; then
        echo "Module '$module_name' already exists inside plugin '$plugin_name'."
        exit 1
    fi

    # Create module directory
    mkdir -p "$module_path"

    # Create example module class file
    local module_class_name=$(echo "$module_name" | awk -F/ '{print $NF}')
    cat <<EOL > "$module_path/$module_class_name.php"
<?php

namespace $vendor_name\\$namespace;

class $module_class_name {
    public function __construct() {
        // Module constructor code here
    }
}
EOL

    echo "Module '$module_name' created successfully inside plugin '$plugin_name'."
}

# Call the function with the provided arguments
create_module "$1" "$2"
