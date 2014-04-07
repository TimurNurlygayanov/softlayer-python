#
# * Up
# * Shows and hides scrollability back to top
# *
# * Copyright (c) 2014 SoftLayer, an IBM Company
# * Released under the MIT license
#

pageOffset = document.documentElement.scrollTop or document.body.scrollTop

scrollTo = (element, to, duration) ->
  start = element.scrollTop
  change = to - start
  currentTime = 0
  increment = 20
  animateScroll = ->
    currentTime += increment
    val = Math.easeInOutQuad(currentTime, start, change, duration)
    element.scrollTop = val
    setTimeout animateScroll, increment  if currentTime < duration
    return

  animateScroll()
  return
window.onscroll = ->
  if pageYOffset >= 200
    document.getElementById("scroll-up").style.visibility = "visible"
  else
    document.getElementById("scroll-up").style.visibility = "hidden"
  return

document.getElementById("scroll-up").onclick = ->
  scrollTo document.body, 0, 0
  return

#t = current time
#b = start value
#c = change in value
#d = duration
Math.easeInOutQuad = (t, b, c, d) ->
  t /= d / 2
  return c / 2 * t * t + b  if t < 1
  t--
  -c / 2 * (t * (t - 2) - 1) + b
