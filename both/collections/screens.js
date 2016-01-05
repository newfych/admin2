this.Screens = new Mongo.Collection("screens");

this.Screens.userCanInsert = function(userId, doc) {
	return true;
}

this.Screens.userCanUpdate = function(userId, doc) {
	return true;
}

this.Screens.userCanRemove = function(userId, doc) {
	return true;
}
