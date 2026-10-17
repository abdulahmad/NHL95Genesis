;	Shared equates. These name hardware constants and game values
;	that every module uses.

PAL_MODE equ 0
; ----------------------------------
; ------------- game equates named like NHLPA93Genesis ram93.asm -------------
MaxSprites equ 64		;max sprites during game (64 because 32 col mode)

;joystick button equates (bit numbers)
ubut equ 0		;up
dbut equ 1		;down
lbut equ 2		;left
rbut equ 3		;right
bbut equ 4		;b button
cbut equ 5		;c button
abut equ 6		;a button
sbut equ 7		;start button
osflag equ 20000		;flag for off screen graphic ($4E20)

goalline equ 176		;distance from blue line to goalline
Blueline equ $58		;distance from center line to blueline
Sideline equ $88		;distance from center to side boards
replaystart equ $FFFF0000		;start of ram area for replay frames, also the start of RAM
scsize equ 7		;2 to this power indicates ram needed for each sortobj
jps equ 24		;jiffys per second
jiffy equ $10000/jps
maxros equ 26		;roster slots per team in the team structure
ifcgl equ 0		;iflags: crossed goalline
ifdir equ 1		;iflags: 1=must cross top line
ifok equ 2		;iflags: icing
tmflcc equ 0		;tmflags: line change on
;flag bits added in 93 and shared by the later games (names and meanings from NHLPA93Genesis ram93.asm)
dffaceoff equ 4		;face off sprites on (92 tested sf2faceoff).
gmeog equ 6		;game over reached: the next face off goes to PeriodOver
pf2inj equ 6		;player is injured (SPAfinjury animation, max speed 1/8).
pf2lcm equ 3		;line change mode. 92 bit 5
pf2npc equ 5		;no player collision. 92 bit 7
pf2pen equ 4		;player has caused a penalty. 92 bit 6
pf2unav equ 2		;player is unavailable (going to/from bench/penalty). 92 bit 4
pfrev equ 4		;skating backwards
sf2refref equ 1		;ref needs refresh
sf3alttree equ 2		;alt. tree
sf3fo equ 4		;face off just ended (set by the drop): the next puck pickup wins it, with a crowd cheer.
sf3icetime equ 6		;set once a second by updatepentime: each player on the ice adds 1 to its time on ice.
sf3llcs equ 0		;lower line change sel.
sf3track equ 5		;the scroll window tracks an object.
tmflast equ 3		;next touch overwrites the last touch only.
tmflcm equ 1		;team is in line change mode (92 scanned the players for pf2lcm)
tmfoside equ 4		;team is offsides (92 flagged the player with pf3oside)
tmftimeout equ 2		;timeout used (the pause menu drops Timeout from then on). Same bit as tmfmid and tmfslide
tmfmid equ tmftimeout		;nearest player always takes the in-between spot (assnearest)
sf3fosong equ 7		;set for periods 1 and 2: play the face off tune once, at the first face off past half the period
gmstars equ 7		;the Stars of the Game box was already shown
; ----------------------------------
; Structure and flag equates. Empty until the first segment confirms the 95 values.

;the sort object structure (SCstruct = $80 bytes each, from SortCords). updateplayers confirms these 95 values
SCstruct equ 1<<scsize
puckscnum equ $E	;the puck sort object (SortCords + puckscnum * SCstruct = puckx); the shadow is puckscnum+1
Xpos equ $0
attribute equ $4		;frame attribute switch bits
frame equ $6		;alice frame number
oldframe equ $8		;last frame
VRoffs equ $A		;offsets to find each sprites start char. (max of 6 sprites / frame)
VRchar equ $12		;vram char for graphic
Ypos equ $14
Zpos equ $18
OldXpos equ $1C
OldYpos equ $20
OldZpos equ $24
Xvel equ $28
Yvel equ $2A
Zvel equ $2C
impactp equ $2E		;last player to cause impact
limpact equ $30		;last impact value
impact equ $32		;impact value
position equ $34		;player's position (0=goalie,1=l.def,2=r.def,3=l.wing,4=center,5=r.wing)
assnum equ $36		;index to current assignment
asslist equ $38		;list of assignments in order of execution
temp1 equ $40
temp2 equ $42
temp3 equ $44
temp4 equ $46
temp5 equ $48
radiusx equ $4A		;width of this graphic
radiusy equ $4C		;height of this graphic
Wallcos equ $4E		;cos of angle of last collision
Wallsin equ $50		;sin of angle of last collision
SCnum equ $52		;index number for this struct
facedir equ $54		;direction of facing
SPA equ $58		;animation (SPA offset)
SPAnum equ $5A		;index into animation
SPAcnt equ $5C		;count down to next frame of animation
nopuck equ $5E		;no puck coll until zero
newpos equ $60		;requested next position of this player
newpnum equ $61		;requested next player (from roster) for this player
pflags equ $62
pfdoff equ 0		;bit0-deceleration off
pfnc equ 2		;bit2-no collision mode
pfna equ 1		;bit1-new assignment
pfjoycon equ 3		;is player joystick controlled
pfteam equ 6		;0-home(sprite0-5)/1-visitors(sprite6-11)
pfgoal equ 7		;0=bottom, 1=top (to shoot at)
pfalock equ 5		;lock out until anim is done
pflags2 equ $63
pf2aip equ 1		;animation in progress wait
pf2fight equ 0		;player is fighting (93; 94 has no fights)
glitch equ $65		;counter to eliminate quick frame changes (de-glitch graphics)
rostnum equ $6F
pnum equ $66		;player's team location number
aioff equ $6A		;offense rating
aidef equ $6B		;defense rating
spodds equ $70
weight equ $67
legstr equ $68
legspd equ $69
shotspd equ $6C
shotacc equ $6D
passacc equ $6E
stickhand equ $71
endurance equ $72
handed equ $76		;bit0 set is left handed
;player struct fields after handed's neighbours, not named in 93 (names from the 92/93/94 comments)
pflags3 equ $64		;player flags 3 (92: not used)
pf3oside equ 0		;offsides
pf3break equ 1		;on a breakaway
pf3gctrl equ 2		;goalie control
pf3onetimer equ 3	;doing a one-timer
pf3wall equ 4		;wall collision
pf3fall equ 5		;falling down
aggress equ $73		;aggression (Agr; goalie: glove left)
fighting equ $74		;fighting (Fgt; from the Chk/Hnd byte, always even)
checking equ $75		;checking (Chk)

;bit numbers in gmode
gmclock equ 0		;game clock is stopped
gmdir equ 1		;0 = home team goes up
gmpen equ 2		;penalty has been called
gmpendel equ 3		;delayed penalty has been called
gmhl equ 4		;hilight mode
gmoffs equ 5		;offsides on
;bit numbers in disflags
dfok equ 0		;graphics are ready for transfer
df32c equ 1		;32 column mode on
dfng equ 2		;don't int graphics
dfclock equ 3		;clock needs update
;bit numbers in sflags
sfpz equ 0		;pause mode
sfspdir equ 2		;set pass dir mode
sfssdir equ 3		;set shot dir mode
sfslock equ 6		;scroll lock to xc1/yc1
sfscrl equ 5		;replay scroll is manual cont
sfwrap equ 4		;replay has wrapped around
sfhor equ 7		;screen is in horizontal mode
;bit numbers in sflags2
sf2faceoff equ 0		;face off in progress
sf2drec equ 2		;disable replay record
sf2replay equ 3		;replay in progress
sf2shot equ 4		;shot was taken
sf2pwrplay equ 5		;power play in progress
sf2pwrtm equ 6		;0 for team 1 in power play
sf2offsig equ 7		;offsides little ref on
sf3rmplay equ 1		;play mode on for replay (sflags3)

;team variables (HmShots / AwShots = the home / away team struct). confirms these 95 values
tmshots equ $0		;shots stat (and offsets $0-$A)
tmPwrGoals equ $2		;power play goals stat
tmPwrPlays equ $4		;power plays stat
tmPenalties equ $6		;penalties stat
tmPenmin equ $8		;penalty min. stat
tmATOP equ $A		;attack time of possesion stat
tmscore equ $C		;score
tmline equ $16		;current line
tmap equ $24		;active players on ice 4-6
tmdata equ $1E		;team data address
tmsort equ $22		;address of first sort obj (word)
tmgoalie equ $26		;goalie 1/2/none
tmpde equ $34		;energy level of each roster player (94: $32)
tmpdst equ $68		;-2=bench/-1=ice/0+=penalty box (94: $66)
tmflags equ $30		;flags
tmsize equ $366		;$364

;text control codes in Strings
;print / printz / printbig / printbigz: a negative byte -(TXPRI+TXPALn+TXVF+TXHF+TXMAPn), then x, y (printa = the bits << 9, printm = map)
TXMAP1 equ 1		;plane map 1
TXMAP2 equ 2
TXMAP3 equ 3
TXHF equ 4		;h flip
TXVF equ 8		;v flip
TXPAL1 equ $10		;palette 1
TXPAL2 equ $20
TXPAL3 equ $30
TXPRI equ $40		;high priority
;printsmall / printz2 (ControlCodeJumpTable, -byte): the code, then its argument bytes
CC_SetMap equ $FF		;-1: map
CC_SetAttribute equ $FE		;-2: palette/priority (printa)
CC_SetX equ $FD		;-3: printx
CC_SetY equ $FC		;-4: printy
CC_AddX equ $FB		;-5: add signed byte to printx
CC_AddY equ $FA		;-6: add signed byte to printy
CC_SetFont equ $F9		;-7: char set
CC_SetMapAndPosition equ $F8		;-8: attribute, map, x, y

;game sound effect numbers (sfx / song argument). 95 maps them through SfxTable
SFXsiren equ $0
SFXbeep1 equ $1
SFXbeep2 equ $2
SFXwhistle equ $3
SFXhorn equ $4
SFXshotwiff equ $5
SFXstdef equ $6
SFXpuckget equ $7
SFXoooh equ $8
SFXhithigh equ $9
SFXhitlow equ $A
SFXcrowdcheer equ $B
SFXcrowdboo equ $C
SFX0D equ $D
SFX0E equ $E
SFXhomewin equ $F		;home team won
SFXpass equ $10		;4 variants, +0-3
SFXshotbh equ $14		;+0-3
SFXshotfh equ $18		;+0-3
SFXcheck equ $1C		;+0-3
SFXplayerwall equ $20
SFX21 equ $21
SFX22 equ $22
SFX23 equ $23
SFXpuckbody equ $24
SFXpuckpost equ $25
SFX26 equ $26
SFX27 equ $27
SFXpuckwall1 equ $28		;+0-3
SFXpuckice equ $2C		;+0-3
;SoundBanks item types (SndItem)
SB_PATCH equ 0
SB_SAMPLE equ 1
SB_SONG equ 3
SB_LIST equ $B


; team numbers (TeamList order in teamdata): schedule, playoffseats and other team-indexed tables
ANH equ 0
BOS equ 1
BUF equ 2
CGY equ 3
CHI equ 4
DAL equ 5
DET equ 6
EDM equ 7
FLA equ 8
HFD equ 9
LA equ 10
MTL equ 11
NJ equ 12
NYI equ 13
NYR equ 14
OTW equ 15
PHI equ 16
PIT equ 17
QUE equ 18
SJ equ 19
STL equ 20
TB equ 21
TOR equ 22
VAN equ 23
WSH equ 24
WPG equ 25
ASE equ 26
ASW equ 27
NumTeams equ ASW+1		;TeamList length, All-Star teams included
NumPlayoffTeams equ ASE		;teams in the standings, schedule and sim tables
	IF 32<NumPlayoffTeams
	inform 3,"More than 32 playoff teams"
	ENDIF