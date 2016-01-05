@AdminUsersController = RouteController.extend(
	template: 'Admin'
	yieldTemplates: 'AdminUsers': to: 'AdminSubcontent'

	action: ->
		if @isReady()
			@render()
		else
			@render 'Admin'
			@render 'loading', to: 'AdminSubcontent'

	isReady: ->
		subs = [ Meteor.subscribe('admin_users') ]
		ready = true
		_.each subs, (sub) ->
			if !sub.ready()
				ready = false
		ready

	data: ->
		{
		params: @params or {}
		admin_users: Users.find({}, {})
		}
)
