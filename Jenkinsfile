// Declarative pipeline
// https://jenkins.io/doc/book/pipeline/syntax/#compare
pipeline {
  agent {
    kubernetes {
      containerTemplate {
        name 'psjenkinsagent'
        image 'adamrushuk/psjenkinsagent:2020-01-25'
        ttyEnabled true
        command 'cat'
        alwaysPullImage true
      }
    }
  }

  // parameters {}

  // environment {}

  options {
    ansiColor('xterm')
  }

  stages {

    stage('Build') {
      options {
        timeout(time: 1, unit: 'HOURS')
      }
      steps {
        pwsh(script: './Build/build.ps1 -ResolveDependency -TaskList Init')
        pwsh(script: './Build/build.ps1 -TaskList CombineFunctionsAndStage')
        pwsh(script: './Build/build.ps1 -TaskList Analyze')
        pwsh(script: './Build/build.ps1 -TaskList Test')
        pwsh(script: './Build/build.ps1 -TaskList UpdateDocumentation')
        pwsh(script: './Build/build.ps1 -TaskList CreateBuildArtifact')
      }
    }

  } // stages

  post {
    always {
      archiveArtifacts allowEmptyArchive: true, artifacts: '**/*_pester-test-results.xml'
      junit allowEmptyResults: true, testResults: '**/*_pester-test-results.xml'
    }
    // success {
    // }
    // failure {
    // }
    // aborted {
    // }
  }

} // pipeline
