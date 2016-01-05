Template.ScreensTab.helpers
  screens: ->
    Screens.find()

Template.ScreensTab.events
  "click #add-screen": (e, t) ->
    e.preventDefault()
    Screens.insert
      user: Meteor.userId()
      screen: "main"
      console.log 'inserted' + Meteor.userId()
  "click #remove-screen": (e, t) ->
    e.preventDefault()
    if Screens.findOne(screen: "main")
      id = Screens.findOne(screen: "main")._id
      Screens.remove(id)
