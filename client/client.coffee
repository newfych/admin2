@App = {}
@Helpers = {}

App.logout = ->
	Meteor.logout (err) ->

@menuItemClass = (routeName) ->
	return "hidden"  unless routeGranted(routeName)
	return ""  if not Router.current() or not Router.current().route
	return ""  unless Router.routes[routeName]
	currentPath = Router.routes[Router.current().route.getName()].handler.path
	routePath = Router.routes[routeName].handler.path
	return (if (currentPath is routePath or Router.current().route.getName().indexOf(routeName + ".") is 0) then "active" else "")  if routePath is "/"
	(if currentPath.indexOf(routePath) is 0 then "active" else "")

Helpers.menuItemClass = (routeName) ->
	menuItemClass routeName

Helpers.userFullName = ->
	name = ""
	name = Meteor.user().profile.name  if Meteor.user() and Meteor.user().profile
	name

Helpers.userEmail = ->
	email = ""
	email = Meteor.user().profile.email  if Meteor.user() and Meteor.user().profile
	email

Helpers.randomString = (strLen) ->
	Random.id strLen

Helpers.secondsToTime = (seconds, timeFormat) ->
	secondsToTime seconds, timeFormat

Helpers.integerDayOfWeekToString = (day) ->
	if _.isArray(day)
		s = ""
		_.each day, (d, i) ->
			s = s + ", "  if i > 0
			s = s + [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ][d]

		return s
	[ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ][day]

Helpers.formatDate = (date, dateFormat) ->
	return ""  unless date
	f = dateFormat or "MM/DD/YYYY"
	if _.isString(date)
		date = new Date()  if date.toUpperCase() is "NOW"
		if date.toUpperCase() is "TODAY"
			d = new Date()
			date = new Date(d.getFullYear(), d.getMonth(), d.getDate(), 0, 0, 0, 0)
	moment(date).format f

Helpers.booleanToYesNo = (b) ->
	(if b then "Yes" else "No")

Helpers.integerToYesNo = (i) ->
	(if i then "Yes" else "No")

Helpers.integerToTrueFalse = (i) ->
	(if i then "True" else "False")


# Tries to convert argument to array
#   array is returned unchanged
#   string "a,b,c" or "a, b, c" will be returned as ["a", "b", "c"]
#   for other types, array with one element (argument) is returned
#   TODO: implement other types to array conversion
Helpers.getArray = (a) ->
	a = a or []
	return a  if _.isArray(a)
	if _.isString(a)
		array = a.split(",") or []
		_.each array, (item, i) ->
			array[i] = item.trim()

		return array
	_.isObject(a)

	# what to return? keys or values?
	array = []
	array.push a
	array

Helpers.cursorEmpty = (cursor) ->
	cursor and cursor.count()

_.each Helpers, (helper, key) ->
	Handlebars.registerHelper key, helper
