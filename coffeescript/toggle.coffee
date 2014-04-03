#
# * Toggle
# * Enables and animates toggling for the sidebar menu
# *
# * Copyright (c) 2014 SoftLayer, an IBM Company
# * Released under the MIT license
#

$("#sidebar-button").click (e) ->
  e.preventDefault()
  $("#sidebar-wrapper").toggleClass "active"
  return

$("#sidebar-toggle").click (e) ->
  e.preventDefault()
  $("#sidebar-wrapper").toggleClass "active"
  return

$("#sidebar-button").click (e) ->
  e.preventDefault()
  $("#sidebar-wrapper").toggleClass "active"
  return

$ ->
  $("a[href*=#]:not([href=#])").click ->
    if location.pathname.replace(/^\//, "") is @pathname.replace(/^\//, "") or location.hostname is @hostname
      target = $(@hash)
      target = (if target.length then target else $("[name=" + @hash.slice(1) + "]"))
      if target.length
        $("html,body").animate
          scrollTop: target.offset().top
        , 1000
        false

  return
