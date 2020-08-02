# Shared Bills Application

Shared bills is a personal project to keep track of my individual and shared expenses, borns from the necessity to keep track of shared expenses easily without unnecessary or complicated stuff. With a mobile-first approach, SB takes advantage of the LWC framework to allow complex data entry in a natural way.

The goal is to keep track of the daily expenses specifying who paid and if it's shared or individual, at the end of the month, a report is generated and send it via email with the summary of each user expense and status of who owes money to whom.

## Tech
- Salesforce: Lightning application with custom objects, Dashboards and Report, Email templates, Schedule Jobs and Apex classes. - Lightning Web Components: To allow data entry easily from mobile phones.
- Svelte: POC. Take advantage of the greate features of Svelte, like the reactivity, to create great UI with less code. It's used to provide the current and historical status of the end month debts.


## Features
The Shared Bills app provides the following features:

- Support up to 2 people to shared expenses and keep track of them
- End month summary of your expenses in your email.
- Status at the end of the month, useful for couples who share expenses and want to know who owes money to whom.
- Mobile-friendly data entry with an LWC to create both individual or shared bills.
- Ability yo specify the expense category, account, and event to handle a good enough granularity.


## Installing SharedBills using a Scratch Org

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
1. Create master objects data like Categories, Accounts, Contacts and Events.
1. Start tracking your expenses using either Salesforce standard Record creation or the LWC to create Shared Bills