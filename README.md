# Automated Testing Template

## Purpose

The purpose of this repo is to create a template for quick deployment of North Highland's Automation Solution

### Run tests

To run on BrowserStack use the `remote` command
To run on a local machine use the `local` command

### Run all features

`npm run remote --features`

`npm run local --features`

### Run a specific tag

`npm run remote -- --grep "@test"`

`npm run local -- --grep "@test"`
