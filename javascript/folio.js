/*
 * Folio
 * Showcase your open source repos on GitHub
 *
 * Copyright (c) 2014 SoftLayer, an IBM Company
 * Released under the MIT license
 *
 */

(function($, undefined_) {
  var addRepo, addRepos, repoDescription, repoDescriptions, repoUrl, repoUrls;

  repoUrl = function(repo) {
    return repoUrls[repo.name] || repo.html_url;
  };

  repoDescription = function(repo) {
    return repoDescriptions[repo.name] || repo.description;
  };

  addRepo = function(repo) {
    var $item, $link;
    $item = $("<li>").addClass("repo grid-1 " + (repo.language || "").toLowerCase());
    $link = $("<a>").attr("href", repoUrl(repo)).appendTo($item);
    $link.append($("<h3>").text(repo.name));
    $link.append($("<p>").text(repoDescription(repo)));
    $link.append($("<h4>").text(repo.language));
    $item.appendTo("#repos");
  };

  addRepos = function(repos, page) {
    var uri;
    repos = repos || [];
    page = page || 1;
    uri = "https://api.github.com/orgs/softlayer/repos?callback=?" + "&per_page=100" + "&page=" + page;
    return $.getJSON(uri, function(result) {
      if (result.data && result.data.length > 0) {
        repos = repos.concat(result.data);
        return addRepos(repos, page + 1);
      } else {
        return $(function() {
          $("#json-repos").text(repos.length);
          $.each(repos, function(i, repo) {
            var createdDelta, pushDelta, weekHalfLife, weightForPush, weightForWatchers;
            repo.pushed_at = new Date(repo.pushed_at);
            weekHalfLife = 1.146 * Math.pow(10, -9);
            pushDelta = (new Date) - Date.parse(repo.pushed_at);
            createdDelta = (new Date) - Date.parse(repo.created_at);
            weightForPush = 1;
            weightForWatchers = 1.314 * Math.pow(10, 7);
            repo.hotness = weightForPush * Math.pow(Math.E, -1 * weekHalfLife * pushDelta);
            return repo.hotness += weightForWatchers * repo.watchers / createdDelta;
          });
          repos.sort(function(a, b) {
            if (a.hotness < b.hotness) {
              return 1;
            }
            if (b.hotness < a.hotness) {
              return -1;
            }
          });
          $.each(repos, function(i, repo) {
            return addRepo(repo);
          });
          return repos.sort(function(a, b) {
            if (a.pushed_at < b.pushed_at) {
              return 1;
            }
            if (b.pushed_at < a.pushed_at) {
              return -1;
            }
          });
        });
      }
    });
  };

  repoUrls = {
    "": ""
  };

  repoDescriptions = {
    "": ""
  };
  addRepos();

  $.getJSON("https://api.github.com/orgs/softlayer/members?callback=?", function(result) {
    var members;
    members = result.data;
    return $(function() {
      $("#json-members").text(members.length);
    });
  });
  return $.getJSON("https://api.github.com/repos/softlayer/jumpgate/contributors?callback=?", function(result) {
    var sponsors;
    sponsors = result.data;
    return $(function() {
      $("#json-contributors").text(sponsors.length);
    });
  });
})(jQuery);
