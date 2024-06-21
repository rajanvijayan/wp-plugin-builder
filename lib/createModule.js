const inquirer = require('inquirer');
const fs = require('fs-extra');
const path = require('path');

const createModule = async (pluginName, moduleName) => {
    const { vendorName } = await inquirer.prompt([
        { type: 'input', name: 'vendorName', message: 'Vendor Name', default: 'src' }
    ]);

    const pluginSlug = pluginName.replace(/ /g, '-');
    const modulePath = path.join(process.cwd(), pluginSlug, 'src', moduleName);
    const namespace = moduleName.replace(/\//g, '\\');

    if (await fs.pathExists(modulePath)) {
        console.error(`Module '${moduleName}' already exists inside plugin '${pluginName}'.`);
        process.exit(1);
    }

    await fs.ensureDir(modulePath);

    const moduleClassName = moduleName.split('/').pop();
    const moduleClassContent = `<?php

namespace ${vendorName}\\${namespace};

class ${moduleClassName} {
    public function __construct() {
        // Module constructor code here
    }
}
`;

    await fs.outputFile(path.join(modulePath, `${moduleClassName}.php`), moduleClassContent);
    console.log(`Module '${moduleName}' created successfully inside plugin '${pluginName}'.`);
};

module.exports = { createModule };
