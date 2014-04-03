#
# * Bookends
# * Provides scrollability for the paralax-like content up/down buttons
# *
# * Copyright (c) 2014 SoftLayer, an IBM Company
# * Released under the MIT license
#

pageOffset = document.documentElement.scrollTop or document.body.scrollTop

window.onscroll = ->
  if pageOffset >= 500
    document.getElementById("scroll-up").style.visibility = "visible"
  else
    document.getElementById("scroll-up").style.visibility = "hidden"
  return
