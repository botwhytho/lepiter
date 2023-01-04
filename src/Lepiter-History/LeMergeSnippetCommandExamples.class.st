Class {
	#name : #LeMergeSnippetCommandExamples,
	#superclass : #LeContentCommandExamples,
	#category : #'Lepiter-History-Examples'
}

{ #category : #'examples - commands' }
LeMergeSnippetCommandExamples >> createMergeSnippetsWithNoChildrenCommand [
	<gtExample>
	| page firstSnippet secondSnippet command |
	
	page := self pageWithTwoSnippets.
	firstSnippet := page children first.
	secondSnippet := page children second.
	
	command := firstSnippet commandBuilder 
		mergeSnippetCommandWith: secondSnippet.
	
	self assert: command uid notNil.
	self assert: command subcommands size equals: 2.
	
	^ command
]

{ #category : #'examples - execution' }
LeMergeSnippetCommandExamples >> executeMergeSnippetsWithNoChildrenCommand [
	<gtExample>
	| command page firstSnippet result |
	
	command := self createMergeSnippetsWithNoChildrenCommand.
	page := self targetPage.
	firstSnippet := page children first.
	
	result := command execute.
	
	self assert: page children size equals: 1.
	self assert: page editHistory eventStore size equals: 1.
	self assert: page children first string equals: 'AB'.
	
	self 
		assert: page children first identityHash 
		equals: firstSnippet identityHash.

	^ page
]

{ #category : #'examples - setup' }
LeMergeSnippetCommandExamples >> pageWithTwoSnippets [
	<gtExample>
	| page |
	
	page := self targetPage.
	page addSnippet: ((LeTextSnippet string: 'A')
		uid: LeUID new). 
	page addSnippet: ((LeTextSnippet string: 'B')
		uid: LeUID new). 
	
	^ page
]