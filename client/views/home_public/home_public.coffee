Template.HomePublicHomeJumbotron.events "click #jumbotron-button": (e, t) ->
	e.preventDefault()
	Router.go "login", {}
