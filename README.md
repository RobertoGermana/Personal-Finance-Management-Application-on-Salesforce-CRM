Personal Finance Management Application on Salesforce CRM
Project Overview
Welcome to the Personal Finance Management Application, a powerful tool developed for Salesforce CRM to help you keep track of your financial assets and transactions. This open-source project integrates seamlessly with GoCardless APIs, allowing you to monitor your bank accounts, credit cards, and cash balances all from within the Salesforce platform. The application is designed with user privacy in mind and provides robust features to manage and analyze your financial data effectively.

Key Features
Financial Management
The application leverages Salesforce's Sales Cloud objects to create a comprehensive financial portfolio management system. By utilizing these standard objects, users can manage their financial transactions and assets with ease. Customized visibility settings are implemented to ensure that sensitive financial information is kept private and secure.

Automated Transaction Categorization
To streamline the process of tracking and categorizing transactions, an Apex trigger is used. This trigger analyzes the description of each transaction and automatically assigns the appropriate record type and category. This automation reduces manual entry and helps maintain accurate financial records.

OAuth Authentication and API Integration
A crucial part of this project is the integration with GoCardless APIs for accessing banking data. An Apex class is implemented for OAuth authentication, managing access tokens securely. This ensures that your banking information is accessed and updated in a secure and efficient manner. Additionally, six batch processes are set up to regularly update banking data and financial reports, keeping your information current and accurate.

Agile Development and Version Control
The development process followed Agile methodology with weekly iterations to ensure continuous improvement and adaptability. Git is used for version control, facilitating a collaborative workflow and ensuring that code quality is maintained throughout the project. This approach allows for quick adjustments and enhancements based on feedback and testing.

Alerts and Reporting
To keep users informed about significant financial events, email alerts are set up for transactions of interest. The application also features custom dashboards and reports that provide insightful financial monitoring and analysis. These tools help users stay on top of their financial health and make informed decisions.
