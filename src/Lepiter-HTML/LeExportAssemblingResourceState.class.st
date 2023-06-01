Class {
	#name : #LeExportAssemblingResourceState,
	#superclass : #Object,
	#traits : 'TExportResourceState',
	#classTraits : 'TExportResourceState classTrait',
	#instVars : [
		'startTime'
	],
	#category : #'Lepiter-HTML-! New - Model - Resource State'
}

{ #category : #accessing }
LeExportAssemblingResourceState >> color [
	^ BrGlamorousColors successBackgroundColor
]

{ #category : #'api - duration' }
LeExportAssemblingResourceState >> duration [
	^ DateAndTime now - startTime
]

{ #category : #initialization }
LeExportAssemblingResourceState >> initialize [
	super initialize.
	startTime := DateAndTime now
]

{ #category : #testing }
LeExportAssemblingResourceState >> isFailure [
	"Return true if a resource could not be assembled"

	^ false
]

{ #category : #testing }
LeExportAssemblingResourceState >> isReady [
	"Return true if the resource is ready, e.g., an element screenshot is stored in the resource file"

	^ false
]

{ #category : #'api - duration' }
LeExportAssemblingResourceState >> minutes [
	^ self duration asMinutes
]

{ #category : #accessing }
LeExportAssemblingResourceState >> name [
	^ 'assembling ({1} minutes)' format: { self minutes asInteger }
]