# Manually run the PSake Build tasks
.\Build\build.ps1 -TaskList 'Init'
.\Build\build.ps1 -TaskList 'Clean'
.\Build\build.ps1 -TaskList 'CombineFunctionsAndStage'
.\Build\build.ps1 -TaskList 'Analyze'
.\Build\build.ps1 -TaskList 'Test'
.\Build\build.ps1 -TaskList 'UpdateDocumentation'
.\Build\build.ps1 -TaskList 'CreateBuildArtifact' -Verbose
