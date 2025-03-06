job('<NAME>') {
  description('<DESCRIPTION>')
  logRotator {
		numToKeep(<BUILDS_TO_KEEP>)
		daysToKeep(<BUILD_DAYS_TO_KEEP>)
	}	
  wrappers {
    preBuildCleanup()
  }
  steps {
    <COPY_ARTIFACTS>
  }
  publishers {
    allure(['out'])
  }
}  
