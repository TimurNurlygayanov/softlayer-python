/*!
 * 
 * softlayer-python
 * Version 0.0.1, Built on 04-02-2014
 * Copyright (c) 2014 SoftLayer, an IBM Company. All rights reserved.
 * Code and documentation licensed under MIT.
 * 
 */

(function() {
  (function() {
    var console, length, method, methods, noop;
    method = void 0;
    noop = function() {};
    methods = ["assert", "clear", "count", "debug", "dir", "dirxml", "error", "exception", "group", "groupCollapsed", "groupEnd", "info", "log", "markTimeline", "profile", "profileEnd", "table", "time", "timeEnd", "timeStamp", "trace", "warn"];
    length = methods.length;
    console = (window.console = window.console || {});
    while (length--) {
      method = methods[length];
      if (!console[method]) {
        console[method] = noop;
      }
    }
  })();

}).call(this);

(function() {
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

}).call(this);

(function() {
  module.exports = function() {
    var month, site;
    site = this.file.readYAML("../_config.yml");
    this.initConfig(site);
    month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    $.ajax({
      url: "<%= site:api:milestones %>",
      dataType: "jsonp",
      success: function(json) {
        var lastMilestone, stamp, stampString;
        lastMilestone = json.data[0];
        stamp = new Date(lastMilestone.updated_at);
        stampString = month[stamp.getMonth()] + " " + stamp.getDate();
        $("#json-closed").text(stampString);
        return $("#json-milestone").text(lastMilestone.title);
      }
    });
    $.ajax({
      url: "https://api.github.com/repos/softlayer/jumpgate/commits?state=closed/callback?",
      dataType: "jsonp",
      success: function(json) {
        var lastCommit, stamp, stampString;
        lastCommit = json.data[0];
        stamp = new Date(lastCommit.commit.committer.date);
        stampString = month[stamp.getMonth()] + " " + stamp.getDate();
        return $("#json-pushed").text(stampString);
      }
    });
    return $.ajax({
      url: "https://api.github.com/repos/softlayer/softlayer-python/tags?callback?",
      dataType: "jsonp",
      success: function(json) {
        var lastTag;
        lastTag = json.data[0];
        return $("#json-tag").text(lastTag.name);
      }
    });
  };

}).call(this);

(function() {
  (function($) {
    $.fn.tocify = function(options) {
      var defaults, get_level, headers, highest_level, html, level, output, settings, this_level;
      defaults = {
        showSpeed: "slow"
      };
      settings = $.extend(defaults, options);
      headers = $("h1").filter(function() {
        return this.id;
      });
      output = $(this);
      if (!headers.length || headers.length < 3 || !output.length) {
        return;
      }
      get_level = function(ele) {
        return parseInt(ele.nodeName.replace("H", ""), 10);
      };
      highest_level = headers.map(function(_, ele) {
        return get_level(ele);
      }).get().sort()[0];
      level = get_level(headers[0]);
      this_level = void 0;
      html = "";
      headers.on("click", function() {
        window.location.hash = this.id;
      }).addClass("clickable-header").each(function(_, header) {
        this_level = get_level(header);
        if (this_level === highest_level) {
          $(header).addClass("top-level-header");
        }
        if (this_level === level) {
          html += "<li><a href='#" + header.id + "'>" + header.innerHTML + "</a>";
        }
        level = this_level;
      });
      if (0 !== settings.showSpeed) {
        output.hide().html(html).show(settings.showSpeed);
      } else {
        output.html(html);
      }
    };
  })(jQuery);

}).call(this);

(function() {
  $("#sidebar-button").click(function(e) {
    e.preventDefault();
    $("#sidebar-wrapper").toggleClass("active");
  });

  $("#sidebar-toggle").click(function(e) {
    e.preventDefault();
    $("#sidebar-wrapper").toggleClass("active");
  });

  $("#sidebar-button").click(function(e) {
    e.preventDefault();
    $("#sidebar-wrapper").toggleClass("active");
  });

  $(function() {
    $("a[href*=#]:not([href=#])").click(function() {
      var target;
      if (location.pathname.replace(/^\//, "") === this.pathname.replace(/^\//, "") || location.hostname === this.hostname) {
        target = $(this.hash);
        target = (target.length ? target : $("[name=" + this.hash.slice(1) + "]"));
        if (target.length) {
          $("html,body").animate({
            scrollTop: target.offset().top
          }, 1000);
          return false;
        }
      }
    });
  });

}).call(this);
