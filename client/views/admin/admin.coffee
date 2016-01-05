Template.Admin.rendered = ->

Template.Admin.events {}
Template.Admin.helpers {}
Template.AdminSideMenu.rendered = ->
	$(".menu-item-collapse .dropdown-toggle").each ->
		$(this).removeClass "collapsed"  if $(this).find("li.active")
		$(this).parent().find(".collapse").each ->
			$(this).addClass "in"  if $(this).find("li.active").length



Template.AdminSideMenu.events "click .toggle-text": (e, t) ->
	e.preventDefault()
	$(e.target).closest("ul").toggleClass "menu-hide-text"

Template.AdminSideMenu.helpers {}