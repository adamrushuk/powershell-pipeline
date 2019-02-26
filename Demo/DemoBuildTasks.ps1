# Manually run the PSake Build tasks
# Initialise
.\Build\build.ps1 -TaskList 'Init'


# Clean the Artifact and Staging folders
.\Build\build.ps1 -TaskList 'Clean'


# Create a single .psm1 module file containing all functions
# Copy new module and other supporting files (Documentation / Examples) to Staging folder
.\Build\build.ps1 -TaskList 'CombineFunctionsAndStage'


# Run PSScriptAnalyzer against code to ensure quality and best practices are used
.\Build\build.ps1 -TaskList 'Analyze'


# Run Pester tests
# Unit tests: verify inputs / outputs / expected execution path
# Misc tests: verify manifest data, check comment-based help exists
.\Build\build.ps1 -TaskList 'Test'


# Create new Documentation markdown files from comment-based help
.\Build\build.ps1 -TaskList 'UpdateDocumentation'


# Create a versioned zip file of all staged files
.\Build\build.ps1 -TaskList 'CreateBuildArtifact' -Verbose
