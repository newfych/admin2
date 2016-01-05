@ScreensTabController = RouteController.extend(
  template: 'ScreensTab'
#  yieldTemplates: 'AdminUsers': to: 'AdminSubcontent'

  onBeforeAction: ->
    @next()

  action: ->
    if @isReady()
      @render()
    else
      @render 'loading'

  isReady: ->
    subs = [ Meteor.subscribe('Screens') ]
    ready = true
    _.each subs, (sub) ->
      if !sub.ready()
        ready = false
    ready
)
