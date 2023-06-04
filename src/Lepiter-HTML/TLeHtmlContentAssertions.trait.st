Trait {
	#name : #TLeHtmlContentAssertions,
	#category : #'Lepiter-HTML-Examples'
}

{ #category : #asserting }
TLeHtmlContentAssertions >> assertHtml: html [
	self assert: html isNotNil description: [ 'HTML output must be non-nil' ].
	self assert: html isString description: [ 'HTML output must be a string' ]
]

{ #category : #asserting }
TLeHtmlContentAssertions >> assertHtml: html beginsWith: subString [
	self assertNotEmptyHtml: html.

	self
		assert: (html beginsWith: subString)
		description: [ 'HTML must begin with {1}' format: {subString} ]
]

{ #category : #asserting }
TLeHtmlContentAssertions >> assertHtml: html includes: subString [
	self assertNotEmptyHtml: html.

	self
		assert: (html includesSubstring: subString)
		description: [ 'HTML must include {1}' format: {subString} ]
]

{ #category : #asserting }
TLeHtmlContentAssertions >> assertNotEmptyHtml: html [
	self assertHtml: html.
	self assert: html isNotEmpty description: [ 'HTML output must be non-empty' ]
]