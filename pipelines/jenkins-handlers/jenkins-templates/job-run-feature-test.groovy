job('<NAME>') {
  description('<DESCRIPTION>')
  displayName('<DISPLAY_NAME>')

  logRotator {
		numToKeep(<BUILDS_TO_KEEP>)
		daysToKeep(<BUILD_DAYS_TO_KEEP>)
	}

	properties {
    copyArtifactPermissionProperty {
      projectNames('/<REPORT_JOB>')
    }

  }
  scm {
		git {
			branch('main')
				remote {
					github('<GITHUB_URL>')
					credentials('<GITHUB_CREDENTIALS>')
				}
		}
	}
  wrappers {
    nodejs('default node')
    credentialsBinding {

    }
	browserStackBuildWrapper {
		credentialsId('<BROWSERSTACK_CREDENTIALS>')
	}
  }
  steps {
		shell (
			'''chmod 775 ./pipelines/build_steps/run-test.sh
			./pipelines/build_steps/run-test.sh --feature_file_name <FEATURE_FILE>'''
		)

  }
  publishers {

    allure(['out'])
	browserStackReportPublisher()
	archiveArtifacts('<INCLUDE_PATTERN>')
	downstream('<REPORT_JOB>', 'FAILURE')
	cleanWs {
      cleanWhenAborted(true)
      cleanWhenFailure(true)
      cleanWhenNotBuilt(false)
      cleanWhenSuccess(true)
      cleanWhenUnstable(true)
      deleteDirs(true)
      notFailBuild(true)
    }
  }
  
}
