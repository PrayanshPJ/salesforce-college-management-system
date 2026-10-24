# Salesforce College Management System

A Salesforce-based College Management System designed to organize student, faculty, course, subject, and enrollment information using Salesforce objects, Flow automation, Apex triggers, reports, and dashboards.

## Overview

The project demonstrates how Salesforce CRM capabilities can be used to manage academic records and automate common college administration workflows.

## Features

- **Student Management:** Maintain student records and statuses.
- **Faculty Management:** Organize faculty information.
- **Course Management:** Manage academic courses.
- **Subject Management:** Maintain subject records and statuses.
- **Enrollment Management:** Track student enrollments in subjects.
- **Automated Enrollment Confirmation:** Send confirmation emails when enrollments are created.
- **Student Status Automation:** Update related active enrollments when a student's status changes.
- **Subject Status Automation:** Update related active enrollments when a subject becomes inactive.
- **Apex Validation:** Prevent duplicate student-subject enrollments and enforce applicable student and subject status rules.
- **Reports and Dashboards:** Present enrollment, student, faculty, program, and academic performance information.

## Salesforce Data Model

The five core custom objects are:

| Object | API Name |
|---|---|
| Student | `Student__c` |
| Faculty | `Faculty__c` |
| Course | `Course__c` |
| Subject | `Subject__c` |
| Enrollment | `Enrollment__c` |

The project also contains additional retrieved metadata. The relationships and configuration should be reviewed in Salesforce Setup before reproducing the application in another org.

## Automation

The repository includes these Flow metadata files:

- `Enrollment_Confirmation_Flow`
- `Student_Status_Enrollment_Update`
- `Subject_Status_Enrollment_Update`
- `Faculty_Status_Active_Subject_Review`

The Enrollment Apex trigger delegates business logic to `EnrollmentTriggerHandler`. Apex test classes are included for testing the relevant functionality.

## Technology Stack

- Salesforce Platform
- Salesforce Flow Builder
- Apex
- Salesforce DX
- Salesforce CLI
- Visual Studio Code
- Git and GitHub
- SOQL

## Repository Structure

```text
force-app/
└── main/
    └── default/
        ├── applications/
        ├── classes/
        ├── flexipages/
        ├── flows/
        ├── layouts/
        ├── objects/
        ├── permissionsets/
        ├── tabs/
        └── triggers/
manifest/
└── package.xml
```

## Prerequisites

- A Salesforce development org with appropriate permissions
- Salesforce CLI
- Visual Studio Code
- Salesforce Extension Pack for VS Code
- Git

## Setup

### 1. Clone the repository

```bash
git clone https://github.com/YOUR-USERNAME/salesforce-college-management-system.git
cd salesforce-college-management-system
```

Replace `YOUR-USERNAME` with the GitHub account that hosts the repository.

### 2. Authorize your Salesforce org

```bash
sf org login web --alias CollegeOrg --instance-url https://login.salesforce.com
```

For a sandbox, use the appropriate Salesforce sandbox login URL.

### 3. Retrieve or deploy metadata

To retrieve the metadata specified in the manifest:

```bash
sf project retrieve start --manifest manifest/package.xml --target-org CollegeOrg
```

To deploy the metadata to a compatible target org, review the manifest and dependencies first, then use:

```bash
sf project deploy start --manifest manifest/package.xml --target-org CollegeOrg
```

**Important:** Review the manifest before deployment. This repository may contain metadata unrelated to the College Management System, and some components may require dependencies or org-specific configuration.

## Testing

Run the Apex test suite in your authorized org:

```bash
sf apex run test --target-org CollegeOrg --result-format human --wait 10
```

Review the test results before deploying to a production org.

## Security Notes

- Never commit Salesforce access tokens, passwords, private keys, or local authentication files.
- Review permissions, sharing settings, and object-level and field-level security before using the application with real student data.
- Use fictional or anonymized records in screenshots and demonstrations.

## Future Improvements

- Improve role-based access and security validation.
- Add further academic reporting and enrollment analytics.
- Improve user experience with Lightning Web Components.
- Add automated deployment and testing workflows.

## Author

**Prayansh Jain**
B.Tech Computer Science — Artificial Intelligence and Machine Learning
LNCT Group of Colleges, Bhopal, Madhya Pradesh, India

## Disclaimer

This project is intended for educational and demonstration purposes. Validate metadata dependencies, permissions, and automation behavior before deploying it to another Salesforce org.
