const inquirer = require('inquirer');
const fs = require('fs-extra');
const path = require('path');

const templatesDir = path.join(__dirname, '../templates');

const createPlugin = async (pluginName) => {
    const { vendorName, requirePackageJson, projectDescription, pluginUrl, authorName, authorUrl } = await inquirer.prompt([
        { type: 'input', name: 'vendorName', message: 'Vendor Name', default: 'src' },
        { type: 'confirm', name: 'requirePackageJson', message: 'Is required package.json?', default: false },
        { type: 'input', name: 'projectDescription', message: 'Project Description', default: 'A WordPress Plugin' },
        { type: 'input', name: 'pluginUrl', message: 'Plugin URL' },
        { type: 'input', name: 'authorName', message: 'Author Name' },
        { type: 'input', name: 'authorUrl', message: 'Author URL' },
    ]);

    const pluginSlug = pluginName.replace(/ /g, '-');
    const pluginDir = path.join(process.cwd(), pluginSlug);

    // Create plugin directory structure
    await fs.ensureDir(path.join(pluginDir, 'src'));
    await fs.ensureDir(path.join(pluginDir, 'vendor'));
    await fs.ensureDir(path.join(pluginDir, 'languages'));
    await fs.ensureDir(path.join(pluginDir, 'assets/css'));
    await fs.ensureDir(path.join(pluginDir, 'assets/js'));
    await fs.ensureDir(path.join(pluginDir, 'assets/images'));
    await fs.ensureDir(path.join(pluginDir, 'templates'));
    await fs.ensureDir(path.join(pluginDir, 'tests'));

    // Read and write the main plugin file
    let mainPluginFile = await fs.readFile(path.join(templatesDir, 'main_plugin_file.template'), 'utf8');
    mainPluginFile = mainPluginFile.replace(/{{PLUGIN_NAME}}/g, pluginName)
        .replace(/{{PROJECT_DESCRIPTION}}/g, projectDescription)
        .replace(/{{PLUGIN_URL}}/g, pluginUrl)
        .replace(/{{AUTHOR_NAME}}/g, authorName)
        .replace(/{{AUTHOR_URL}}/g, authorUrl)
        .replace(/{{PLUGIN_SLUG}}/g, pluginSlug)
        .replace(/{{VENDOR_NAME}}/g, vendorName);
    await fs.outputFile(path.join(pluginDir, `${pluginSlug}.php`), mainPluginFile);

    // Read and write the Core Main class file
    let coreMainClass = await fs.readFile(path.join(templatesDir, 'core_main_class.template'), 'utf8');
    coreMainClass = coreMainClass.replace(/{{VENDOR_NAME}}/g, vendorName);
    await fs.outputFile(path.join(pluginDir, 'src/Core/Main.php'), coreMainClass);

    // Create composer.json if required
    if (requirePackageJson) {
        let composerJson = await fs.readFile(path.join(templatesDir, 'composer_json.template'), 'utf8');
        composerJson = composerJson.replace(/{{PLUGIN_SLUG}}/g, pluginSlug)
            .replace(/{{PROJECT_DESCRIPTION}}/g, projectDescription)
            .replace(/{{AUTHOR_NAME}}/g, authorName)
            .replace(/{{AUTHOR_URL}}/g, authorUrl)
            .replace(/{{VENDOR_NAME}}/g, vendorName);
        await fs.outputFile(path.join(pluginDir, 'composer.json'), composerJson);
    }

    console.log(`WordPress plugin '${pluginName}' created successfully.`);
};

module.exports = { createPlugin };
