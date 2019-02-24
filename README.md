# PowerShell Pipeline Example

This is a Proof of Concept repo to show how you can build CI/CD pipeline for a PowerShell module.

The example is an old PowerShell module I started for VMware vCloud Director.

[![Build Status](https://adamrushuk.visualstudio.com/PoC/_apis/build/status/PowerShellPipeline?branchName=master)](https://adamrushuk.visualstudio.com/PoC/_build/latest?definitionId=22&branchName=master)

## Goals

I've created various scripts for vCloud Director over the past few years, so I plan to use this module as an opportunity to refactor and share these scripts one by one. I'll apply the latest methods and best practices I've learnt recently, with a focus on the process around [The Release Pipeline Model](https://msdn.microsoft.com/en-us/powershell/dsc/whitepapers#the-release-pipeline-model) (Source > Build > Test > Release).

### Source

Use Git with the practical [common flow](https://commonflow.org/) branching model.

### Build

Use [psake](https://github.com/psake/psake) to develop build scripts that can be used both locally using [Task Runners in Visual Studio Code](https://code.visualstudio.com/docs/editor/tasks), and by a CI/CD system like [Azure DevOps](https://azure.microsoft.com/en-gb/services/devops/).

This will cover:

- Compiling separate function files into a single .psm1 module.
- Automatically updating documentation in Markdown, ready for a 3rd-party like
[ReadTheDocs](https://docs.readthedocs.io/en/latest/).

### Test

Test the compiled code for known issues and ensure it aligns to defined standards.

This will cover:

- Code analysis using `PSScriptAnalyzer`.
- Code testing (unit, and common) using `Pester`.

### Release

Publish the module build artifact to an Azure DevOps Artifacts (NuGet) feed.
