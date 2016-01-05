Router.configure
	templateNameConverter: "upperCamelCase"
	routeControllerNameConverter: "upperCamelCase"
	layoutTemplate: "layout"
	notFoundTemplate: "notFound"
	loadingTemplate: "loading"

publicRoutes = [ "home_public", "login", "register", "verify_email", "forgot_password", "reset_password" ]
privateRoutes = [ "home_private", "admin", "admin.users", "admin.users.details", "admin.users.insert", "admin.users.edit", "user_settings", "user_settings.profile", "user_settings.change_pass", "logout", "screens" ]
freeRoutes = []
roleMap = [
	route: "admin"
	roles: [ "admin" ]
,
	route: "admin.users"
	roles: [ "admin" ]
,
	route: "admin.users.details"
	roles: [ "admin" ]
,
	route: "admin.users.insert"
	roles: [ "admin" ]
,
	route: "admin.users.edit"
	roles: [ "admin" ]
,
	route: "user_settings"
	roles: [ "user", "admin" ]
,
	route: "user_settings.profile"
	roles: [ "user", "admin" ]
,
	route: "user_settings.change_pass"
	roles: [ "user", "admin" ]
]
@firstGrantedRoute = (preferredRoute) ->
	return preferredRoute  if preferredRoute and routeGranted(preferredRoute)
	grantedRoute = ""
	_.every privateRoutes, (route) ->
		if routeGranted(route)
			grantedRoute = route
			return false
		true

	return grantedRoute  if grantedRoute
	_.every publicRoutes, (route) ->
		if routeGranted(route)
			grantedRoute = route
			return false
		true

	return grantedRoute  if grantedRoute
	_.every freeRoutes, (route) ->
		if routeGranted(route)
			grantedRoute = route
			return false
		true

	return grantedRoute  if grantedRoute

	# what to do?
	console.log "All routes are restricted for current user."  unless grantedRoute
	""


# this function returns true if user is in role allowed to access given route
@routeGranted = (routeName) ->

# route without name - enable access (?)
	return true  unless routeName

	# this app don't have role map - enable access
	return true  if not roleMap or roleMap.length is 0
	roleMapItem = _.find(roleMap, (roleItem) ->
		roleItem.route is routeName
	)

	# page is not restricted
	return true  unless roleMapItem

	# user is not logged in
	return false  if not Meteor.user() or not Meteor.user().roles

	# this page is restricted to some role(s), check if user is in one of allowedRoles
	allowedRoles = roleMapItem.roles
	granted = _.intersection(allowedRoles, Meteor.user().roles)
	return false  if not granted or granted.length is 0
	true

Router.ensureLogged = ->
	return  if Meteor.userId() and (not Meteor.user() or not Meteor.user().roles)
	unless Meteor.userId()

# user is not logged in - redirect to public home
		redirectRoute = firstGrantedRoute("home_public")
		@redirect redirectRoute
	else

# user is logged in - check role
		unless routeGranted(@route.getName())

# user is not in allowedRoles - redirect to first granted route
			redirectRoute = firstGrantedRoute("screens")
			@redirect redirectRoute
		else
			@next()

Router.ensureNotLogged = ->
	return  if Meteor.userId() and (not Meteor.user() or not Meteor.user().roles)
	if Meteor.userId()
		redirectRoute = firstGrantedRoute("screens")
		@redirect redirectRoute
	else
		@next()


# called for pages in free zone - some of pages can be restricted
Router.ensureGranted = ->
	return  if Meteor.userId() and (not Meteor.user() or not Meteor.user().roles)
	unless routeGranted(@route.getName())

# user is not in allowedRoles - redirect to first granted route
		redirectRoute = firstGrantedRoute("")
		@redirect redirectRoute
	else
		@next()

Router.waitOn ->
	Meteor.subscribe "current_user_data"

Router.onBeforeAction ->

# loading indicator here
	unless @ready()
		$("body").addClass "wait"
	else
		$("body").removeClass "wait"
		@next()

Router.onBeforeAction Router.ensureNotLogged,
	only: publicRoutes

Router.onBeforeAction Router.ensureLogged,
	only: privateRoutes

Router.onBeforeAction Router.ensureGranted, # yes, route from free zone can be restricted to specific set of user roles
	only: freeRoutes

Router.map ->
	@route "home_public",
		path: "/"
		controller: "HomePublicController"

	@route "login",
		path: "/login"
		controller: "LoginController"

	@route "register",
		path: "/register"
		controller: "RegisterController"

	@route "verify_email",
		path: "/verify_email/:verifyEmailToken"
		controller: "VerifyEmailController"

	@route "forgot_password",
		path: "/forgot_password"
		controller: "ForgotPasswordController"

	@route "reset_password",
		path: "/reset_password/:resetPasswordToken"
		controller: "ResetPasswordController"

	@route "home_private",
		path: "/home_private"
		controller: "HomePrivateController"

	@route "admin",
		path: "/admin"
		controller: "AdminController"

	@route "admin.users",
		path: "/admin/users"
		controller: "AdminUsersController"

	@route "admin.users.details",
		path: "/admin/users/details/:userId"
		controller: "AdminUsersDetailsController"

	@route "admin.users.insert",
		path: "/admin/users/insert"
		controller: "AdminUsersInsertController"

	@route "admin.users.edit",
		path: "/admin/users/edit/:userId"
		controller: "AdminUsersEditController"

	@route "user_settings",
		path: "/user_settings"
		controller: "UserSettingsController"

	@route "user_settings.profile",
		path: "/user_settings/profile"
		controller: "UserSettingsProfileController"

	@route "user_settings.change_pass",
		path: "/user_settings/change_pass"
		controller: "UserSettingsChangePassController"

	@route "logout",
		path: "/logout"
		controller: "LogoutController"

	@route "screens",
		path: "/screens_tab"
		controller: "ScreensTabController"

