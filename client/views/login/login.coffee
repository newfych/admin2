pageSession = new ReactiveDict()
pageSession.set "errorMessage", ""
Template.Login.rendered = ->
	$("input[autofocus]").focus()

Template.Login.created = ->
	pageSession.set "errorMessage", ""

Template.Login.events
	"submit #login_form": (e, t) ->
		e.preventDefault()
		pageSession.set "errorMessage", ""
		submit_button = $(t.find(":submit"))
		login_email = t.find("#login_email").value.trim()
		login_password = t.find("#login_password").value

		# check email
		unless isValidEmail(login_email)
			pageSession.set "errorMessage", "Please enter your e-mail address."
			t.find("#login_email").focus()
			return false

		# check password
		if login_password is ""
			pageSession.set "errorMessage", "Please enter your password."
			t.find("#login_email").focus()
			return false
		submit_button.button "loading"
		Meteor.loginWithPassword login_email, login_password, (err) ->
			submit_button.button "reset"
			if err
				pageSession.set "errorMessage", err.message
				false

		false

	"click #login-with-google": (e, t) ->
		e.preventDefault()
		pageSession.set "errorMessage", ""
		button = $(e.currentTarget)
		button.button "loading"
		Meteor.loginWithGoogle
			requestPermissions: [ "email" ]
		, (err) ->
			button.button "reset"
			if err
				pageSession.set "errorMessage", err.message
				false

		false

	"click #login-with-github": (e, t) ->
		e.preventDefault()
		pageSession.set "errorMessage", ""
		button = $(e.currentTarget)
		button.button "loading"
		Meteor.loginWithGithub
			requestPermissions: [ "public_repo", "user:email" ]
		, (err) ->
			button.button "reset"
			if err
				pageSession.set "errorMessage", err.message
				false

		false

	"click #login-with-linkedin": (e, t) ->
		e.preventDefault()
		pageSession.set "errorMessage", ""
		button = $(e.currentTarget)
		button.button "loading"
		Meteor.loginWithLinkedin
			requestPermissions: [ "r_emailaddress" ]
		, (err) ->
			button.button "reset"
			if err
				pageSession.set "errorMessage", err.message
				false

		false

	"click #login-with-facebook": (e, t) ->
		e.preventDefault()
		pageSession.set "errorMessage", ""
		button = $(e.currentTarget)
		button.button "loading"
		Meteor.loginWithFacebook
			requestPermissions: [ "email" ]
		, (err) ->
			button.button "reset"
			if err
				pageSession.set "errorMessage", err.message
				false

		false

	"click #login-with-twitter": (e, t) ->
		e.preventDefault()
		pageSession.set "errorMessage", ""
		button = $(e.currentTarget)
		button.button "loading"
		Meteor.loginWithTwitter
			requestPermissions: [ "email" ]
		, (err) ->
			button.button "reset"
			if err
				pageSession.set "errorMessage", err.message
				false

		false

	"click #login-with-meteor": (e, t) ->
		e.preventDefault()
		pageSession.set "errorMessage", ""
		button = $(e.currentTarget)
		button.button "loading"
		Meteor.loginWithMeteorDeveloperAccount
			requestPermissions: [ "email" ]
		, (err) ->
			button.button "reset"
			if err
				pageSession.set "errorMessage", err.message
				false

		false

Template.Login.helpers errorMessage: ->
	pageSession.get "errorMessage"
