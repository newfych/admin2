Screens.allow({
	insert: function (userId, doc) {
		return Screens.userCanInsert(userId, doc);
	},

	update: function (userId, doc, fields, modifier) {
		return Screens.userCanUpdate(userId, doc);
	},

	remove: function (userId, doc) {
		return Screens.userCanRemove(userId, doc);
	}
});

Screens.before.insert(function(userId, doc) {
	doc.createdAt = new Date();
	doc.createdBy = userId;
	doc.modifiedAt = doc.createdAt;
	doc.modifiedBy = doc.createdBy;

	
	if(!doc.createdBy) doc.createdBy = userId;
});

Screens.before.update(function(userId, doc, fieldNames, modifier, options) {
	modifier.$set = modifier.$set || {};
	modifier.$set.modifiedAt = new Date();
	modifier.$set.modifiedBy = userId;

	
});

Screens.before.remove(function(userId, doc) {
	
});

Screens.after.insert(function(userId, doc) {
	
});

Screens.after.update(function(userId, doc, fieldNames, modifier, options) {
	
});

Screens.after.remove(function(userId, doc) {
	
});
