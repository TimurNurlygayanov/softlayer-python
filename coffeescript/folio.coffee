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
    uri = undefined
    repos = repos or []
    page = page or 1
    uri = "https://api.github.com/orgs/softlayer/repos?callback=?" + "&per_page=40" + "&page=" + page
    $.getJSON uri, (result) ->

      if result.data and result.data.length > 0
        repos = repos.concat(result.data)
        addRepos repos, page + 1

      else
        $ ->
          $("#content-repos").text repos.length
          $.each repos, (i, repo) ->
            createdDelta = undefined
            pushDelta = undefined
            weekHalfLife = undefined
            weightForPush = undefined
            weightForWatchers = undefined
            repo.pushed_at = new Date(repo.pushed_at)
            weekHalfLife = 1.146 * Math.pow(10, -9)
            pushDelta = ("new Date") - Date.parse(repo.pushed_at)
            createdDelta = ("new Date") - Date.parse(repo.created_at)
            weightForPush = 1
            weightForWatchers = 1.314 * Math.pow(10, 7)
            repo.hotness = weightForPush * Math.pow(Math.E, -1 * weekHalfLife * pushDelta)
            repo.hotness += weightForWatchers * repo.watchers / createdDelta

          repos.sort (a, b) ->  # Sorts by recently pushed_to
            return 1  if a.hotness < b.hotness
            -1  if b.hotness < a.hotness

          $.each repos, (i, repo) ->
            addRepo repo

          repos.sort (a, b) ->
            return 1  if a.pushed_at < b.pushed_at
            -1  if b.pushed_at < a.pushed_at

  repoUrls = "": ""           # Drop in any repo names & URL's here if it's not listed under your organization
  repoDescriptions = "": ""   # Drop in the same repo names as above and include the repo description here

  addRepos()

  # Number of team members
  $.getJSON "https://api.github.com/orgs/softlayer/members?callback=?", (result) ->
    members = undefined
    members = result.data
    $ ->
      $("#total-members").text members.length
      return

  # Number of contributors
  $.getJSON "https://api.github.com/repos/softlayer/softlayer-python/contributors?callback=?", (result) ->
    contributors = undefined
    contributors = result.data
    $ ->
      $("#total-contributors").text contributors.length
      return

) jQuery
