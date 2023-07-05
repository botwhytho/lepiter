"
GtAbstractLepiterDb provides a number of utilities that assist in the management of class based lepiter databases, e.g. viewing pages directly from the store, finding the current database using the class as its store, etc.
"
Class {
	#name : #GtAbstractLepiterDb,
	#superclass : #Object,
	#category : #'Lepiter-Store-Class-Storage'
}

{ #category : #'extensions utils' }
GtAbstractLepiterDb class >> browse: aDatabase fromTargetElement: anElement [ 
	| startPage |
	
	startPage := aDatabase tableOfContents.
	startPage ifNil: [
		aDatabase pageCount > 0 ifTrue: [
			startPage := aDatabase pages first ]  ].
	
	anElement phlow 
		spawnTool: startPage asLepiterPagePhlowTool 
]

{ #category : #accessing }
GtAbstractLepiterDb class >> defaultDatabase [
	"Answer the LeDatabase that uses the receiver as its store"
	^ self 
		defaultDatabaseIfFound: [ :aDatabase | aDatabase ]
		ifNone:  [
			NotFound signalFor: self ]
]

{ #category : #'gt - extensions' }
GtAbstractLepiterDb class >> defaultDatabaseIfFound: aFoundBlock ifNone: anAbsentBlock [
	"Answer the LeDatabase that uses the receiver as its store"
	| logicalDatabase |

	logicalDatabase := LeDatabasesRegistry default currentLoadedDefaultLogicalDatabase.
	^ logicalDatabase databases 
		detect: [ :db |
			db monitor class == LeDatabaseClassStoreMonitor
				and: [ db monitor dbClass == self ] ]
		ifFound: [ :aDatabase | aFoundBlock cull:  aDatabase ]
		ifNone: [ anAbsentBlock value ]
]

{ #category : #'gt - extensions' }
GtAbstractLepiterDb class >> gtActionInspectExistingDatabaseFor: anAction [
	<gtClassAction>
	
	self isAbstract ifTrue: [ ^ anAction noAction ].
	
	^ anAction dropdown
		tooltip: 'Inspect the instance of this database from the registry';
		label: 'DB';
		icon: BrGlamorousVectorIcons smallDownwards;
		priority: 10;
		content: [ :aDropdown | 
			self gtBuildCoderDatabaseMenuIn: aDropdown ]
]

{ #category : #'gt - extensions' }
GtAbstractLepiterDb class >> gtBuildCoderDatabaseMenuIn: aDropdown [ 
	| menuItems |
	
	menuItems := OrderedCollection new.
	self isRegisteredWithDefaultDatabase 
		ifTrue: [
			menuItems add: ('Browse registered instance' -> [:anElement |
				self 
					browse: self defaultDatabase 
					fromTargetElement: anElement ]).
			menuItems add: ('Inspect registered instance' -> [:anElement |
				anElement phlow spawnObject: self defaultDatabase ]) ]
		ifFalse: [
			menuItems add: ('Add to registry (TODO)' -> [:anElement |
			
				 ]) ].
	menuItems add: ('Browse new instance' -> [:anElement |
		self 
			browse: (LeDatabaseClassStoreLoad current loadFromClass: self)
			fromTargetElement: anElement ]).
	menuItems add: ('Inspect new instance' -> [:anElement |
		anElement phlow 
			spawnObject: (LeDatabaseClassStoreLoad current loadFromClass: self) ]).
		
	^ BrGlamorousSimpleContextMenuContent new 
		items: menuItems.
]

{ #category : #testing }
GtAbstractLepiterDb class >> gtViewDatabasePagesFor: aView [
	<gtView>
	<gtClassView>
	
	self isAbstract ifTrue: [ ^ aView empty ].
	
	^ aView forward 
		title: 'Pages';
		priority: 15;
		object: [ LeDatabaseClassStoreLoad current loadFromClass: self ];
		view: #gtLiveFor:
]

{ #category : #testing }
GtAbstractLepiterDb class >> isAbstract [
	^ self name = #GtAbstractLepiterDb
]

{ #category : #testing }
GtAbstractLepiterDb class >> isRegisteredWithDefaultDatabase [
	^ self 
		defaultDatabaseIfFound: [ :aDatabase | true ]
		ifNone:  [ false ]
]