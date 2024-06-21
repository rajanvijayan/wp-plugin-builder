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

    # Read template for main plugin file
    main_plugin_file=$(<templates/main_plugin_file.template)
    main_plugin_file=${main_plugin_file//\{\{PLUGIN_NAME\}\}/$plugin_name}
    main_plugin_file=${main_plugin_file//\{\{PROJECT_DESCRIPTION\}\}/$project_description}
    main_plugin_file=${main_plugin_file//\{\{PLUGIN_URL\}\}/$plugin_url}
    main_plugin_file=${main_plugin_file//\{\{AUTHOR_NAME\}\}/$author_name}
    main_plugin_file=${main_plugin_file//\{\{AUTHOR_URL\}\}/$author_url}
    main_plugin_file=${main_plugin_file//\{\{PLUGIN_SLUG\}\}/$plugin_slug}
    main_plugin_file=${main_plugin_file//\{\{VENDOR_NAME\}\}/$vendor_name}
    
    echo "$main_plugin_file" > "$plugin_slug/$plugin_slug.php"

    # Read template for Core Main class file
    core_main_class=$(<templates/core_main_class.template)
    core_main_class=${core_main_class//\{\{VENDOR_NAME\}\}/$vendor_name}
    
    echo "$core_main_class" > "$plugin_slug/src/Core/Main.php"

    # Create composer.json if required
    if [ "$require_package_json" == "yes" ]; then
        composer_json=$(<templates/composer_json.template)
        composer_json=${composer_json//\{\{PLUGIN_SLUG\}\}/$plugin_slug}
        composer_json=${composer_json//\{\{PROJECT_DESCRIPTION\}\}/$project_description}
        composer_json=${composer_json//\{\{AUTHOR_NAME\}\}/$author_name}
        composer_json=${composer_json//\{\{AUTHOR_URL\}\}/$author_url}
        composer_json=${composer_json//\{\{VENDOR_NAME\}\}/$vendor_name}
        
        echo "$composer_json" > "$plugin_slug/composer.json"
    fi

    echo "WordPress plugin '$plugin_name' created successfully."
}

# Call the function with the provided argument
create_plugin "$1"
