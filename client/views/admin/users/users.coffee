pageSession = new ReactiveDict()
Template.AdminUsers.rendered = ->

Template.AdminUsers.events {}
Template.AdminUsers.helpers {}
AdminUsersViewItems = (cursor) ->
	return []  unless cursor
	searchString = pageSession.get("AdminUsersViewSearchString")
	sortBy = pageSession.get("AdminUsersViewSortBy")
	sortAscending = pageSession.get("AdminUsersViewSortAscending")
	sortAscending = true  if typeof (sortAscending) is "undefined"
	raw = cursor.fetch()

	# filter
	filtered = []
	if not searchString or searchString is ""
		filtered = raw
	else
		searchString = searchString.replace(".", "\\.")
		regEx = new RegExp(searchString, "i")
		searchFields = [ "profile.name", "profile.email", "roles" ]
		filtered = _.filter(raw, (item) ->
			match = false
			_.each searchFields, (field) ->
				value = (getPropertyValue(field, item) or "") + ""
				match = match or (value and value.match(regEx))
				false  if match

			match
		)

	# sort
	if sortBy
		filtered = _.sortBy(filtered, sortBy)

		# descending?
		filtered = filtered.reverse()  unless sortAscending
	filtered

AdminUsersViewExport = (cursor, fileType) ->
	data = AdminUsersViewItems(cursor)
	exportFields = []
	str = convertArrayOfObjects(data, exportFields, fileType)
	filename = "export." + fileType
	downloadLocalResource str, filename, "application/octet-stream"

Template.AdminUsersView.rendered = ->
	pageSession.set "AdminUsersViewStyle", "table"

Template.AdminUsersView.events
	"submit #dataview-controls": (e, t) ->
		false

	"click #dataview-search-button": (e, t) ->
		e.preventDefault()
		form = $(e.currentTarget).parent()
		if form
			searchInput = form.find("#dataview-search-input")
			if searchInput
				searchInput.focus()
				searchString = searchInput.val()
				pageSession.set "AdminUsersViewSearchString", searchString
		false

	"keydown #dataview-search-input": (e, t) ->
		if e.which is 13
			e.preventDefault()
			form = $(e.currentTarget).parent()
			if form
				searchInput = form.find("#dataview-search-input")
				if searchInput
					searchString = searchInput.val()
					pageSession.set "AdminUsersViewSearchString", searchString
			return false
		if e.which is 27
			e.preventDefault()
			form = $(e.currentTarget).parent()
			if form
				searchInput = form.find("#dataview-search-input")
				if searchInput
					searchInput.val ""
					pageSession.set "AdminUsersViewSearchString", ""
			return false
		true

	"click #dataview-insert-button": (e, t) ->
		e.preventDefault()
		Router.go "admin.users.insert", {}

	"click #dataview-export-default": (e, t) ->
		e.preventDefault()
		AdminUsersViewExport @admin_users, "csv"

	"click #dataview-export-csv": (e, t) ->
		e.preventDefault()
		AdminUsersViewExport @admin_users, "csv"

	"click #dataview-export-tsv": (e, t) ->
		e.preventDefault()
		AdminUsersViewExport @admin_users, "tsv"

	"click #dataview-export-json": (e, t) ->
		e.preventDefault()
		AdminUsersViewExport @admin_users, "json"

Template.AdminUsersView.helpers
	isEmpty: ->
		not @admin_users or @admin_users.count() is 0

	isNotEmpty: ->
		@admin_users and @admin_users.count() > 0

	isNotFound: ->
		@admin_users and pageSession.get("AdminUsersViewSearchString") and AdminUsersViewItems(@admin_users).length is 0

	searchString: ->
		pageSession.get "AdminUsersViewSearchString"

	viewAsTable: ->
		pageSession.get("AdminUsersViewStyle") is "table"

	viewAsList: ->
		pageSession.get("AdminUsersViewStyle") is "list"

	viewAsGallery: ->
		pageSession.get("AdminUsersViewStyle") is "gallery"

Template.AdminUsersViewTable.rendered = ->

Template.AdminUsersViewTable.events "click .th-sortable": (e, t) ->
	e.preventDefault()
	oldSortBy = pageSession.get("AdminUsersViewSortBy")
	newSortBy = $(e.target).attr("data-sort")
	pageSession.set "AdminUsersViewSortBy", newSortBy
	if oldSortBy is newSortBy
		sortAscending = pageSession.get("AdminUsersViewSortAscending") or false
		pageSession.set "AdminUsersViewSortAscending", not sortAscending
	else
		pageSession.set "AdminUsersViewSortAscending", true

Template.AdminUsersViewTable.helpers tableItems: ->
	AdminUsersViewItems @admin_users

Template.AdminUsersViewTableItems.rendered = ->

Template.AdminUsersViewTableItems.events
	"click td": (e, t) ->
		e.preventDefault()
		Router.go "admin.users.details",
			userId: @_id

		false

	"click .inline-checkbox": (e, t) ->
		e.preventDefault()
		return false  if not this or not @_id
		fieldName = $(e.currentTarget).attr("data-field")
		return false  unless fieldName
		values = {}
		values[fieldName] = not this[fieldName]
		Users.update
			_id: @_id
		,
			$set: values

		false

	"click #delete-button": (e, t) ->
		e.preventDefault()
		me = this
		bootbox.dialog
			message: "Delete? Are you sure?"
			title: "Delete"
			animate: false
			buttons:
				success:
					label: "Yes"
					className: "btn-success"
					callback: ->
						Users.remove _id: me._id

				danger:
					label: "No"
					className: "btn-default"

		false

	"click #edit-button": (e, t) ->
		e.preventDefault()
		Router.go "admin.users.edit",
			userId: @_id

		false

Template.AdminUsersViewTableItems.helpers
	checked: (value) ->
		(if value then "checked" else "")

	editButtonClass: ->
		(if Users.isAdmin(Meteor.userId()) then "" else "hidden")

	deleteButtonClass: ->
		(if Users.isAdmin(Meteor.userId()) then "" else "hidden")
