#!/usr/bin/env node

const { createPlugin } = require('./lib/createPlugin');
const { createModule } = require('./lib/createModule');

const main = async () => {
    const [,, command, type, name, subName] = process.argv;

    if (command !== 'create' || (type !== 'plugin' && type !== 'module') || !name) {
        console.error('Invalid command. Usage: builder create {plugin|module} {name}');
        process.exit(1);
    }

    if (type === 'plugin') {
        await createPlugin(name);
    } else if (type === 'module') {
        if (!subName) {
            console.error('Module name is required. Usage: builder create module {plugin_name} {module_name}');
            process.exit(1);
        }
        await createModule(name, subName);
    }
};

main().catch(error => {
    console.error(error);
    process.exit(1);
});
