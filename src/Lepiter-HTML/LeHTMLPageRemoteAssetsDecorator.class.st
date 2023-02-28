"
I am a {{gtClass:LeHTMLPageDecorator}}. 
I am responsible for {{gtMethod: LeHTMLPageRemoteAssetsDecorator>>#initializeHTMLPageExporter: | label=configuring}} asset files used for {{gtClass:LePage}} HTML exports.
I add a remote CSS and JavaScript links to a {{gtClass:LePage}} HTML output.
"
Class {
	#name : #LeHTMLPageRemoteAssetsDecorator,
	#superclass : #LeHTMLPageDecorator,
	#category : #'Lepiter-HTML-Helpers'
}

{ #category : #'api - initialization' }
LeHTMLPageRemoteAssetsDecorator >> initializeHTMLPageExporter: anExporter [
	"Configure a {{gtClass:LeHtmlPageExporterVisitor}} instance before a page export.
	I add a remote CSS and JavaScript links to a {{gtClass:LePage}} HTML output."

	anExporter shouldGenerateHeader: true.

	self remoteLinks
		do: [ :eachUrl | 
			anExporter
				addLink: {'rel' -> 'stylesheet'.
						'href' -> eachUrl} ].

	self remoteScripts
		do: [ :eachUrl | 
			anExporter
				addScript: (LeHtmlScriptDefinition
						attributes: {'type' -> 'text/javascript'.
								'src' -> eachUrl}) ]
]