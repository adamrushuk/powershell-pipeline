# PowerShell Pipeline Example

This is a Proof of Concept repo to show how you can build CI/CD pipeline for a PowerShell module.

The example is an old PowerShell module I started for VMware vCloud Director.

[![Build status](https://ci.appveyor.com/api/projects/status/4n5tvb1qj1ieq4jv?svg=true)](https://ci.appveyor.com/project/adamrushuk/psvcloud)

## Goals

I've created various scripts for vCloud Director over the past few years, so I plan to use this module as an opportunity to refactor and share these scripts one by one. I'll apply the latest methods and best practices I've learnt recently, with a focus on the process around [The Release Pipeline Model](https://msdn.microsoft.com/en-us/powershell/dsc/whitepapers#the-release-pipeline-model) (Source > Build > Test > Release).

### Source

Use Git with the practical [common flow](https://commonflow.org/) branching model.

### Build

Use [psake](https://github.com/psake/psake) to develop build scripts that can be used both locally using [Task Runners in Visual Studio Code](https://code.visualstudio.com/docs/editor/tasks), and by a CI/CD system like [Azure DevOps](https://azure.microsoft.com/en-gb/services/devops/).

### Test

Use [Pester](https://github.com/pester/Pester) for Unit Testing.

### Release

Configure [Azure DevOps](https://azure.microsoft.com/en-gb/services/devops/) for Continuous Integration / Continuous Deployment.

This will cover:
- Release to the [PowerShell Gallery](https://www.powershellgallery.com/packages/PSvCloud).
- Uploading Artifacts as a [tagged Release in GitHub](https://github.com/adamrushuk/PSvCloud/releases)
- Automatically updating documentation to a 3rd-party like [ReadTheDocs](https://docs.readthedocs.io/en/latest/).
