Template.layout.rendered = ->

# scroll to anchor
	$("body").on "click", "a", (e) ->
		href = $(this).attr("href")
		return  unless href
		if href.length > 1 and href.charAt(0) is "#"
			hash = href.substring(1)
			if hash
				e.preventDefault()
				offset = $("*[id=\"" + hash + "\"]").offset()
				if offset
					$("html,body").animate
						scrollTop: offset.top - 60
					, 400
		else
			$("html,body").scrollTop 0  if href.indexOf("http://") isnt 0 and href.indexOf("https://") isnt 0 and href.indexOf("#") isnt 0

#TEMPLATE_RENDERED_CODE

# PUBLIC LEFT MENU

Template.PublicLayoutLeftMenu.rendered = ->
	$(".menu-item-collapse .dropdown-toggle").each ->
		$(this).removeClass "collapsed"  if $(this).find("li.active")
		$(this).parent().find(".collapse").each ->
			$(this).addClass "in"  if $(this).find("li.active").length

Template.PublicLayoutLeftMenu.events "click .toggle-text": (e, t) ->
	e.preventDefault()
	$(e.target).closest("ul").toggleClass "menu-hide-text"

Template.PublicLayoutLeftMenu.helpers {}

# PUBLIC RIGHT MENU

Template.PublicLayoutRightMenu.rendered = ->
	$(".menu-item-collapse .dropdown-toggle").each ->
		$(this).removeClass "collapsed"  if $(this).find("li.active")
		$(this).parent().find(".collapse").each ->
			$(this).addClass "in"  if $(this).find("li.active").length

Template.PublicLayoutRightMenu.events "click .toggle-text": (e, t) ->
	e.preventDefault()
	$(e.target).closest("ul").toggleClass "menu-hide-text"

Template.PublicLayoutRightMenu.helpers {}

# PRIVATE LEFT MENU

Template.PrivateLayoutLeftMenu.rendered = ->
	$(".menu-item-collapse .dropdown-toggle").each ->
		$(this).removeClass "collapsed"  if $(this).find("li.active")
		$(this).parent().find(".collapse").each ->
			$(this).addClass "in"  if $(this).find("li.active").length

Template.PrivateLayoutLeftMenu.events "click .toggle-text": (e, t) ->
	e.preventDefault()
	$(e.target).closest("ul").toggleClass "menu-hide-text"

Template.PrivateLayoutLeftMenu.helpers {}

# PRIVATE RIGHT MENU

Template.PrivateLayoutRightMenu.rendered = ->
	$(".menu-item-collapse .dropdown-toggle").each ->
		$(this).removeClass "collapsed"  if $(this).find("li.active")
		$(this).parent().find(".collapse").each ->
			$(this).addClass "in"  if $(this).find("li.active").length

Template.PrivateLayoutRightMenu.events "click .toggle-text": (e, t) ->
	e.preventDefault()
	$(e.target).closest("ul").toggleClass "menu-hide-text"

Template.PrivateLayoutRightMenu.helpers {}