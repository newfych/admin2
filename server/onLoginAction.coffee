Accounts.onLogin (user) ->
  user = user.username
  unless Checks.findOne(username: user)
    Checks.insert
      username: user
      status: true

    Screens.insert
      username: user
      screen_name: "Main"

  if Meteor.isServer
    Meteor.publish "Screens", ->
      Screens.find username: user

  if Meteor.isClient
    Meteor.subscribe "Screens"
