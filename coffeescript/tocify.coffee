#
# * Tocify
# * A ridiculously simple TOC generator for built-in content navigation
# *
# * Copyright (c) 2014 SoftLayer, an IBM Company
# * Released under the MIT license
#

(($) ->

  $.fn.tocify = (options) ->
    defaults =
      showSpeed: "slow"

    settings = $.extend(defaults, options)
    headers = $("h1").filter(->
      @id # ropes in all h1 headings with an ID
    )

    output = $(this)
    return  if not headers.length or headers.length < 3 or not output.length
    get_level = (ele) ->
      parseInt ele.nodeName.replace("H", ""), 10

    highest_level = headers.map((_, ele) ->
      get_level ele
    ).get().sort()[0]

    level = get_level(headers[0])
    this_level = undefined
    html = ""
    headers.on("click", ->
      window.location.hash = @id
      return
    ).addClass("clickable-header").each (_, header) ->
      this_level = get_level(header)
      $(header).addClass "top-level-header"  if this_level is highest_level

      # same level and indenting as before
      html += "<li><a href='#" + header.id + "'>" + header.innerHTML + "</a>"  if this_level is level

      # and onto the next one
      level = this_level
      return

    if 0 isnt settings.showSpeed
      output.hide().html(html).show settings.showSpeed
    else
      output.html html
    return

  return

) jQuery
