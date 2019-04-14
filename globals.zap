

	.FUNCT	INTDIR-F
	EQUAL?	PRSA,V?SET \FALSE
	PRINTR	"Okay, you're now facing in that direction, but you don't see anything you didn't see before."


	.FUNCT	INTNUM-F
	CALL	NOUN-USED,W?ONE,INTNUM
	ZERO?	STACK \?PRD5
	CALL	NOUN-USED,W?TWO,INTNUM
	ZERO?	STACK \?PRD5
	CALL	NOUN-USED,W?THREE,INTNUM
	ZERO?	STACK /?CCL3
?PRD5:	CALL	GLOBAL-IN?,KEYPAD,HERE
	ZERO?	STACK /?CCL3
	EQUAL?	PRSA,V?TYPE,V?PUSH \?CCL3
	PRINTR	"[Use numerals: for example, TYPE 5 rather than TYPE FIVE.]"
?CCL3:	EQUAL?	PRSA,V?ON,V?SHOOT,V?EXAMINE /?PRD13
	EQUAL?	PRSA,V?MUNG,V?KILL,V?OFF \?CCL11
?PRD13:	GET	WELDER-TABLE,WELDER-TABLE-POINTER
	EQUAL?	STACK,P-NUMBER \?CCL11
	IN?	WELDER,HERE \?CCL11
	EQUAL?	PRSO,INTNUM \?CCL19
	CALL	PERFORM-PRSA,WELDER,PRSI
	RSTACK	
?CCL19:	CALL	PERFORM-PRSA,PRSO,WELDER
	RSTACK	
?CCL11:	EQUAL?	PRSA,V?ENTER \?PRD23
	EQUAL?	P-PRSA-WORD,W?ENTER \?PRD23
	CALL	GLOBAL-IN?,KEYPAD,HERE
	ZERO?	STACK \?CTR20
?PRD23:	EQUAL?	PRSA,V?PUSH \?CCL21
	CALL	GLOBAL-IN?,KEYPAD,HERE
	ZERO?	STACK /?CCL21
?CTR20:	CALL	PERFORM,V?TYPE,INTNUM
	RTRUE	
?CCL21:	EQUAL?	PRSA,V?SET \?CCL30
	ZERO?	PRSI \?CCL30
	EQUAL?	HERE,COMMANDERS-QUARTERS \?CCL30
	EQUAL?	P-NUMBER,DIAL-SETTING \?CCL36
	PRINT	SENILITY-STRIKES
	RTRUE	
?CCL36:	GRTR?	P-NUMBER,8000 \?CCL38
	PRINTR	"The dial only goes up to 8000."
?CCL38:	SET	'DIAL-SETTING,P-NUMBER
	PRINTR	"""Click."""
?CCL30:	EQUAL?	PRSA,V?WAIT-FOR \?CCL40
	GRTR?	P-NUMBER,40 \?CCL43
	PRINT	TOO-LONG-TO-WAIT
	RTRUE	
?CCL43:	CALL	V-WAIT
	RSTACK	
?CCL40:	EQUAL?	PRSA,V?WAIT-UNTIL \?CCL45
	GRTR?	P-NUMBER,INTERNAL-MOVES \?CCL48
	SUB	P-NUMBER,INTERNAL-MOVES
	LESS?	STACK,41 \?CCL48
	CALL	V-WAIT
	RSTACK	
?CCL48:	PRINT	TOO-LONG-TO-WAIT
	RTRUE	
?CCL45:	CALL	TOUCHING?,INTNUM
	ZERO?	STACK \?CCL52
	EQUAL?	PRSA,V?SHOOT \FALSE
?CCL52:	PRINT	HUH
	RTRUE	


	.FUNCT	NOT-HERE-OBJECT-F,TBL,PRSO?=1,OBJ,X=0
	EQUAL?	PRSO,NOT-HERE-OBJECT \?CCL3
	EQUAL?	PRSI,NOT-HERE-OBJECT \?CCL3
	PRINTR	"Those things aren't here!"
?CCL3:	EQUAL?	PRSO,NOT-HERE-OBJECT \?CCL7
	SET	'TBL,P-PRSO
	JUMP	?CND1
?CCL7:	SET	'TBL,P-PRSI
	SET	'PRSO?,FALSE-VALUE
?CND1:	ZERO?	PRSO? /?CCL10
	CALL	PRSO-MOBY-VERB?
	ZERO?	STACK /?CCL10
	SET	'X,TRUE-VALUE
	JUMP	?CND8
?CCL10:	ZERO?	PRSO? \?CND8
	CALL	PRSI-MOBY-VERB?
	ZERO?	STACK /?CND8
	SET	'X,TRUE-VALUE
?CND8:	ZERO?	X /?CCL18
	CALL	FIND-NOT-HERE,TBL,PRSO? >OBJ
	ZERO?	OBJ /FALSE
	EQUAL?	OBJ,NOT-HERE-OBJECT \TRUE
	EQUAL?	PRSA,V?FOLLOW,V?WALK-TO \?CCL26
	CALL	V-WALK-AROUND
	JUMP	?CND16
?CCL26:	PRINTC	91
	PRINT	YOULL-HAVE-TO
	PRINTI	"be more specific.]"
	CRLF	
	JUMP	?CND16
?CCL18:	EQUAL?	WINNER,PROTAGONIST \?CCL29
	PRINTI	"You"
	JUMP	?CND27
?CCL29:	PRINTI	"Looking confused,"
	CALL	TPRINT,WINNER
	PRINTI	" says, ""I"
?CND27:	PRINTI	" can't see"
	CALL	NAME?,P-XNAM
	ZERO?	STACK \?CND30
	PRINTI	" any"
?CND30:	CALL	NOT-HERE-PRINT,PRSO?
	PRINTI	" here!"
	EQUAL?	WINNER,PROTAGONIST /?CND32
	PRINTC	34
?CND32:	CRLF	
?CND16:	CALL	STOP
	RSTACK	


	.FUNCT	PRSO-MOBY-VERB?
	EQUAL?	PRSA,V?WHAT,V?WHERE,V?WAIT-FOR /TRUE
	EQUAL?	PRSA,V?WALK-TO,V?CALL,V?SAY /TRUE
	EQUAL?	PRSA,V?FIND,V?FOLLOW /TRUE
	RFALSE	


	.FUNCT	PRSI-MOBY-VERB?
	EQUAL?	PRSA,V?ASK-ABOUT,V?ASK-FOR,V?TELL-ABOUT /TRUE
	RFALSE	


	.FUNCT	FIND-NOT-HERE,TBL,PRSO?,M-F,OBJ
	CALL	MOBY-FIND,TBL >M-F
	ZERO?	DEBUG /?CND1
	PRINTI	"[Found "
	PRINTN	M-F
	PRINTI	" obj]"
	CRLF	
?CND1:	EQUAL?	1,M-F \?CCL5
	ZERO?	DEBUG /?CND6
	PRINTI	"[Namely: "
	PRINTD	P-MOBY-FOUND
	PRINTC	93
	CRLF	
?CND6:	ZERO?	PRSO? /?CCL10
	SET	'PRSO,P-MOBY-FOUND
	CALL	THIS-IS-IT,PRSO
	RFALSE	
?CCL10:	SET	'PRSI,P-MOBY-FOUND
	RFALSE	
?CCL5:	LESS?	1,M-F \?CCL12
	GET	TBL,1 >OBJ
	GETP	OBJ,P?GENERIC
	CALL	STACK >OBJ
	ZERO?	OBJ /?CCL12
	ZERO?	DEBUG /?CND15
	PRINTI	"[Generic: "
	PRINTD	OBJ
	PRINTC	93
	CRLF	
?CND15:	EQUAL?	OBJ,NOT-HERE-OBJECT /TRUE
	ZERO?	PRSO? /?CCL21
	SET	'PRSO,OBJ
	CALL	THIS-IS-IT,PRSO
	RFALSE	
?CCL21:	SET	'PRSI,OBJ
	RFALSE	
?CCL12:	RETURN	NOT-HERE-OBJECT


	.FUNCT	NOT-HERE-PRINT,PRSO?,?TMP1
	ZERO?	P-OFLAG /?CCL3
	ZERO?	P-XADJ /?CND4
	PRINTC	32
	PRINTB	P-XADJN
?CND4:	ZERO?	P-XNAM /FALSE
	PRINTC	32
	PRINTB	P-XNAM
	RTRUE	
?CCL3:	ZERO?	PRSO? /?CCL10
	GET	P-ITBL,P-NC1 >?TMP1
	GET	P-ITBL,P-NC1L
	CALL	BUFFER-PRINT,?TMP1,STACK,FALSE-VALUE
	RSTACK	
?CCL10:	GET	P-ITBL,P-NC2 >?TMP1
	GET	P-ITBL,P-NC2L
	CALL	BUFFER-PRINT,?TMP1,STACK,FALSE-VALUE
	RSTACK	


	.FUNCT	GROUND-F
	EQUAL?	PRSA,V?ENTER,V?CLIMB-ON \?CCL3
	SET	'C-ELAPSED,31
	PRINTR	"After a brief squat on the floor, you stand again."
?CCL3:	EQUAL?	PRSA,V?LOOK-UNDER \?CCL5
	CALL	IMPOSSIBLES
	RSTACK	
?CCL5:	EQUAL?	PRSA,V?LEAVE \FALSE
	CALL	DO-WALK,P?UP
	RSTACK	


	.FUNCT	WALLS-F
	EQUAL?	PRSA,V?EXAMINE \FALSE
	EQUAL?	HERE,HOLDING-TANK-LEVEL \FALSE
	PRINT	BLASTED-OPEN
	PRINT	PERIOD-CR
	RTRUE	


	.FUNCT	CEILING-F
	EQUAL?	PRSA,V?SEARCH,V?EXAMINE \?CCL3
	EQUAL?	HERE,PET-STORE \?CCL3
	MOVE	PANEL,HERE
	CALL	THIS-IS-IT,PANEL
	PRINTR	"As you look carefully, you notice something that a casual inspection of the Pet Store would never have uncovered: a panel mounted in the ceiling."
?CCL3:	EQUAL?	PRSA,V?EXAMINE \?CCL7
	EQUAL?	HERE,DOME \?CCL7
	PRINT	DOME-DESC
	CRLF	
	RTRUE	
?CCL7:	EQUAL?	PRSA,V?LOOK-UNDER \FALSE
	CALL	PERFORM,V?LOOK
	RTRUE	


	.FUNCT	GLOBAL-ROOM-F
	EQUAL?	PRSA,V?EXAMINE,V?LOOK-INSIDE,V?LOOK \?CCL3
	CALL	V-LOOK
	RSTACK	
?CCL3:	EQUAL?	PRSA,V?WALK-TO,V?ENTER \?CCL5
	CALL	V-WALK-AROUND
	RSTACK	
?CCL5:	EQUAL?	PRSA,V?DISEMBARK,V?EXIT,V?LEAVE \?CCL7
	CALL	DO-WALK,P?OUT
	RSTACK	
?CCL7:	EQUAL?	PRSA,V?WALK-AROUND \?CCL9
	EQUAL?	HERE,BARBERSHOP \?CCL9
	ZERO?	MIRROR-BROKEN \?CCL9
	CALL	ULTIMATELY-IN?,PLATINUM-DETECTOR
	ZERO?	STACK /?CCL9
	FSET?	PLATINUM-DETECTOR,ACTIVEBIT \?CCL9
	CALL	PERFORM,V?FOLLOW,PLATINUM-DETECTOR
	RTRUE	
?CCL9:	EQUAL?	PRSA,V?SEARCH \?CCL16
	ZERO?	LIT \?CCL19
	PRINT	TOO-DARK
	CRLF	
	RTRUE	
?CCL19:	EQUAL?	HERE,GREASY-STRAW \?CCL21
	IN?	NECTAR,LOCAL-GLOBALS \?CCL21
	MOVE	NECTAR,HERE
	CALL	THIS-IS-IT,NECTAR
	PRINTR	"You spot a cup of Ramosian Fire Nectar behind the counter!"
?CCL21:	PRINTR	"A cursory search of the room reveals nothing new."
?CCL16:	EQUAL?	PRSA,V?PUT \FALSE
	EQUAL?	PRSI,GLOBAL-ROOM \FALSE
	EQUAL?	P-PRSA-WORD,W?THROW \?CCL30
	CALL	PERFORM,V?THROW,PRSO
	RTRUE	
?CCL30:	CALL	PERFORM,V?DROP,PRSO
	RTRUE	


	.FUNCT	WINDOW-F
	EQUAL?	PRSA,V?LOOK-INSIDE \?CCL3
	EQUAL?	HERE,SHADY-DANS \?CCL6
	PRINT	DANS-LOT-DESC
	CRLF	
	RTRUE	
?CCL6:	EQUAL?	HERE,DOCKING-BAY-2,CARGO-BAY \?CCL8
	PRINTI	"You see the interior of"
	CALL	TRPRINT,SPACETRUCK-OBJECT
	RSTACK	
?CCL8:	EQUAL?	SPACETRUCK-COUNTER,5 \?CCL10
	EQUAL?	COURSE-PICKED,RIGHT-COURSE \?CCL10
	PRINTR	"You see an empty docking bay."
?CCL10:	EQUAL?	SPACETRUCK-COUNTER,-1 \?CCL14
	PRINTR	"You see a large cargo bay."
?CCL14:	EQUAL?	SPACETRUCK-COUNTER,4 \?CCL16
	EQUAL?	COURSE-PICKED,RIGHT-COURSE \?CCL16
	PRINTR	"   You are approaching the station from slightly above it (on the galactic plane), thus offering a good view of the station's layout. In the center is the large, spherical Command Module. Jutting ""north"" from it is a smaller Sub-Module. Joining the Command Module, at its two other connection points, is a tangle of tubes and space bubbles and derelict rockets. These form a ""village,"" the sort of seedy, unauthorized village that frequently collects around a space station."
?CCL16:	PRINTR	"You see nothing but the majestic sweep of the galaxy."
?CCL3:	EQUAL?	PRSA,V?CLEAN \FALSE
	SET	'AWAITING-REPLY,1
	ADD	C-ELAPSED,2
	CALL	QUEUE,I-REPLY,STACK
	PRINTR	"Do you also do floors?"


	.FUNCT	SIGN-F
	EQUAL?	HERE,DOME \?CCL3
	IN?	HOUSING,DOME /?CCL3
	CALL	CANT-SEE,SIGN
	RSTACK	
?CCL3:	EQUAL?	PRSA,V?READ \FALSE
	EQUAL?	HERE,DOME \?CCL10
	CALL	PERFORM,V?READ,HOUSING
	RTRUE	
?CCL10:	EQUAL?	HERE,GYM \?CCL12
	PRINTI	"""IMPORTANT! The "
	PRINTD	EXERCISE-MACHINE
	PRINTI	" has diagnostic frequencies which communicate with each other on frequency 710. Do not bring anything which broadcasts on that frequency within range of the machine!"""
	IN?	EXERCISE-MACHINE,GYM /?CND13
	PRINTI	" Strangely, you don't see any "
	PRINTD	EXERCISE-MACHINE
	PRINTR	" anywhere in the gym."
?CND13:	CRLF	
	RTRUE	
?CCL12:	EQUAL?	HERE,SHIPPING-ROOM \?CCL16
	PRINTR	"""Always return the forklift to the shipping room when it's not in use! THIS MEANS YOU!"""
?CCL16:	EQUAL?	HERE,GREASY-STRAW \?CCL18
	PRINT	RESTAURANT-SIGN-TEXT
	CRLF	
	RTRUE	
?CCL18:	EQUAL?	HERE,TRADING-POST \?CCL20
	PRINTR	"""!!!BEST PRICES IN TOWN!!!
IF YOU DON'T SEE IT ASK FOR IT!
Illegal wares shown by appointment only.
FREZONE (tm) explosive available."""
?CCL20:	EQUAL?	HERE,PET-STORE \?CCL22
	PRINTI	"""SPECIAL!!! The best pet a lonely spacer could ever hope for!
   "
	PRINTD	BALLOON
	PRINTI	"s are fascinating critters. Filled with hydrogen, they float freely through the air like small dirigibles.
   With their translucent bodies and iridescent skin, they're a beautiful addition to the decor of any living bubble. Docile and friendly, "
	PRINTD	BALLOON
	PRINTI	"s are easy to care for, feeding on airborne spores!
   Limited supply!! Order yours today!!""
   You recall one fact about "
	PRINTD	BALLOON
	PRINTR	"s which the sign fails to mention: they propel themselves around by ejecting digestive gasses. This makes them one of the smelliest pets imaginable."
?CCL22:	EQUAL?	HERE,OPIUM-DEN \?CCL24
	PRINTR	"The sign is from the government's latest anti-drug crusade. It depicts the president of the Third Galactic Union, her hands crossed across her chest in a defiant pose, with the caption, ""Drugs are a no-no!"" You notice that someone has drawn a mustache on her."
?CCL24:	PRINTR	"""TRADING POST VACUUM STORAGE AREA
   Trespassers will be spaced!"""


	.FUNCT	EQUIPMENT-F
	EQUAL?	PRSA,V?EXAMINE \?CCL3
	EQUAL?	HERE,ROBOT-POOL \?CCL6
	PRINT	ROBOT-POOL-EQUIPMENT-DESC
	CRLF	
	RTRUE	
?CCL6:	PRINTR	"Since this equipment has nothing to do with the filling out or filing of multi-part forms, it's far outside your area of expertise."
?CCL3:	EQUAL?	PRSA,V?USE \?CCL8
	EQUAL?	HERE,ROBOT-POOL \?CCL8
	PRINTR	"Put the form in the slot, you dolt!"
?CCL8:	EQUAL?	PRSA,V?OFF,V?ON \FALSE
	CALL	PERFORM,V?EXAMINE,EQUIPMENT
	RTRUE	


	.FUNCT	FIXTURES-F
	EQUAL?	PRSA,V?USE,V?WALK-TO,V?ENTER \?CCL3
	PRINTR	"This story doesn't go into that sort of detail."
?CCL3:	EQUAL?	PRSA,V?ON,V?TAKE \FALSE
	CALL	NOUN-USED,W?SHOWER,FIXTURES
	ZERO?	STACK /FALSE
	CALL	PERFORM,V?USE,FIXTURES
	RTRUE	


	.FUNCT	HOLE-F
	EQUAL?	PRSA,V?DRILL-HOLE \?CCL3
	EQUAL?	PRSO,HOLE /FALSE
?CCL3:	EQUAL?	PRSA,V?DRILL \?CCL7
	EQUAL?	PRSO,HOLE \?CCL7
	CALL	PERFORM,V?DRILL-HOLE,HOLE,WALLS
	RTRUE	
?CCL7:	CALL	PRSO-MOBY-VERB?
	ZERO?	STACK \FALSE
	CALL	PRSI-MOBY-VERB?
	ZERO?	STACK \FALSE
	CALL	CANT-SEE,HOLE
	RSTACK	


	.FUNCT	LADDER-F
	EQUAL?	PRSA,V?CLIMB-UP \?CCL3
	CALL	DO-WALK,P?UP
	RSTACK	
?CCL3:	EQUAL?	PRSA,V?CLIMB-DOWN \FALSE
	CALL	DO-WALK,P?DOWN
	RSTACK	


	.FUNCT	HANDS-F,ACTOR
	EQUAL?	PRSA,V?APPLAUD \?CCL3
	SET	'PRSO,FALSE-VALUE
	RFALSE	
?CCL3:	EQUAL?	PRSA,V?SHAKE \?CCL5
	CALL	FIND-IN,HERE,ACTORBIT,STR?87 >ACTOR
	ZERO?	ACTOR /?CCL8
	CALL	PERFORM,V?SHAKE-WITH,HANDS,ACTOR
	RTRUE	
?CCL8:	PRINTR	"Pleased to meet you."
?CCL5:	EQUAL?	PRSA,V?COUNT \?CCL10
	CALL	NOUN-USED,W?FINGER,HANDS
	ZERO?	STACK /?CCL13
	PRINTI	"Ten"
	JUMP	?CND11
?CCL13:	PRINTI	"Two"
?CND11:	PRINTR	", as usual."
?CCL10:	EQUAL?	PRSA,V?CLEAN \?CCL15
	PRINTR	"Done."
?CCL15:	EQUAL?	PRSA,V?SHOOT \?CCL17
	CALL	JIGS-UP,STR?88
	RSTACK	
?CCL17:	EQUAL?	PRSA,V?TAKE-WITH \FALSE
	EQUAL?	PRSI,HANDS \FALSE
	CALL	PERFORM,V?TAKE,PRSO
	RTRUE	


	.FUNCT	TONGUE-F
	EQUAL?	PRSA,V?RUN-OVER,V?PUT-ON \FALSE
	EQUAL?	PRSO,TONGUE \FALSE
	CALL	PERFORM,V?TASTE,PRSI
	RTRUE	


	.FUNCT	ME-F
	EQUAL?	PRSA,V?TELL \?CCL3
	PRINTI	"Talking to yourself is a sign of impending mental collapse."
	CRLF	
	CALL	STOP
	RSTACK	
?CCL3:	EQUAL?	PRSA,V?DRILL \?CCL5
	PRINTR	"Why bother? Based on that input, you already have holes in your head!"
?CCL5:	EQUAL?	PRSA,V?GIVE \?CCL7
	EQUAL?	PRSI,ME \?CCL7
	CALL	PERFORM,V?TAKE,PRSO
	RTRUE	
?CCL7:	EQUAL?	PRSA,V?SHOW \?CCL11
	EQUAL?	PRSI,ME \?CCL11
	CALL	PERFORM,V?EXAMINE,PRSO
	RTRUE	
?CCL11:	EQUAL?	PRSA,V?MOVE \?CCL15
	CALL	V-WALK-AROUND
	RSTACK	
?CCL15:	EQUAL?	PRSA,V?SEARCH \?CCL17
	CALL	V-INVENTORY
	RSTACK	
?CCL17:	EQUAL?	PRSA,V?MUNG,V?KILL \?CCL19
	EQUAL?	PRSO,ME \?CCL19
	CALL	JIGS-UP,STR?89
	RSTACK	
?CCL19:	EQUAL?	PRSA,V?SHOOT \?CCL23
	CALL	JIGS-UP,STR?90
	RSTACK	
?CCL23:	EQUAL?	PRSA,V?WHERE,V?FIND \?CCL25
	PRINTI	"You're in"
	CALL	TRPRINT,HERE
	RSTACK	
?CCL25:	EQUAL?	PRSA,V?FOLLOW \?CCL27
	PRINTR	"It would be hard not to."
?CCL27:	EQUAL?	PRSA,V?EXAMINE \?CCL29
	CALL	V-DIAGNOSE
	RSTACK	
?CCL29:	EQUAL?	PRSA,V?ALARM \?CCL31
	PRINTR	"You are!"
?CCL31:	EQUAL?	PRSA,V?TAKE \FALSE
	PRINTR	"How romantic!"


	.FUNCT	GRUE-F
	EQUAL?	PRSA,V?WHAT \?CCL3
	PRINTR	"Grues are vicious, carnivorous beasts first introduced to Earth by an alien spaceship during the 22nd century. Grues spread throughout the galaxy alongside man. Now extinct on all civilized planets, they still exist in some backwater corners of the galaxy. Their favorite diet is Lieutenants First Class, but their insatiable appetite is tempered by their fear of light."
?CCL3:	CALL	TOUCHING?,GRUE
	ZERO?	STACK \?CCL5
	EQUAL?	PRSA,V?WALK-TO,V?EXAMINE \FALSE
?CCL5:	PRINTR	"There's no grue in sight, fortunately."


	.FUNCT	FORM-SLOT-F
	EQUAL?	PRSA,V?PUT \?CCL3
	EQUAL?	PRSI,PSEUDO-OBJECT \?CCL3
	EQUAL?	PRSO,CRUMPLED-FORM \?CCL8
	PRINTR	"The form's crumpledness prevents it from sliding into the slot."
?CCL8:	EQUAL?	PRSO,CLASS-THREE-SPACECRAFT-ACTIVATION-FORM \?CCL10
	EQUAL?	HERE,SPACETRUCK \?CCL10
	EQUAL?	HERE,SPACETRUCK \?CCL15
	CALL	BOTH-SEATS-NOT-OCCUPIED
	ZERO?	STACK /?CCL15
	PRINTI	"The form is spit back out. "
	CALL	RECORDING,STR?93
	RSTACK	
?CCL15:	REMOVE	PRSO
	FSET	PRSO,NDESCBIT
	PRINT	FORM-ACCEPTED
	CALL	RECORDING,STR?94
	RSTACK	
?CCL10:	EQUAL?	PRSO,ROBOT-USE-AUTHORIZATION-FORM \?CCL19
	EQUAL?	HERE,ROBOT-POOL \?CCL19
	REMOVE	PRSO
	FSET	PRSO,NDESCBIT
	PRINT	FORM-ACCEPTED
	CALL	RECORDING,STR?95
	RSTACK	
?CCL19:	EQUAL?	PRSO,ASSIGNMENT-COMPLETION-FORM \?CCL23
	EQUAL?	HERE,DECK-TWELVE \?CCL23
	PRINT	FORM-REJECTED
	CALL	RECORDING,STR?96
	RSTACK	
?CCL23:	EQUAL?	PRSO,VILLAGE-FORM \?CCL27
	EQUAL?	HERE,SOUTH-CONNECTION,EAST-CONNECTION \?CCL27
	ZERO?	VILLAGE-FORM-VALIDATED \?CCL32
	PRINT	FORM-REJECTED
	CALL	RECORDING,STR?96
	RSTACK	
?CCL32:	ADD	SCORE,6 >SCORE
	INC	'ROBOT-EVILNESS
	FSET	IRIS-HATCH,OPENBIT
	REMOVE	PRSO
	FSET	PRSO,NDESCBIT
	PRINTR	"The hatch begins irising open, then sparks and smokes and grinds to a halt. However, it's about half dilated, wide enough to pass through. Beyond, you can see a small, dingy connecting tube, rather than the clean and brightly-lit Sub-Module connector you might have expected."
?CCL27:	EQUAL?	PRSO,ASSIGNMENT-COMPLETION-FORM,CLASS-THREE-SPACECRAFT-ACTIVATION-FORM,ROBOT-USE-AUTHORIZATION-FORM /?CTR33
	EQUAL?	PRSO,VILLAGE-FORM \?CCL34
?CTR33:	PRINT	FORM-REJECTED
	CALL	RECORDING,STR?97
	RSTACK	
?CCL34:	GETP	P?SIZE,PRSO
	LESS?	STACK,3 \?CCL38
	PRINTI	"The slot swallows"
	CALL	TPRINT-PRSO
	PRINTR	" and then spits it back."
?CCL38:	CALL	DOESNT-FIT,STR?98
	RSTACK	
?CCL3:	EQUAL?	PRSA,V?LOOK-INSIDE \FALSE
	PRINT	ONLY-BLACKNESS
	RTRUE	


	.FUNCT	BOTH-SEATS-NOT-OCCUPIED
	IN?	PROTAGONIST,PILOT-SEAT \?CCL3
	IN?	FLOYD,COPILOT-SEAT /FALSE
?CCL3:	IN?	PROTAGONIST,COPILOT-SEAT \TRUE
	IN?	FLOYD,COPILOT-SEAT /FALSE
	RTRUE	


	.FUNCT	KEYPAD-F
	EQUAL?	PRSA,V?PUSH \FALSE
	RANDOM	10
	SUB	STACK,1 >P-NUMBER
	PRINTI	"Randomly, you hit "
	PRINTN	P-NUMBER
	PRINTI	". "
	CALL	PERFORM,V?TYPE,INTNUM
	RTRUE	


	.FUNCT	FURNISHING-F
	EQUAL?	PRSA,V?LOOK-INSIDE,V?SEARCH,V?OPEN /?CTR2
	EQUAL?	PRSA,V?EXAMINE \?CCL3
?CTR2:	PRINTR	"You merely find a few personal items of little interest."
?CCL3:	EQUAL?	PRSA,V?PUT-ON,V?PUT \FALSE
	PRINTI	"The "
	PRINTD	PRSI
	PRINTI	" is such a mess that you can't find a good spot to put"
	CALL	TRPRINT,PRSO
	RSTACK	


	.FUNCT	BED-F
	EQUAL?	PRSA,V?WALK-TO \?CCL3
	CALL	GLOBAL-IN?,BED,HERE
	ZERO?	STACK \?CCL3
	PRINTR	"There's no bed here!"
?CCL3:	EQUAL?	PRSA,V?WALK-TO,V?ENTER \?CCL7
	GRTR?	SLEEPY-LEVEL,0 \?CCL10
	MOVE	PROTAGONIST,BED
	CALL	QUEUE,I-FALL-ASLEEP,22
	CALL	DEQUEUE,I-SLEEP-WARNINGS
	PRINTR	"Ahhh...the bed is soft and comfortable. You should be asleep in short order."
?CCL10:	MOVE	PROTAGONIST,BED
	PRINTR	"You are now in bed."
?CCL7:	EQUAL?	PRSA,V?EXIT,V?STAND,V?DISEMBARK /?PRD14
	EQUAL?	PRSA,V?DROP \?CCL12
?PRD14:	CALL	QUEUED?,I-FALL-ASLEEP
	ZERO?	STACK /?CCL12
	PRINTR	"But you're so tired and this bed is so comfy!"
?CCL12:	EQUAL?	PRSA,V?DROP,V?EXIT,V?LEAVE \?CCL18
	CALL	PERFORM,V?DISEMBARK,BED
	RTRUE	
?CCL18:	EQUAL?	PRSA,V?PUT-ON,V?PUT \?CCL20
	EQUAL?	PRSI,BED \?CCL20
	MOVE	PRSO,HERE
	PRINTI	"The "
	PRINTD	PRSO
	PRINTI	" bounces off the bed"
	PRINT	LANDS-ON-FLOOR
	CRLF	
	RTRUE	
?CCL20:	EQUAL?	PRSA,V?LOOK-UNDER \?CCL24
	IN?	PROTAGONIST,BED \?CCL24
	PRINTR	"You're IN the bed, so unless you have X-ray vision..."
?CCL24:	EQUAL?	PRSA,V?LOOK-UNDER \?CCL28
	EQUAL?	HERE,COMMANDERS-QUARTERS \?CCL28
	FSET?	VALIDATION-STAMP,TOUCHBIT /?CCL28
	FSET	VALIDATION-STAMP,TOUCHBIT
	MOVE	VALIDATION-STAMP,HERE
	CALL	THIS-IS-IT,VALIDATION-STAMP
	PRINTI	"You discover a "
	PRINTD	VALIDATION-STAMP
	PRINTR	"!"
?CCL28:	EQUAL?	PRSA,V?SHOOT,V?KILL,V?DRILL \FALSE
	PRINTR	"That would be a clear case of mattresscide!"


	.FUNCT	SLEEP-F
	EQUAL?	PRSA,V?TAKE,V?WALK-TO \FALSE
	CALL	V-SLEEP
	RSTACK	


	.FUNCT	I-SLEEP-WARNINGS
	IN?	WELDER,HERE \?PRD4
	GRTR?	SLEEPY-LEVEL,3 /?CCL2
?PRD4:	GRTR?	PLATO-ATTACK-COUNTER,0 \?CND1
	IN?	PLATO,HERE \?CND1
?CCL2:	CALL	QUEUE,I-HUNGER-WARNINGS,2
	RFALSE	
?CND1:	INC	'SLEEPY-LEVEL
	PRINTI	"   "
	IN?	PROTAGONIST,BED \?CCL11
	CALL	DEQUEUE,I-SLEEP-WARNINGS
	CALL	QUEUE,I-FALL-ASLEEP,16
	PRINTR	"You suddenly realize how tired you were and how comfortable the bed is. You should be asleep in no time."
?CCL11:	EQUAL?	SLEEPY-LEVEL,1 \?CCL13
	CALL	QUEUE,I-SLEEP-WARNINGS,320
	PRINTR	"You begin to feel weary. It might be time to think about finding a nice safe place to sleep."
?CCL13:	EQUAL?	SLEEPY-LEVEL,2 \?CCL15
	CALL	QUEUE,I-SLEEP-WARNINGS,160
	PRINTR	"You're really tired now. You'd better find a place to sleep real soon."
?CCL15:	EQUAL?	SLEEPY-LEVEL,3 \?CCL17
	CALL	QUEUE,I-SLEEP-WARNINGS,80
	PRINTR	"If you don't get some sleep soon you'll probably drop."
?CCL17:	EQUAL?	SLEEPY-LEVEL,4 \?CCL19
	CALL	QUEUE,I-SLEEP-WARNINGS,40
	PRINTR	"You can barely keep your eyes open."
?CCL19:	EQUAL?	HERE,BED \?CCL22
	PRINTI	"You slowly sink into a deep and blissful sleep."
	JUMP	?CND20
?CCL22:	CALL	GLOBAL-IN?,BED,HERE
	ZERO?	STACK /?CCL24
	MOVE	PROTAGONIST,BED
	PRINTI	"You climb into one of the beds and immediately fall asleep."
	JUMP	?CND20
?CCL24:	PRINT	YOU-CANT
	PRINTI	"stay awake a moment longer. You drop "
	IN?	PROTAGONIST,HERE \?CND25
	FSET?	HERE,WEIGHTLESSBIT /?CND25
	PRINTI	"to the deck and fall "
?CND25:	PRINTI	"into a deep but fitful sleep."
?CND20:	CALL	WAKING-UP
	RSTACK	


	.FUNCT	I-FALL-ASLEEP
	IN?	WELDER,HERE \?CND1
	CALL	QUEUE,I-FALL-ASLEEP,2
?CND1:	PRINTI	"   You slowly sink into a deep sleep."
	CALL	DEQUEUE,I-FALL-ASLEEP
	CALL	WAKING-UP
	RSTACK	


	.FUNCT	WAKING-UP,X,N,?TMP1
	CRLF	
	CRLF	
	IN?	PROTAGONIST,BED /?CND1
	MOVE	PROTAGONIST,HERE
?CND1:	FSET?	SPACESUIT,WORNBIT \?CCL5
	CALL	JIGS-UP,STR?105
	JUMP	?CND3
?CCL5:	EQUAL?	COURSE-PICKED,RIGHT-COURSE /?CCL7
	EQUAL?	HERE,SPACETRUCK \?CCL7
	PRINTI	"You wake up gasping for air! The "
	PRINTD	SPACETRUCK-OBJECT
	CALL	RUNNING?,I-SPACETRUCK
	ZERO?	STACK /?CCL12
	PRINTI	" is dead in uncharted space and it"
	JUMP	?CND10
?CCL12:	PRINTC	39
?CND10:	PRINTI	"s oxygen is running out!"
	CRLF	
	CALL	I-SUFFOCATE
	JUMP	?CND3
?CCL7:	EQUAL?	SPACETRUCK-COUNTER,-1 \?CCL14
	PRINTI	"A clanging noise wakes you up, and you slowly become aware that you are in the Duffy's brig, and furthermore, you are wearing the uniform of an Ensign Ninth Class! You trace the clanging noise to a pipe in your cell.
   Placing your ear against the pipe, you hear, ""Psst! Grapevine news! Some dumb kripping "
	PRINT	LFC
	PRINTI	" fell asleep on Deck Twelve in the middle of some big assignment! The poor trot-head's been broken to Ensign Ninth, and there's talk of a court-martial!""
   Sure enough, the next morning you are led in front of a firing squad. Moral: don't screw up vital assignments like picking up "
	PRINT	FORM-NAME
	CALL	JIGS-UP,STR?46
	JUMP	?CND3
?CCL14:	IN?	PROTAGONIST,HERE \?PRD18
	FSET?	DOCKING-BAY-2,TOUCHBIT \?PRD18
	MUL	DAY,40 >?TMP1
	RANDOM	100
	LESS?	?TMP1,STACK \?CTR15
?PRD18:	CALL	ULTIMATELY-IN?,OSTRICH-NIP
	ZERO?	STACK /?CCL16
	IN?	OSTRICH,HERE \?CCL16
?CTR15:	CALL	JIGS-UP,STR?106
	JUMP	?CND3
?CCL16:	RANDOM	100
	LESS?	60,STACK /?CND3
	PRINTI	"..."
	CALL	PICK-ONE,DREAMS
	PRINT	STACK
	PRINT	ELLIPSIS
?CND3:	INC	'DAY
	INC	'ROBOT-EVILNESS
	CALL	I-ROBOT-EVILNESS
	SET	'SLEEPY-LEVEL,0
	SET	'SUIT-PRESSED,FALSE-VALUE
	SET	'FLOYD-ANGUISHED,FALSE-VALUE
	RANDOM	80
	ADD	1600,STACK >INTERNAL-MOVES
	GRTR?	DAY,2 \?CCL27
	SET	'MOVES,9947
	JUMP	?CND25
?CCL27:	CALL	QUEUE,I-MESSAGE,943
	ADD	SCORE,3 >SCORE
	SET	'MOVES,INTERNAL-MOVES
?CND25:	FCLEAR	AUTO-DOOR,TOUCHBIT
	CALL	QUEUE,I-SLEEP-WARNINGS,5900
	CALL	ULTIMATELY-IN?,EXPLOSIVE,VACUUM-STORAGE
	ZERO?	STACK \?CND28
	MOVE	EXPLOSIVE,DECK-TWELVE
	CALL	REMOVE-CAREFULLY,EXPLOSIVE
	CALL	DEQUEUE,I-EXPLOSIVE-MELT
?CND28:	FSET?	HEADLAMP,ONBIT \?CND30
	FCLEAR	HEADLAMP,ACTIVEBIT
	FCLEAR	HEADLAMP,ONBIT
	SET	'HEADLAMP-COUNTER,0
?CND30:	GRTR?	SOUP-WARMTH,0 \?CND32
	FSET?	THERMOS,OPENBIT \?CCL36
	SET	'SOUP-WARMTH,0
	JUMP	?CND32
?CCL36:	SUB	SOUP-WARMTH,30 >SOUP-WARMTH
?CND32:	FSET	OSTRICH,TOUCHBIT
	CALL	ROB,PROTAGONIST,HERE
	USL	
	PRINTI	"***** NOVEM "
	ADD	DAY,3
	PRINTN	STACK
	PRINTI	", 11349 *****"
	CRLF	
	CRLF	
	PRINTI	"You awake "
	ZERO?	LIT \?CCL39
	PRINTI	"in darkness."
	JUMP	?CND37
?CCL39:	CALL	QUEUED?,I-LIGHTS-OUT
	ZERO?	STACK /?CCL41
	CALL	DEQUEUE,I-LIGHTS-OUT
	CALL	I-LIGHTS-OUT,TRUE-VALUE
	PRINTI	"slowly, aware that something has changed. Aha! The lights have all gone out while you slept!"
	JUMP	?CND37
?CCL41:	LOC	PROTAGONIST
	EQUAL?	STACK,BED,PILOT-SEAT,COPILOT-SEAT \?CCL43
	PRINTI	"feeling refreshed and ready to face anything this new day might care to throw at you."
	JUMP	?CND37
?CCL43:	PRINTI	"and slowly stand up, feeling stiff from your uncomfortable night's sleep."
?CND37:	EQUAL?	DAY,4 \?CND44
	FSET?	SAFE,OPENBIT /?CCL48
	CALL	QUEUE,I-LIGHTS-OUT,177
	JUMP	?CND44
?CCL48:	CALL	QUEUED?,I-ANNOUNCEMENT
	ZERO?	STACK \?CND44
	CALL	QUEUE,I-ANNOUNCEMENT,383
?CND44:	GRTR?	HUNGER-LEVEL,0 \?CCL52
	SET	'HUNGER-LEVEL,3
	CALL	QUEUE,I-HUNGER-WARNINGS,200
	PRINTI	" You're also incredibly famished. Better get some breakfast!"
	JUMP	?CND50
?CCL52:	CALL	QUEUE,I-HUNGER-WARNINGS,400
?CND50:	CRLF	
	CALL	RUNNING?,I-SPACETRUCK
	ZERO?	STACK /?CND53
	EQUAL?	COURSE-PICKED,RIGHT-COURSE \?CND53
	CALL	QUEUE,I-WELDER,-1
	CALL	DEQUEUE,I-SPACETRUCK
	FCLEAR	SPACETRUCK,WEIGHTLESSBIT
	ADD	SCORE,5 >SCORE
	SET	'SPACETRUCK-COUNTER,5
	PRINTI	"   You notice that, while you slept, the truck has docked itself in one of the space station's docking bays."
	CRLF	
?CND53:	EQUAL?	DAY,3 \?CND57
	FCLEAR	ELEVATOR,WEIGHTLESSBIT
	FSET	EXERCISE-MACHINE,TOUCHBIT
	MOVE	EXERCISE-MACHINE,COMPUTER-CONTROL
	CALL	ROB,EXERCISE-MACHINE,GYM
	FSET?	CHRONOMETER,WORNBIT \?CND57
	PRINTI	"   "
	CALL	PERFORM,V?EXAMINE,CHRONOMETER
?CND57:	FSET?	FLOYD,ACTIVEBIT \?CND61
	IN?	FLOYD,FACTORY /?CND61
	EQUAL?	HERE,AIRLOCK /?CND61
	SET	'FLOYD-SPOKE,TRUE-VALUE
	PRINTI	"   Floyd "
	GRTR?	ROBOT-EVILNESS,13 \?CCL68
	PRINTI	"is rudely kicking you"
	IN?	PROTAGONIST,BED \?CND69
	PRINTI	"r mattress"
?CND69:	PRINTI	". ""Trot it! Will you kripping wake up already? Floyd getting bored!"""
	CRLF	
	JUMP	?CND66
?CCL68:	PRINTI	"bounces impatiently at "
	IN?	PROTAGONIST,BED \?CCL73
	PRINTI	"the foot of the bed"
	JUMP	?CND71
?CCL73:	PRINTI	"your side"
?CND71:	ZERO?	PLATO-INTRODUCED /?CND74
	ZERO?	PLATO-ATTACK-COUNTER \?CND74
	MOVE	PLATO,HERE
	PRINTI	". Plato is nearby, leafing through his book"
?CND74:	ZERO?	PLATO-INTRODUCED \?CCL80
	PRINTI	", along with a slightly older-looking robot. ""Wake up and meet Floyd's new friend,"" says Floyd with unbounded exuberance and a wide grin."
	CRLF	
	CALL	I-PLATO,TRUE-VALUE
	JUMP	?CND66
?CCL80:	PRINTI	". ""About time you woke up, you lazy "
	GRTR?	ROBOT-EVILNESS,9 \?CCL83
	PRINTI	"slob!"" says Floyd. ""It's getting pretty trotting dull around he"
	JUMP	?CND81
?CCL83:	PRINTI	"bones!"" says Floyd. ""Let's explore around some mo"
?CND81:	PRINTI	"re!"""
	CRLF	
?CND66:	MOVE	FLOYD,HERE
?CND61:	ZERO?	LIT /FALSE
	CRLF	
	CALL	V-LOOK
	RSTACK	


	.FUNCT	I-HUNGER-WARNINGS
	GRTR?	PLATO-ATTACK-COUNTER,0 \?CND1
	IN?	PLATO,HERE \?CND1
	CALL	QUEUE,I-HUNGER-WARNINGS,2
	RFALSE	
?CND1:	INC	'HUNGER-LEVEL
	PRINTI	"   "
	EQUAL?	HUNGER-LEVEL,1 \?CCL7
	CALL	QUEUE,I-HUNGER-WARNINGS,450
	PRINTR	"A growl from your stomach warns that you're getting pretty hungry and thirsty."
?CCL7:	EQUAL?	HUNGER-LEVEL,2 \?CCL9
	CALL	QUEUE,I-HUNGER-WARNINGS,300
	PRINTR	"You're now really ravenous and your lips are quite parched."
?CCL9:	EQUAL?	HUNGER-LEVEL,3 \?CCL11
	CALL	QUEUE,I-HUNGER-WARNINGS,150
	PRINTR	"You're starting to feel faint from lack of food and liquid."
?CCL11:	EQUAL?	HUNGER-LEVEL,4 \?CCL13
	CALL	QUEUE,I-HUNGER-WARNINGS,150
	PRINTR	"If you don't eat or drink something in a few millichrons, you'll probably pass out."
?CCL13:	EQUAL?	HUNGER-LEVEL,5 \FALSE
	CALL	JIGS-UP,STR?107
	RSTACK	


	.FUNCT	WELDER-F
	EQUAL?	PRSA,V?EXAMINE \?CCL3
	EQUAL?	WELDER-COUNTER,1 \?CCL6
	PRINTI	"This welder, which is marked ""Welder Number "
	GET	WELDER-TABLE,WELDER-TABLE-POINTER
	PRINTN	STACK
	PRINTR	","" seems to be moving purposefully toward you, its welding extensions quivering with...excitement?"
?CCL6:	EQUAL?	WELDER-COUNTER,2 \?CCL8
	PRINTR	"There definitely seems to be something menacing about its behavior."
?CCL8:	PRINTR	"The welder is now almost upon you!"
?CCL3:	EQUAL?	PRSA,V?WHAT \?CCL10
	PRINTI	"A "
	PRINTD	WELDER
	PRINTI	" is a very simple machine which repairs any leaks or holes in the hull of any sort of space habitat. Because of the potentially catastrophic effects of a break in the integrity of a hull on the habitat's air supply, "
	PRINTD	WELDER
	PRINTR	"s are kept active at all times, roaming around with their sensing devices alert for the tiniest leak."
?CCL10:	EQUAL?	PRSA,V?SHOOT \?CCL12
	REMOVE	WELDER
	GET	WELDER-TABLE,NUMBER-OF-WELDERS
	PUT	WELDER-TABLE,WELDER-TABLE-POINTER,STACK
	DEC	'NUMBER-OF-WELDERS
	SET	'WELDER-COUNTER,0
	ZERO?	NUMBER-OF-WELDERS \?CND13
	CALL	DEQUEUE,I-WELDER
?CND13:	PRINTI	"The welder is enveloped by red-hot plasma rays. It glows ever brighter in the heat of the rays, seems to shimmer like a mirage, and then suddenly vanishes! A wave of hot vapor pushes you backwards."
	CALL	VISIBLE?,EXPLOSIVE
	ZERO?	STACK /?CND15
	PRINTI	" As the heat wave hits the explosive, it "
	PRINT	SUBLIMES-INTO-FREZONE
	CALL	REMOVE-CAREFULLY,EXPLOSIVE
?CND15:	IN?	OSTRICH,HERE \?CCL19
	FSET?	OSTRICH,TOUCHBIT \?CCL19
	PRINTC	32
	CALL	PERFORM,V?SCARE,OSTRICH
	RSTACK	
?CCL19:	CRLF	
	RTRUE	
?CCL12:	EQUAL?	PRSA,V?OFF \?CCL23
	PRINTR	"There's no apparent on-off switch."
?CCL23:	EQUAL?	PRSA,V?ON \?CCL25
	PRINTR	"It is!"
?CCL25:	EQUAL?	PRSA,V?MUNG,V?KILL \FALSE
	PRINTR	"It's doubtful that you could even make a dent in the welder."


	.FUNCT	I-WELDER
	IN?	WELDER,HERE \?CCL3
	PRINTI	"   "
	INC	'WELDER-COUNTER
	ZERO?	LIT \?CCL6
	REMOVE	WELDER
	SET	'WELDER-COUNTER,0
	PRINTC	89
	PRINT	HEAR-WELDER-LEAVE
	RTRUE	
?CCL6:	EQUAL?	WELDER-COUNTER,2 \?CCL8
	PRINTI	"The welder moves closer. "
	JUMP	?CND4
?CCL8:	EQUAL?	WELDER-COUNTER,3 /?CND4
	CALL	JIGS-UP,STR?108
?CND4:	CALL	PERFORM,V?EXAMINE,WELDER
	RSTACK	
?CCL3:	GRTR?	WELDER-COUNTER,0 \?CCL11
	REMOVE	WELDER
	SET	'WELDER-COUNTER,0
	PRINTI	"   Nearby, y"
	PRINT	HEAR-WELDER-LEAVE
	RTRUE	
?CCL11:	FSET?	HERE,NWELDERBIT /FALSE
	IN?	PROTAGONIST,BED /FALSE
	ZERO?	LIT /FALSE
	RANDOM	100
	LESS?	NUMBER-OF-WELDERS,STACK /FALSE
	GRTR?	PLATO-ATTACK-COUNTER,0 \?CCL20
	IN?	PLATO,HERE /FALSE
?CCL20:	EQUAL?	HERE,SPACETRUCK \?CND18
	FSET?	SPACETRUCK-HATCH,OPENBIT \FALSE
?CND18:	MOVE	WELDER,HERE
	INC	'WELDER-COUNTER
	RANDOM	NUMBER-OF-WELDERS >WELDER-TABLE-POINTER
	PRINTI	"   You spot a "
	PRINTD	WELDER
	PRINTI	" approaching. "
	FSET?	WELDER,TOUCHBIT /?CND26
	FSET	WELDER,TOUCHBIT
	CALL	PERFORM,V?WHAT,WELDER
?CND26:	CALL	PERFORM,V?EXAMINE,WELDER
	CALL	STOP
	RSTACK	


	.FUNCT	TOUCHING?,THING
	EQUAL?	PRSO,THING \?CCL3
	EQUAL?	PRSA,V?TAKE,V?TOUCH,V?SHAKE /TRUE
	EQUAL?	PRSA,V?CLEAN,V?KISS,V?ENTER /TRUE
	EQUAL?	PRSA,V?PUSH,V?CLOSE,V?LOOK-UNDER /TRUE
	EQUAL?	PRSA,V?MOVE,V?OPEN,V?KNOCK /TRUE
	EQUAL?	PRSA,V?SET,V?SHAKE,V?RAISE /TRUE
	EQUAL?	PRSA,V?UNLOCK,V?LOCK,V?HUG /TRUE
	EQUAL?	PRSA,V?CLIMB-UP,V?CLIMB-DOWN,V?CLIMB-ON /TRUE
	EQUAL?	PRSA,V?ON,V?OFF,V?THROW /TRUE
	EQUAL?	PRSA,V?TASTE,V?BITE,V?TICKLE /TRUE
	EQUAL?	PRSA,V?LOOK-INSIDE,V?STAND-ON,V?TIE /TRUE
	EQUAL?	PRSA,V?MUNG,V?KICK,V?KILL /TRUE
	EQUAL?	PRSA,V?KNOCK,V?CUT,V?PUSH /TRUE
	EQUAL?	PRSA,V?SEARCH /TRUE
?CCL3:	EQUAL?	PRSI,THING \FALSE
	EQUAL?	PRSA,V?PUT-ON,V?PUT,V?GIVE /TRUE
	RFALSE	


	.FUNCT	CANT-SEE,OBJ
	SET	'P-WON,FALSE-VALUE
	PRINT	YOU-CANT
	PRINTI	"see"
	CALL	NAME?,OBJ
	ZERO?	STACK \?CND1
	PRINTI	" any"
?CND1:	EQUAL?	OBJ,PRSI \?CCL5
	CALL	PRSI-PRINT
	JUMP	?CND3
?CCL5:	CALL	PRSO-PRINT
?CND3:	PRINTI	" here."
	CRLF	
	CALL	STOP
	RSTACK	


	.FUNCT	CANT-VERB-A-PRSO,STRING
	PRINT	YOU-CANT
	PRINT	STRING
	CALL	APRINT,PRSO
	PRINTR	"!"


	.FUNCT	TELL-HIT-HEAD
	PRINTI	"You hit your head against"
	CALL	TPRINT-PRSO
	PRINTR	" as you attempt this."


	.FUNCT	REMOVE-CAREFULLY,OBJ,ALSO=0
	ZERO?	TIMER-CONNECTED /?CCL3
	EQUAL?	OBJ,TIMER,DETONATOR \?CCL3
	SET	'TIMER-CONNECTED,FALSE-VALUE
	SET	'ALSO,TRUE-VALUE
	CALL	VISIBLE?,DETONATOR
	ZERO?	STACK /?CND1
	PRINTI	" (The timer is"
	PRINT	NO-LONGER-ATTACHED
	JUMP	?CND1
?CCL3:	ZERO?	EXPLOSIVE-CONNECTED /?CND1
	EQUAL?	OBJ,EXPLOSIVE,DETONATOR \?CND1
	SET	'EXPLOSIVE-CONNECTED,FALSE-VALUE
	CALL	VISIBLE?,DETONATOR
	ZERO?	STACK /?CND1
	PRINTI	" (The explosive is"
	ZERO?	ALSO /?CND13
	PRINTI	" also"
?CND13:	PRINT	NO-LONGER-ATTACHED
?CND1:	FSET	OBJ,TOUCHBIT
	FCLEAR	OBJ,TRYTAKEBIT
	REMOVE	OBJ
	RTRUE	


	.FUNCT	NOUN-USED,TEST-NOUN,OBJ
	EQUAL?	PRSO,OBJ \?CCL3
	GET	P-NAMW,0
	EQUAL?	STACK,TEST-NOUN /TRUE
?CCL3:	EQUAL?	PRSI,OBJ \FALSE
	GET	P-NAMW,1
	EQUAL?	STACK,TEST-NOUN /TRUE
	RFALSE	


	.FUNCT	ADJ-USED,TEST-ADJ,OBJ
	EQUAL?	PRSO,OBJ \?CCL3
	GET	P-ADJW,0
	EQUAL?	TEST-ADJ,STACK /TRUE
?CCL3:	EQUAL?	PRSI,OBJ \FALSE
	GET	P-ADJW,1
	EQUAL?	TEST-ADJ,STACK /TRUE
	RFALSE	


	.FUNCT	OPEN-CLOSED,OBJ
	FSET?	OBJ,OPENBIT \?CCL3
	PRINTI	"open"
	RTRUE	
?CCL3:	PRINTI	"closed"
	RTRUE	


	.FUNCT	WEE
	SET	'AWAITING-REPLY,1
	ADD	C-ELAPSED,2
	CALL	QUEUE,I-REPLY,STACK
	PRINTR	"Wasn't that fun?"


	.FUNCT	CANT-REACH,OBJ
	PRINT	YOU-CANT
	PRINTI	"reach"
	CALL	TPRINT,OBJ
	ZERO?	HANGING-IN-AIR /?CCL3
	PRINTI	" while you're hanging way up here"
	JUMP	?CND1
?CCL3:	IN?	PROTAGONIST,HERE /?CCL5
	PRINTI	" from"
	LOC	PROTAGONIST
	CALL	TPRINT,STACK
	JUMP	?CND1
?CCL5:	EQUAL?	PRSO,HELEN,REX,FLOYD \?CND1
	EQUAL?	PRSO,ROBOT-PICKED /?CND1
	PRINTI	" from outside the bin"
?CND1:	PRINT	PERIOD-CR
	CALL	STOP
	RSTACK	


	.FUNCT	DO-FIRST,STRING,OBJ=0
	PRINT	YOULL-HAVE-TO
	PRINT	STRING
	ZERO?	OBJ /?CND1
	CALL	TPRINT,OBJ
?CND1:	PRINTI	" first."
	CRLF	
	CALL	STOP
	RSTACK	


	.FUNCT	DOESNT-FIT,STRING
	PRINTI	"Unsurprisingly,"
	CALL	TPRINT-PRSO
	PRINTI	" doesn't fit the "
	PRINT	STRING
	PRINT	PERIOD-CR
	RTRUE	


	.FUNCT	NOT-IN
	PRINTI	"But"
	CALL	TPRINT-PRSO
	PRINTI	" isn't "
	FSET?	PRSI,ACTORBIT \?CCL3
	PRINTI	"being held by"
	JUMP	?CND1
?CCL3:	FSET?	PRSI,SURFACEBIT \?CCL5
	PRINTI	"on"
	JUMP	?CND1
?CCL5:	PRINTI	"in"
?CND1:	CALL	TRPRINT,PRSI
	RSTACK	


	.FUNCT	CANT-USE-THAT-WAY,STRING
	PRINTC	91
	PRINT	YOU-CANT
	PRINTI	"use "
	PRINT	STRING
	PRINTR	" that way.]"


	.FUNCT	RECOGNIZE
	SET	'P-WON,FALSE-VALUE
	PRINTR	"[That sentence isn't one I recognize.]"


	.FUNCT	PRONOUN
	EQUAL?	PRSO,ME \?CCL3
	PRINTI	"You"
	RTRUE	
?CCL3:	FSET?	PRSO,PLURALBIT \?CCL5
	PRINTI	"They"
	RTRUE	
?CCL5:	FSET?	PRSO,ACTORBIT \?CCL7
	PRINTI	"He"
	RTRUE	
?CCL7:	PRINTI	"It"
	RTRUE	


	.FUNCT	REFERRING,HIM-HER=0
	PRINTI	"I don't see wh"
	ZERO?	HIM-HER /?CCL3
	PRINTC	111
	JUMP	?CND1
?CCL3:	PRINTI	"at"
?CND1:	PRINTR	" you're referring to."


	.FUNCT	ANTI-LITTER,OBJ
	REMOVE	OBJ
	PRINTI	". The "
	EQUAL?	OBJ,LEASH \?CCL3
	PRINTI	"leash"
	JUMP	?CND1
?CCL3:	PRINTI	"cup"
?CND1:	PRINTI	" instantly vaporizes, part of the galactic anti-litter program."
	EQUAL?	OBJ,LEASH /TRUE
	CRLF	
	RTRUE	

	.ENDI
