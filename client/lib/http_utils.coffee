#
#    Download local resource without server
#
@downloadLocalResource = (data, filename, mimeType) ->
	filename = filename or "download"
	mimeType = mimeType or "application/octet-stream"
	bb = new Blob([ data ],
		type: mimeType
	)
	link = document.createElement("a")
	link.download = filename
	link.href = window.URL.createObjectURL(bb)
	document.body.appendChild link
	link.click()
	document.body.removeChild link

@downloadFile = (url) ->
	link = document.createElement("a")
	link.href = url
	link.download = "download"
	document.body.appendChild link
	link.click()
	document.body.removeChild link