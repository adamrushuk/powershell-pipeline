// Declarative pipeline
// https://jenkins.io/doc/book/pipeline/syntax/#compare
pipeline {
  agent {
    kubernetes {
      containerTemplate {
        name 'psjenkinsagent'
        image 'adamrushuk/psjenkinsagent:2020-02-14'
        ttyEnabled true
        command 'cat'
        // Set to 'true' if using 'latest' for your container image
        alwaysPullImage true
      }
    }
  }

  parameters {
    string name: 'REPO_API_KEY', defaultValue: '', description: 'Enter your API key', trim: true
    string name: 'REPO_URL', defaultValue: '', description: 'Enter your repository URL (NuGet Feed)', trim: true
  }

  environment {
    REPO_NAME = "nexus"
  }

  options {
    ansiColor('xterm')
  }

  stages {

    stage('Build') {
      options {
        timeout(time: 1, unit: 'HOURS')
      }
      steps {
        sh """
          env | sort
          pwsh -NoProfile -NoLogo -NonInteractive -File ./Build/build.ps1 -ResolveDependency -TaskList Publish
        """
      }
    }

  } // stages

  post {
    always {
      archiveArtifacts allowEmptyArchive: true, artifacts: '**/*PSvCloud*.zip'
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
