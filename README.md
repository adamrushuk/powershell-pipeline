# PowerShell Pipeline Example

This is a Proof of Concept repo to show how you can build CI/CD pipeline for a PowerShell module.

The example is an old PowerShell module I started for VMware vCloud Director.

## Status

[![Build Status](https://adamrushuk.visualstudio.com/PoC/_apis/build/status/PowerShellPipeline?branchName=master)](https://adamrushuk.visualstudio.com/PoC/_build/latest?definitionId=22&branchName=master)
![Dev Deployment Status](https://adamrushuk.vsrm.visualstudio.com/_apis/public/Release/badge/4ce5af3d-5ed8-4548-8eda-4237b4c67331/1/1)

Dev: [![PSvCloud package in dev feed in Azure Artifacts](https://adamrushuk.feeds.visualstudio.com/_apis/public/Packaging/Feeds/d3fe8e81-a639-44de-b162-3f0fd5ccd879/Packages/7218d060-f41d-43ab-a705-b7777f6c846d/Badge)](https://adamrushuk.visualstudio.com/PoC/_packaging?_a=package&feed=d3fe8e81-a639-44de-b162-3f0fd5ccd879&package=7218d060-f41d-43ab-a705-b7777f6c846d&preferRelease=true)

Test: [![PSvCloud package in test feed in Azure Artifacts](https://adamrushuk.feeds.visualstudio.com/_apis/public/Packaging/Feeds/8a9923df-c743-41ad-bdd2-de0bb3caed8e/Packages/0d5e2829-fa21-4a59-9fff-19f8f023d8f3/Badge)](https://adamrushuk.visualstudio.com/PoC/_packaging?_a=package&feed=8a9923df-c743-41ad-bdd2-de0bb3caed8e&package=0d5e2829-fa21-4a59-9fff-19f8f023d8f3&preferRelease=true)

Prod: [![PSvCloud package in prod feed in Azure Artifacts](https://adamrushuk.feeds.visualstudio.com/_apis/public/Packaging/Feeds/6a30e17b-fbfa-47e1-86b8-c721be74aad0/Packages/29be4e54-f5c9-4ecc-bdf1-1919507fe67c/Badge)](https://adamrushuk.visualstudio.com/PoC/_packaging?_a=package&feed=6a30e17b-fbfa-47e1-86b8-c721be74aad0&package=29be4e54-f5c9-4ecc-bdf1-1919507fe67c&preferRelease=true)

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
