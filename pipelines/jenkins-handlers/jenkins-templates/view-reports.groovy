listView('Reports') {
  description('Full reports of test results per browser. This view is auto-generated. DO NOT MAKE CHANGES TO THIS VIEW.') 	  	
  recurse()
  jobFilters {
    regex {
      matchType(MatchType.INCLUDE_MATCHED)
      matchValue(RegexMatchValue.NAME)
      regex('.*Report*.')
	  }
  }		
  columns {
    status()
    weather()
 	  name()
    lastSuccess()
    lastFailure()
    lastDuration()
    buildButton()
  }			
}
  
