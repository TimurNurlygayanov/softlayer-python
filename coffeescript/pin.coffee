#
# * Pin
# * Watches and pins subnav content as user scrolls
# *
# * Copyright (c) 2014 SoftLayer, an IBM Company
# * Released under the MIT license
#

not ($) ->
  $ ->
    if navigator.userAgent.match(/IEMobile\/10\.0/)
      msViewportStyle = document.createElement("style")
      msViewportStyle.appendChild document.createTextNode("@-ms-viewport{width:auto!important}")
      document.getElementsByTagName("head")[0].appendChild msViewportStyle
    $window = $(window)
    $body = $(document.body)
    navHeight = $("").outerHeight(true) + 10
    $body.scrollspy
      target: ".subnav"
      offset: navHeight

    $window.on "load", ->
      $body.scrollspy "refresh"
      return

    $(".content [href=#]").click (e) ->
      e.preventDefault()
      return

    setTimeout (->
      $subNav = $(".subnav")
      $subNav.affix offset:
        top: ->
          offsetTop = $subNav.offset().top
          subNavMargin = parseInt($subNav.children(0).css("margin-top"), 10)
          navOuterHeight = $(".header").height()
          @top = offsetTop - navOuterHeight - subNavMargin

        bottom: ->
          @bottom = $(".footer").outerHeight(true)

      return
    ), 100
    setTimeout (->
      $(".top").affix()
      return
    ), 100
    return

  return
(window.jQuery)
