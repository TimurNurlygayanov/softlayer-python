#
# * Metrics
# * Fetch payloads asynchronously from GitHub
# *
# * Copyright (c) 2014 SoftLayer, an IBM Company
# * Released under the MIT license
#

###
Contents
(in alphabetical order)

1. Commits
2. Contributors
3. Members
4. Milestones
5. Pull requests
6. Repos
7. Stargazers
8. Tags
9. Watchers
###

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

# Captures URLs from config.json and put them where they belong
$.getJSON "public/js/config.json", (api) ->
  urlCommits = commits
  urlContributors = contributors
  urlMembers = members
  urlMilestones = milestones
  urlPulls = pulls
  urlRepos = repos
  urlStargazers = stargazers
  urlTags = tags
  urlWatchers = watchers
  return

# Commits (date of last commit record)
# ------------------------------
$.ajax
  url: "https://api.github.com/repos/softlayer/softlayer-python/commits?state=closed/callback?"
  dataType: "jsonp"
  success: (json) ->
    lastCommit = json.data[0]
    stamp = new Date(lastCommit.commit.committer.date)
    stampString = month[stamp.getMonth()] + " " + stamp.getDate()
    $("#date-commit").text stampString
    return

# Contributors (a count of contributors)
# ------------------------------
$.getJSON "https://api.github.com/repos/softlayer/softlayer-python/contributors?callback=?", (result) ->
  numContributors = result.data
  $ ->
    $("#num-contributors").text numContributors.length
    return
  return

# Milestones (date and title of last milestone closed)
# ------------------------------
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

# Members (a count of team members)
# ------------------------------
$.getJSON "https://api.github.com/orgs/softlayer/members?callback=?", (result) ->
  numMembers = result.data
  $ ->
    $("#num-members").text numMembers.length
    return
  return

# Pulls requests (a count of open pull requests)
# ------------------------------
$.getJSON "https://api.github.com/repos/softlayer/softlayer-python/pulls?callback=?", (result) ->
  numPulls = result.data
  $ ->
    $("#num-pulls").text numPulls.length
    return
  return

# Repos (a count of public repos)
# ------------------------------
$.getJSON "https://api.github.com/orgs/jumpgate/repos?callback=?", (result) ->
  numRepositories = result.data
  $ ->
    $("#num-repo").text numRepositories.length
    return
  return

# Stargazers (a count of stargazers)
# ------------------------------
$.getJSON "https://api.github.com/repos/softlayer/softlayer-python/stargazers?callback=?", (result) ->
  numStargazers = result.data
  $ ->
    $("#num-stargazers").text numStargazers.length
    return
  return

# Tags (number for last release/tag)
# ------------------------------
$.ajax
  url: "https://api.github.com/repos/softlayer/softlayer-python/tags?callback?"
  dataType: "jsonp"
  success: (json) ->
    lastTag = json.data[0]
    $("#num-version").text lastTag.name
    return

# Watchers (a count of watchers/subscribers)
# ------------------------------
$.getJSON "https://api.github.com/repos/softlayer/softlayer-python/subscribers?callback=?", (result) ->
  numWatchers = result.data
  $ ->
    $("#num-watchers").text numWatchers.length
    return
  return
