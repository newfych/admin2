@HomePrivateController = RouteController.extend(
	template: "HomePrivate"
	yieldTemplates: {}

#YIELD_TEMPLATES
	onBeforeAction: ->
		@next()

	action: ->
		if @isReady()
			@render()
		else
			@render "loading"


#ACTION_FUNCTION
	isReady: ->
		subs = []
		ready = true
		_.each subs, (sub) ->
			ready = false  unless sub.ready()
		ready
)