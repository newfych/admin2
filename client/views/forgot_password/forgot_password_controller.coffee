@ForgotPasswordController = RouteController.extend(
	template: "ForgotPassword"
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

	data: ->
		params: @params or {}


#DATA_FUNCTION
	onAfterAction: ->
)