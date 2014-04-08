#
# * Metrics
# * Fetch payloads asynchronously for milestones, commits, tags, members, contributors, and repos
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

# Date and title from last milestone in a "closed" state
$.ajax
  url: "https://api.github.com/repos/softlayer/softlayer-python/milestones?state=closed/callback?"
  dataType: "jsonp"
  success: (json) ->
    lastMilestone = json.data[0]
    stamp = new Date(lastMilestone.updated_at)
    stampString = month[stamp.getMonth()] + " " + stamp.getDate()
    $("#date-milestone").text stampString
    $("#name-milestone").text lastMilestone.title
    return


# Date from last commit record in a "closed" state
$.ajax
  url: "https://api.github.com/repos/softlayer/softlayer-python/commits?state=closed/callback?"
  dataType: "jsonp"
  success: (json) ->
    lastCommit = json.data[0]
    stamp = new Date(lastCommit.commit.committer.date)
    stampString = month[stamp.getMonth()] + " " + stamp.getDate()
    $("#date-commit").text stampString
    return

# Number for last release/tag
$.ajax
  url: "https://api.github.com/repos/softlayer/softlayer-python/tags?callback?"
  dataType: "jsonp"
  success: (json) ->
    lastTag = json.data[0]
    $("#num-version").text lastTag.name
    return

# Number of team members
$.getJSON "https://api.github.com/orgs/softlayer/members?callback=?", (result) ->
  members = result.data
  $ ->
    $("#num-members").text members.length
    return
  return

# Number of contributors
$.getJSON "https://api.github.com/repos/softlayer/softlayer-python/contributors?callback=?", (result) ->
  contributors = result.data
  $ ->
    $("#num-contributors").text contributors.length
    return
  return

# Number of repos
$.getJSON "https://api.github.com/orgs/jumpgate/repos?callback=?", (result) ->
  repositories = result.data
  $ ->
    $("#num-repo").text repositories.length
    return
  return
