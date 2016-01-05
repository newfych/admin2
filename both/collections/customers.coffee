@Customers = new Mongo.Collection("customers")
@Customers.userCanInsert = (userId, doc) ->
	true

@Customers.userCanUpdate = (userId, doc) ->
	true

@Customers.userCanRemove = (userId, doc) ->
	true