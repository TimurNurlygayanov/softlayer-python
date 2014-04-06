#
# * Folio
# * Showcase your open source repos on GitHub
# *
# * Copyright (c) 2014 SoftLayer, an IBM Company
# * Released under the MIT license
#

(($, undefined_) ->

  repoUrl = (repo) ->
    repoUrls[repo.name] or repo.html_url

  repoDescription = (repo) ->
    repoDescriptions[repo.name] or repo.description

  addRepo = (repo) ->
    $item = $("<li>").addClass("repo grid-1 " + (repo.language or "").toLowerCase())
    $link = $("<a>").attr("href", repoUrl(repo)).appendTo($item)
    $link.append $("<h3>").text(repo.name)
    $link.append $("<p>").text(repoDescription(repo))
    $link.append $("<h4>").text(repo.language)
    $item.appendTo "#repos"
    return

  addRepos = (repos, page) ->
    repos = repos or []
    page = page or 1
    uri = "api.github.com/orgs/softlayer/repos?callback=?"
    $.getJSON uri, (result) ->
      if result.data and result.data.length > 0
        repos = repos.concat(result.data)
        addRepos repos, page + 1
      else
        $ ->
          $("#gh-repos").text repos.length
          $.each repos, (i, repo) ->

            # converts pushed_at to Date
            repo.pushed_at = new Date(repo.pushed_at)
            weekHalfLife = 1.146 * Math.pow(10, -9)
            pushDelta = (new Date) - Date.parse(repo.pushed_at)
            createdDelta = (new Date) - Date.parse(repo.created_at)
            weightForPush = 1
            weightForWatchers = 1.314 * Math.pow(10, 7)
            repo.hotness = weightForPush * Math.pow(Math.E, -1 * weekHalfLife * pushDelta)
            repo.hotness += weightForWatchers * repo.watchers / createdDelta

          repos.sort (a, b) -> # Sort by highest # of watchers
            return 1  if a.hotness < b.hotness
            return -1  if b.hotness < a.hotness

          $.each repos, (i, repo) ->
            addRepo repo

          repos.sort (a, b) -> # Sort by most-recently pushed to
            return 1  if a.pushed_at < b.pushed_at
            return -1  if b.pushed_at < a.pushed_at

  # Drop in any repo names & URL's here if it's not listed under your organization
  repoUrls = "": ""

  # Drop in the same repo names as above and include the repo description here
  repoDescriptions = "": ""

  addRepos()

  # Number of team members
  $.getJSON "api.github.com/orgs/softlayer/members?callback=?", (result) ->
    members = result.data
    $ ->
      $("#gh-members-total").text members.length
      return

  # Number of contributors
  $.getJSON "api.github.com/repos/softlayer/softlayer-python/contributors?callback=?", (result) ->
    contributors = result.data
    $ ->
      $("#gh-contributors-total").text contributors.length
      return

) jQuery
