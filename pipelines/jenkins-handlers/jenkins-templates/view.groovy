    listView('<VIEW_NAME>') {
      description('<DESCRIPTION>') 	  	
      recurse()
      jobs{
        <JOBS>
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
      
