folder('<NAME>') {
    displayName('<DISPLAY_NAME>')
    description('<DESCRIPTION>')
      configure { project ->            	
        project / healthMetrics / 'com.cloudbees.hudson.plugins.folder.health.WorstChildHealthMetric' / nonRecursive << 'false'
    }
}
