/*!
 * 
 * Python Bindings
 * Boilerplate version 0.3.0, Built on 04-08-2014
 * Copyright (c) 2014 SoftLayer, an IBM Company. All rights reserved.
 * Code and documentation licensed under MIT.
 * 
 */

(function() {
  (function($) {
    var month;
    month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    $.ajax({
      url: "https://api.github.com/repos/softlayer/softlayer-python/milestones?state=closed/callback?",
      dataType: "jsonp",
      success: function(json) {
        var lastMilestone, stamp, stampString;
        lastMilestone = json.data[0];
        stamp = new Date(lastMilestone.updated_at);
        stampString = month[stamp.getMonth()] + " " + stamp.getDate();
        $("#date-milestone").text(stampString);
        return $("#name-milestone").text(lastMilestone.title);
      }
    });
    $.ajax({
      url: "https://api.github.com/repos/softlayer/softlayer-python/commits?state=closed/callback?",
      dataType: "jsonp",
      success: function(json) {
        var lastCommit, stamp, stampString;
        lastCommit = json.data[0];
        stamp = new Date(lastCommit.commit.committer.date);
        stampString = month[stamp.getMonth()] + " " + stamp.getDate();
        return $("#date-commit").text(stampString);
      }
    });
    $.ajax({
      url: "https://api.github.com/repos/softlayer/softlayer-python/tags?callback?",
      dataType: "jsonp",
      success: function(json) {
        var lastTag;
        lastTag = json.data[0];
        return $("#num-version").text(lastTag.name);
      }
    });
    $.getJSON("https://api.github.com/orgs/softlayer/members?callback=?", function(result) {
      var members;
      members = result.data;
      return $(function() {
        $("#num-members").text(members.length);
      });
    });
    return $.getJSON("https://api.github.com/repos/softlayer/softlayer-python/contributors?callback=?", function(result) {
      var contributors;
      contributors = result.data;
      return $(function() {
        $("#num-contributors").text(contributors.length);
      });
    });
  })(jquery);

}).call(this);

(function() {
  (function($) {
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
      uri = "https://api.github.com/orgs/softlayer/repos?callback=?" + "&per_page=50" + "&page=" + page;
      return $.getJSON(uri, function(result) {
        if (result.data && result.data.length > 0) {
          repos = repos.concat(result.data);
          return addRepos(repos, page + 1);
        } else {
          return $(function() {
            $("#num-repos").text(repos.length);
            $.each(repos, function(i, repo) {
              var createdDelta, pushDelta, weekHalfLife, weightForPush, weightForWatchers;
              repo.pushed_at = new Date(repo.pushed_at);
              weekHalfLife = 1.146 * Math.pow(10, -9);
              pushDelta = "new Date" - Date.parse(repo.pushed_at);
              createdDelta = "new Date" - Date.parse(repo.created_at);
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
    return addRepos();
  })(jQuery);

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

}).call(this);

(function() {
  var pageOffset, scrollTo;

  pageOffset = document.documentElement.scrollTop || document.body.scrollTop;

  scrollTo = function(element, to, duration) {
    var animateScroll, change, currentTime, increment, start;
    start = element.scrollTop;
    change = to - start;
    currentTime = 0;
    increment = 20;
    animateScroll = function() {
      var val;
      currentTime += increment;
      val = Math.easeInOutQuad(currentTime, start, change, duration);
      element.scrollTop = val;
      if (currentTime < duration) {
        setTimeout(animateScroll, increment);
      }
    };
    animateScroll();
  };

  window.onscroll = function() {
    if (pageYOffset >= 200) {
      document.getElementById("scroll-up").style.visibility = "visible";
    } else {
      document.getElementById("scroll-up").style.visibility = "hidden";
      return;
    }
    document.getElementById("scroll-up").onclick = function() {
      scrollTo(document.body, 0, 0);
    };
  };

  Math.easeInOutQuad = function(t, b, c, d) {
    t /= d / 2;
    if (t < 1) {
      return c / 2 * t * t + b;
    }
    t--;
    return -c / 2 * (t * (t - 2) - 1) + b;
  };

}).call(this);
