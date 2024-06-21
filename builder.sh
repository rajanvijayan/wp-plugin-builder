#!/bin/bash

# Main script logic
case "$1" in
    create)
        case "$2" in
            plugin)
                ./create_plugin.sh "$3"
                ;;
            module)
                ./create_module.sh "$3" "$4"
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
