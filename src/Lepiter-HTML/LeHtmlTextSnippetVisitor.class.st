Class {
	#name : #LeHtmlTextSnippetVisitor,
	#superclass : #Object,
	#traits : 'TLeExtensibleContentNodeVisitor + TSmaCCCompositeVisitor + (TLeContentNodeVisitor - {#acceptNode:})',
	#classTraits : 'TLeExtensibleContentNodeVisitor classTrait + TSmaCCCompositeVisitor classTrait + TLeContentNodeVisitor classTrait',
	#instVars : [
		'context',
		'snippet',
		'exportedNodes'
	],
	#classInstVars : [
		'componentVisitorClasses'
	],
	#category : #'Lepiter-HTML-! Core'
}

{ #category : #accessing }
LeHtmlTextSnippetVisitor >> context [
	^ context
]

{ #category : #accessing }
LeHtmlTextSnippetVisitor >> context: anObject [
	context := anObject
]

{ #category : #private }
LeHtmlTextSnippetVisitor >> convertToLocalOrAbsoluteUrl: linkUrl [
	<return: #String>
	^ LeUrlStringUtilityBuilder new
		database: context database;
		urlString: linkUrl;
		build;
		asString
]

{ #category : #initialization }
LeHtmlTextSnippetVisitor >> initialize [ 
	super initialize.
	
	"I am used to identify nodes that are not exported."
	exportedNodes := OrderedCollection new.
]

{ #category : #accessing }
LeHtmlTextSnippetVisitor >> snippet [
	^ snippet
]

{ #category : #accessing }
LeHtmlTextSnippetVisitor >> snippet: anObject [
	snippet := anObject
]

{ #category : #generated }
LeHtmlTextSnippetVisitor >> visitBold: aBold [
	exportedNodes add: aBold.
	
	context html inlineTag: 'b' do: [ self visitContent: aBold ]
]

{ #category : #generated }
LeHtmlTextSnippetVisitor >> visitCodeBlock: aCodeBlock [
	context html
		tag: #div
		attributes: #('class' 'code_block') 
		do: [
			context html
				tag: 'pre' 
				do: [
					context html 
						tag: 'code' 
						attributes: #('class' 'smalltalk') 
						with: aCodeBlock code value asString trimBoth.
				]
		]
]

{ #category : #generated }
LeHtmlTextSnippetVisitor >> visitContent: aContent [

	exportedNodes 
		detect: [ :eachNode | eachNode == aContent ] 
		ifFound: [ :aNode | "ignore" ] 
		ifNone: [ 
			context log addItem: (LeExportUnsupportedTextSnippetNodeLogItem new 
				snippet: snippet;
				node: aContent) ].

	^ self visitSmaCCParseNode: aContent
]

{ #category : #generated }
LeHtmlTextSnippetVisitor >> visitDocumenterAnnotation: aDocumenterAnnotation [
	aDocumenterAnnotation annotation
		acceptVisitor: (LeHtmlTextSnippetAnnotationVisitor new 
			context: context;
			snippet: snippet)
]

{ #category : #generated }
LeHtmlTextSnippetVisitor >> visitDoubleBracketLink: aDoubleBracketLink [
	context pageLinks ifNil: [ ^ aDoubleBracketLink ].

	context pageLinks
		linkTitled: aDoubleBracketLink linkUID
		ifFound: [ :aLink | 
			context html 
				inlineTag: #a
				attributes: { 'href'. aLink fileName asString }
				with: aDoubleBracketLink linkUID ]
		ifNone: [ 
			context html 
				inlineTag: #div
				with: aDoubleBracketLink linkUID ].

	^ aDoubleBracketLink
]

{ #category : #generated }
LeHtmlTextSnippetVisitor >> visitExternalImageLink: anExternalImageLink [
	| imgSrc caption |
	imgSrc := self convertToLocalOrAbsoluteUrl: anExternalImageLink url.
	caption := anExternalImageLink label.

	LeHtmlFigureImageWriter new
		html: context html;
		imageSrc: imgSrc;
		caption: caption;
		write
]

{ #category : #generated }
LeHtmlTextSnippetVisitor >> visitExternalLabelUrlLink: anExternalLabelUrlLink [
	| linkUrl convertedUrl |
	linkUrl := anExternalLabelUrlLink url.
	convertedUrl := self convertToLocalOrAbsoluteUrl: linkUrl.
	
	context html 
		inlineTag: #a 
		attributes: { #href. convertedUrl } 
		with: convertedUrl
]

{ #category : #generated }
LeHtmlTextSnippetVisitor >> visitExternalUrlLink: anExternalUrlLink [
	| linkUrl convertedUrl |
	linkUrl := anExternalUrlLink url.
	convertedUrl := self convertToLocalOrAbsoluteUrl: linkUrl.
	
	context html 
		inlineTag: #a 
		attributes: { #href. convertedUrl } 
		with: convertedUrl
]

{ #category : #generated }
LeHtmlTextSnippetVisitor >> visitHeader: aHeader [
	exportedNodes add: aHeader.
	
	context html
		tag: 'h' , (aHeader headerLevel + 1) asString
		do: [ self visitContent: aHeader ]
]

{ #category : #generated }
LeHtmlTextSnippetVisitor >> visitInlineCode: anInlineCode [
	| md code |
	md := anInlineCode code value.
	code := md copyFrom: 2 to: md size - 1.
	context html inlineTag: #code with: code.
]

{ #category : #generated }
LeHtmlTextSnippetVisitor >> visitItalic: anItalic [
	exportedNodes add: anItalic.

	context html
		tag: #i
		do: [ context html noIndentDo: [ self visitContent: anItalic ] ].
		
	^ anItalic
]

{ #category : #generated }
LeHtmlTextSnippetVisitor >> visitString: aString [
	exportedNodes add: aString.
	
	aString parts ifNotEmpty: [ 
		aString parts first isHeaderNode ifFalse: [ 
			context html
				tag: #p
				do: [ self visitContent: aString ].
			^ aString
		]
	].

	^ self visitContent: aString
]

{ #category : #generated }
LeHtmlTextSnippetVisitor >> visitText: aText [
	context html escape: aText content.
	
	exportedNodes add: aText
]