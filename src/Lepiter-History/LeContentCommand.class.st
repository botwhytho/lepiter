Class {
	#name : #LeContentCommand,
	#superclass : #Object,
	#instVars : [
		'uid',
		'targetContent',
		'subcommands',
		'parentCommand'
	],
	#category : #'Lepiter-History-Commands'
}

{ #category : #adding }
LeContentCommand >> addSubcommand: aCommand [
	self assert: [ aCommand parentCommand isNil ].
	
	self subcommands add: aCommand.
	aCommand parentCommand: self.
]

{ #category : #'execution - utils' }
LeContentCommand >> createCommandResult [
	^ LeCommandExecutionResult forCommand: self
]

{ #category : #converting }
LeContentCommand >> createCommandSpecification [
	self subclassResponsibility
]

{ #category : #'execution - utils' }
LeContentCommand >> createUndoCommandSpecification [
	^ nil
]

{ #category : #printing }
LeContentCommand >> description [
	^ String streamContents: [ :aStream |
		self descriptionOn: aStream ]
]

{ #category : #printing }
LeContentCommand >> descriptionOn: aStream [
	self subclassResponsibility
]

{ #category : #execution }
LeContentCommand >> execute [
	self subclassResponsibility
]

{ #category : #initialization }
LeContentCommand >> initialize [ 
	super initialize.
	uid := LeUID new uid: UUID new.
	subcommands := OrderedCollection new.
]

{ #category : #initialization }
LeContentCommand >> initializeFromSpecification: aCommandSpecification withBuilder: aBuilder [
	self assert: [ aCommandSpecification notNil ].
	self assert: [ aCommandSpecification commandTypeName = self className ].
]

{ #category : #accessing }
LeContentCommand >> parentCommand [
	^ parentCommand
]

{ #category : #accessing }
LeContentCommand >> parentCommand: aCommand [ 
	self assert: [ self parentCommand isNil ].
	
	parentCommand := aCommand
]

{ #category : #accessing }
LeContentCommand >> subcommands [
	^ subcommands
]

{ #category : #accessing }
LeContentCommand >> targetContent [

	^ targetContent
]

{ #category : #accessing }
LeContentCommand >> targetContent: aLeContent [

	targetContent := aLeContent
]

{ #category : #accessing }
LeContentCommand >> uid [ 
	^ uid
]

{ #category : #execution }
LeContentCommand >> withUndoExecute: aBlock [
	"An utility method that creates an undo specification after a command was executed.
	Can be used when all the information needed by an undo is available before executing
	the command."
	| undoSpecification |
	undoSpecification := self createUndoCommandSpecification.
	
	aBlock value.
	
	^ self createCommandResult 
		undoSpecification: undoSpecification
]