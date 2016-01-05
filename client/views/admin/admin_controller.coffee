@AdminController = RouteController.extend(
	template: 'Admin'
	yieldTemplates: {}

	action: ->
		@redirect 'admin.users', @params or {}, replaceState: true

	isReady: ->
		subs = []
		ready = true
		_.each subs, (sub) ->
			if !sub.ready()
				ready = false
		ready
	data: ->
		{ params: @params or {} }
)