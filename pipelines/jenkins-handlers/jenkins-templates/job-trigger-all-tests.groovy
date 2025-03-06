job('<NAME>') {
  description('<DESCRIPTION>')
  logRotator {
		numToKeep(<BUILDS_TO_KEEP>)
		daysToKeep(<BUILD_DAYS_TO_KEEP>)
	}
	// triggers {
	// 	cron('H 4 * * *')
  // }
  publishers {
    <DOWNSTREAM>
  }
}
