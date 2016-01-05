@isValidEmail = (value) ->
	filter = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/
	return true  if filter.test(value)
	false

@isValidPassword = (value, min_length) ->
	return false  if not value or value is "" or value.length < min_length
	true

@isValidIPv4 = (value) ->
	filter = /^(\d{1,3}\.){3}(\d{1,3})$|^(0x[\da-fA-F]{2}\.){3}(0x[\da-fA-F]{2})$|^(0[0-3][0-7]{2}\.){3}(0[0-3][0-7]{2})|^0x[\da-fA-F]{8}$|^[0-4]\d{9}$|^0[0-3]\d{10}$/
	return true  if filter.test(value)
	false

@isValidIPv6 = (value) ->
	filter = /^([\da-fA-F]{1,4}:){7}([\da-fA-F]{1,4})$/
	return true  if filter.test(value)
	false

@isValidIP = (value) ->
	return true  if isValidIPv4(value) or isValidIPv6(value)
	false

@timeToSeconds = (timeStr, timeFormat) ->
	t = timeStr or "12:00 am"
	tf = timeFormat or "h:mm a"
	m = moment.utc("01/01/1970 " + t, "MM/DD/YYYY " + tf)
	return null  unless m.isValid()
	m.unix()

@secondsToTime = (seconds, timeFormat) ->
	s = seconds or 0
	tf = timeFormat or "h:mm a"
	moment.unix(s).utc().format tf

@validateForm = (formObject, validationCallback, errorCallback, submitCallback) ->
	values = {}
	error = false
	formObject.find("input,select,textarea").each ->

# auto set data type for checkbox

# single checkbox with that name means dataType="BOOL" else it is "ARRAY"

# radio has value only if checked

# hide error message from previous call
		validationError = (errorMessage) ->
			formGroup.addClass "has-error"
			inputObject.focus()
			if errorLabel
				errorLabel.text(errorMessage).removeClass("hidden").addClass "visible"
				errorLabel.closest(".field").addClass "error"
			errorCallback errorMessage  if errorCallback
			error = true
		skipValue = false
		inputObject = $(this)
		formGroup = inputObject.closest(".form-group")
		fieldName = inputObject.attr("name")
		labelObject = formGroup.find("label[for='" + fieldName + "']")
		errorLabel = formGroup.find("#error-text")
		fieldValue = inputObject.val()
		dataType = (if inputObject.attr("data-type") then inputObject.attr("data-type").toUpperCase() else "STRING")
		dataFormat = inputObject.attr("data-format") or ""
		skipValue = true  unless fieldName
		if inputObject.attr("type") is "checkbox"
			unless inputObject.attr("data-type")
				if formObject.find("input[name='" + fieldName + "']").length is 1
					dataType = "BOOL"
				else
					dataType = "ARRAY"
			fieldValue = inputObject.is(":checked")  if dataType is "BOOL"
			fieldValue = (if inputObject.is(":checked") then fieldValue else "")  if dataType is "ARRAY"
		if inputObject.attr("type") is "radio"
			fieldValue = (if inputObject.is(":checked") then fieldValue else "")
			skipValue = true  if dataType isnt "ARRAY" and not fieldValue
		minValue = inputObject.attr("data-min")
		maxValue = inputObject.attr("data-max")
		labelText = (if inputObject.attr("placeholder") then inputObject.attr("placeholder") else "")
		labelText = (if labelObject then labelObject.text() else fieldName)  unless labelText
		formGroup.removeClass "has-error"
		if errorLabel
			errorLabel.text("").removeClass("visible").addClass "hidden"
			errorLabel.closest(".field").removeClass "error"
		unless skipValue

# Check required
			if inputObject.attr("required") and not fieldValue
				validationError labelText + " is required"
				return false

			# checkbox doesn't have required property, so I set parent container's data-required to true
			if inputObject.attr("type") is "checkbox"
				checkboxContainer = inputObject.closest(".input-div")
				req = checkboxContainer.attr("data-required")
				if req
					atLeastOneChecked = false
					checkboxContainer.find("input[type='checkbox']").each ->
						atLeastOneChecked = true  if $(this).is(":checked")

					unless atLeastOneChecked
						validationError labelText + " is required"
						return false

			# Convert to bool
			fieldValue = (if fieldValue then true else false)  if dataType is "BOOL"

			# Check Integer, also min and max value
			if dataType is "INTEGER"
				intValue = parseInt(fieldValue)
				if isNaN(intValue)
					validationError labelText + ": Invalid value entered"
					return false
				if minValue and not isNaN(parseInt(minValue)) and intValue < parseInt(minValue)
					if maxValue and not isNaN(parseInt(maxValue))
						validationError labelText + " must be between " + minValue + " and " + maxValue
					else
						validationError labelText + " must be equal or greater than " + minValue
					return false
				if maxValue and not isNaN(parseInt(maxValue)) and intValue > parseInt(maxValue)
					if minValue and not isNaN(parseInt(minValue))
						validationError labelText + " must be between " + minValue + " and " + maxValue
					else
						validationError labelText + " must be equal or less than " + maxValue
					return false
				fieldValue = intValue

			# Check Float, also Min and Max value
			if dataType is "FLOAT"
				floatValue = parseFloat(fieldValue)
				if isNaN(floatValue)
					validationError labelText + ": Invalid value entered"
					return false
				if minValue and not isNaN(parseFloat(minValue)) and floatValue < parseFloat(minValue)
					validationError labelText + " must be equal or greater than " + minValue
					return false
				if maxValue and not isNaN(parseFloat(maxValue)) and floatValue > parseFloat(maxValue)
					validationError labelText + " must be equal or less than " + maxValue
					return false
				fieldValue = floatValue

			# Check valid E-mail address
			if dataType is "EMAIL"
				if fieldValue and not isValidEmail(fieldValue)
					validationError labelText + ": please enter valid e-mail address"
					return false
			if dataType is "IP"
				if fieldValue and not isValidIP(fieldValue)
					validationError labelText + ": please enter valid IPv4 or IPv6 address"
					return false
			if dataType is "IPV4"
				if fieldValue and not isValidIPv4(fieldValue)
					validationError labelText + ": please enter valid IPv4 address"
					return false
			if dataType is "IPV6"
				if fieldValue and not isValidIPv6(fieldValue)
					validationError labelText + ": please enter valid IPv6 address"
					return false
			if dataType is "ARRAY"
				unless _.isArray(fieldValue)
					newValue = (if values[fieldName] then values[fieldName] else [])
					newValue.push fieldValue  if fieldValue
					fieldValue = newValue

			# TIME (user input "12:30 am" produces "1800" that is number of seconds from midnight)
			if dataType is "TIME"
				fieldValue = null  if fieldValue is ""
				seconds = timeToSeconds(fieldValue, dataFormat)
				if isNaN(parseInt(seconds))
					validationError labelText + ": Invalid value entered."
					return false
				fieldValue = seconds
			if dataType is "DATE"
				if fieldValue is ""
					fieldValue = null
				else
					date = moment(fieldValue, dataFormat)
					unless date.isValid()
						validationError labelText + ": Invalid value entered." + ((if dataFormat then " Date is expected in format \"" + dataFormat + "\"" else ""))
						return false
					fieldValue = date.toDate()
			fieldValue = fieldValue.toString()  if _.isArray(fieldValue)  if dataType is "STRING"

			# Custom validation
			if validationCallback
				errorMessage = validationCallback(fieldName, fieldValue)
				if errorMessage
					validationError errorMessage
					return false
			values[fieldName] = fieldValue

	return  if error
	values = deepen(values)
	submitCallback values  if submitCallback

Handlebars.registerHelper "itemIsChecked", (desiredValue, itemValue) ->
	return ""  if not desiredValue and not itemValue
	return (if desiredValue.indexOf(itemValue) >= 0 then "checked" else "")  if _.isArray(desiredValue)
	(if desiredValue is itemValue then "checked" else "")

Handlebars.registerHelper "optionIsSelected", (desiredValue, itemValue) ->
	return ""  if not desiredValue and not itemValue
	return (if desiredValue.indexOf(itemValue) >= 0 then "selected" else "")  if _.isArray(desiredValue)
	(if desiredValue is itemValue then "selected" else "")

@bootboxDialog = (template, data, options) ->
	tmpl = null
	if _.isString(template)
		tmpl = Template[template]
	else
		tmpl = template
	div = document.createElement("div")

	#	UI.insert(UI.renderWithData(template, data), div);
	Blaze.renderWithData tmpl, data, div
	options.message = div
	bootbox.dialog options