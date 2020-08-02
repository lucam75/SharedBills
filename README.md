# Shared Bills Application

Shared bills is a personal project to keep track of my individual and shared expenses, is a Lightning application with custom objects, Dashboards and Report, Email templates, Schedule Jobs and Lightning Web Components

Additionally, I include the use of Svelte Framework inside a LWC to take advantage of the great features of Svelte.

## Installing Dreamhouse using a Scratch Org

1. Set up your environment. Follow the steps in the [Quick Start: Lightning Web Components](https://trailhead.salesforce.com/content/learn/projects/quick-start-lightning-web-components/) Trailhead project. The steps include:

    - Enable Dev Hub in your Trailhead Playground
    - Install Salesforce CLI
    - Install Visual Studio Code
    - Install the Visual Studio Code Salesforce extensions, including the Lightning Web Components extension

1. If you haven't already done so, authorize your hub org and provide it with an alias (**myhuborg** in the command below):

    ```
    sfdx force:auth:web:login -d -a myhuborg
    ```

1. Clone this repository:

    ```
    git clone https://github.com/lucam75/SharedBills
    cd SharedBills
    ```

1. Create a scratch org and provide it with an alias (**SharedBills** in the command below):

    ```
    sfdx force:org:create -s -f config/project-scratch-def.json -a SharedBills
    ```

1. Push the app to your scratch org:

    ```
    sfdx force:source:push
    ```

1. Open the scratch org:

    ```
    sfdx force:org:open
    ```


1. In App Launcher, select the **SharedBills** app.