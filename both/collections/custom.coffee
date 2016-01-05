@Checks = new Mongo.Collection("checks")

@Screens = new Mongo.Collection("screens")
@Screens.userCanInsert = (userId, doc) ->
	true

@Screens.userCanUpdate = (userId, doc) ->
	true

@Screens.userCanRemove = (userId, doc) ->
	true