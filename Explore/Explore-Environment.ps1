# Explore Environment Variables

get-childitem env:
get-childitem env:*

get-childitem env:user
get-childitem env:user*

get-childitem env:*user*

get-childitem env:*config*
get-childitem env:*git*

get-childitem env:* | sort-object name