Accounts.onLogin (user) ->
  if Meteor.isServer
    unless Screens.find(user: user._id)
      Screens.insert
        user: user._id
        screen: "main"

    Meteor.publish "Screens", ->
      Screens.find user: user._id
    console.log "Collections PUBLISHED (onLoginAction)"

    if Meteor.isClient
      Meteor.subscribe "Screens"
