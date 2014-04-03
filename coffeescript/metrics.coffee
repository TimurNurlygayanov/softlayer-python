#
# * Metrics
# * Fetch payloads asynchronously from recent milestones and code commits
# *
# * Copyright (c) 2014 SoftLayer, an IBM Company
# * Released under the MIT license
#

month = [
  "Jan"
  "Feb"
  "Mar"
  "Apr"
  "May"
  "Jun"
  "Jul"
  "Aug"
  "Sep"
  "Oct"
  "Nov"
  "Dec"
]

# Fetch date and title from last milestone in a "closed" state
$.ajax
  url: "https://api.github.com/repos/softlayer/softlayer-python/milestones?state=closed/callback?"
  dataType: "jsonp"
  success: (json) ->
    lastMilestone = json.data[0]
    stamp = new Date(lastMilestone.updated_at)
    stampString = month[stamp.getMonth()] + " " + stamp.getDate()
    $("#json-closed").text stampString
    $("#json-milestone").text lastMilestone.title

# Fetch date from last commit record in a "closed" state
$.ajax
  url: "https://api.github.com/repos/softlayer/softlayer-python/commits?state=closed/callback?"
  dataType: "jsonp"
  success: (json) ->
    lastCommit = json.data[0]
    stamp = new Date(lastCommit.commit.committer.date)
    stampString = month[stamp.getMonth()] + " " + stamp.getDate()
    $("#json-pushed").text stampString

# Fetch last pegged tag
$.ajax
  url: "https://api.github.com/repos/softlayer/softlayer-python/tags?callback?"
  dataType: "jsonp"
  success: (json) ->
    lastTag = json.data[0]
    $("#json-tag").text lastTag.name
