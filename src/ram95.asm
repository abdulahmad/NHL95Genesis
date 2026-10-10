;	NHL 95 RAM map. Equates only, no ROM bytes. 68000 work RAM is $FFFF0000-$FFFFFFFF (M68K_RAM).
;	Included by nhl95.asm and by every segment stub, so a name defined here is visible to both builds.
;	Names follow ram94.asm when the address and the using routine match; the comment gives the 94 address,
;	or says 95 only. Keep the entries in address order.

AwardIds	equ	$FFFF0000	;95 only. SeasonAwards: the candidate ids (players, or teams), sorted with AwardScores. Shares M68K_RAM
M68K_RAM	equ	$FFFF0000
AwardScores	equ	$FFFF0548	;95 only. SeasonAwards: the candidate scores (ScanAllPlayers, SortAwardScores)
TradeBuf	equ	$FFFF1388	;95 only. Trade: work buffer
RosterTable	equ	$FFFF1B4C	;95 only. Season rosters ($38 bytes a team, save RAM $1B4C): roster ids, then the goalie, forward and defense counts
TradeData	equ	$FFFF2710	;95 only. Trade screen state (list sizes, cursors, chosen counts)
TradeWork	equ	$FFFF2AF8	;95 only. Trade screen work words
TradeRoster1	equ	$FFFF3A98	;95 only. Trade screen: HomeTeam roster rows
DefaultLines	equ	$FFFF3E14	;95 only. The default line sets of the 28 teams, $64 bytes each (DefaultLineData copies them from TeamList)
CreatedIds	equ	$FFFF4E20	;95 only. Created player ids (ReadCreatedPlayers)
createdcount	equ	$FFFF55F0	;95 only. Created players read from save RAM (ReadCreatedPlayers)
CreateListTop	equ	$FFFF55F4	;95 only. Create player list: first row shown
CreateListSel	equ	$FFFF55F8	;95 only. Create player list: selected row
CreateWork	equ	$FFFF55FC	;95 only. Create player: name work count
CreateIndex	equ	$FFFF55FE	;95 only. Create player: the record being edited
RosterRatings	equ	$FFFF5700	;95 only. Default roster ratings ($20 bytes a team, DefaultRosters)
CreatedList	equ	$FFFF5D22	;95 only. Created player list ($36 bytes, save RAM $5D22)
CreateCursorX	equ	$FFFF7530	;95 only. Modify Ratings cursor column
CreateCursorY	equ	$FFFF7532	;95 only. Modify Ratings cursor row
CreateType	equ	$FFFF7534	;95 only. Created player type: 0 goalie, else skater
CreatePoints	equ	$FFFF7536	;95 only. Create player: unallocated attribute points (IDA word_FF7536)
CreateRecord	equ	$FFFF7538	;95 only. Created player record (32 bytes; the name from +2)
TradeRoster2	equ	$FFFF88B8	;95 only. Trade screen: VisTeam roster rows
LeaderPlayers	equ	$FFFF9C60	;95 only. League Leaders: player ids, sorted with LeaderValues
LeaderValues	equ	$FFFFA1AA	;95 only. League Leaders: player values (GatherAndSort)
replayend	equ	$FFFFAB80	;94 $FFFFAF54. End of the replay frames ($62 bytes each from M68K_RAM); updatereplay, suba4 and adda43 wrap here
VSCRLPM	equ	$FFFFAC00	;94 $FFFFB000. Hscroll table vram address (VDP reg $0D); first long Begin clears
VSPRITES	equ	$FFFFAC02	;94 $FFFFB002. Sprite table vram address (VDP reg $05)
VmMap1	equ	$FFFFAC04	;94 $FFFFB004. Plane A vram address, then the map size shift (xyVmMap reads printm(VmMap1))
Map1col1	equ	$FFFFAC06	;94 $FFFFB006
VmMap2	equ	$FFFFAC08	;94 $FFFFB008. Plane B vram address
Map2col1	equ	$FFFFAC0A	;94 $FFFFB00A
VmMap3	equ	$FFFFAC0C	;94 $FFFFB00C. Window vram address
Map3col1	equ	$FFFFAC0E	;94 $FFFFB00E
bigfontptr	equ	$FFFFAC10	;95 only. Address of the big font map printbig uses
BigFontChars	equ	$FFFFAC14	;94 $FFFFB010. First vram char of the big font
smallfontchars	equ	$FFFFAC16	;94 $FFFFB012. First vram char of the small font (AddSmallFont)
smallfont2chars	equ	$FFFFAC18	;94 $FFFFB014. Second small font chars (the pause font with another remap)
smallfont3chars	equ	$FFFFAC1A	;95 only. Third small font chars (the highlight remap)
smallfont4chars	equ	$FFFFAC1C	;95 only. Fourth small font chars (DrawTeamScreen2 ... 4)
smallfontptr	equ	$FFFFAC1E	;95 only. Address of the small font map AddSmallFont loads
pauselogochars	equ	$FFFFAC22	;95 only. Pause screen: chars of the info page bitmap
tabchars	equ	$FFFFAC24	;95 only. Pause screen: chars of the tab bitmap (DrawTab)
clockdigitchars	equ	$FFFFAC26	;95 only. First vram char of the big clock digits (PutClockDigit)
energybarchars	equ	$FFFFAC28	;94 $FFFFB016
rinkvrcset	equ	$FFFFAC2A	;94 $FFFFB018. First vram char of the rink tiles
gamesetuptilesetindex	equ	$FFFFAC2C	;94 $FFFFB01A. Crowd tiles 1st vram char
faceoffvrcset	equ	$FFFFAC2E	;94 $FFFFB01C
framercset	equ	$FFFFAC30	;94 $FFFFB01E. First vram char of the framer tiles (AddFramer)
EASNcset	equ	$FFFFAC32	;94 $FFFFB020
basetileoffset	equ	$FFFFAC34	;94 $FFFFB022. Team block chars (setupTeamBlocksMap)
spritechars	equ	$FFFFAC36	;94 $FFFFB024
ExtraChars	equ	$FFFFAC38	;94 $FFFFB026
ReplayIconChars	equ	$FFFFAC3A	;95 only. VRAM char of the replay icon (ReplayMode loads it after ReplayMap)
framermapptr	equ	$FFFFAC3C	;95 only. Address of the framer map Framer reads (AddFramer, AddFramer2)
printx	equ	$FFFFAC40	;94 $FFFFB028
printy	equ	$FFFFAC42	;94 $FFFFB02A
printa	equ	$FFFFAC44	;94 $FFFFB02C. Print attribute (palette / priority bits)
printm	equ	$FFFFAC46	;94 $FFFFB02E. Print map offset from VmMap1
printfontset	equ	$FFFFAC48	;94 $FFFFB030. Char set index of printsmall (ControlCode_SetFont)
fodropx	equ	$FFFFAC4A	;94 $FFFFB032. Faceoff window x (DrawFaceoffWindow)
fodropy	equ	$FFFFAC4C	;94 $FFFFB034
recbpr	equ	$FFFFAC4E	;94 $FFFFB036. Replay record pointer
vbint	equ	$FFFFAC52	;94 $FFFFB03A. Vertical blank handler address (VBjsr jumps through it)
vcount	equ	$FFFFAC56	;94 $FFFFB03E. Vertical blank counter
oldvcount	equ	$FFFFAC58	;94 $FFFFB040
repeatdelayframes	equ	$FFFFAC5A	;94 $FFFFB042. Key repeat count down (ProcessInputWithRepeat)
asv	equ	$FFFFAC5C	;94 $FFFFB044. Crowd noise volume (updatesound)
lldisp	equ	$FFFFAC5E	;94 $FFFFB046. Count down to the once a second updates
periodendtime	equ	$FFFFAC60	;94 $FFFFB048. 3rd-period song trigger time (CheckPeriodEnd)
SortCords	equ	$FFFFAC62	;94 $FFFFB04A. 16 sort objects of SCstruct bytes
puckx	equ	$FFFFB362	;94 $FFFFB74A. SortCords+(puckscnum*SCstruct)
pucky	equ	$FFFFB376	;94 $FFFFB75E
puckz	equ	$FFFFB37A	;94 $FFFFB762
puckvx	equ	$FFFFB38A	;94 $FFFFB772
puckvy	equ	$FFFFB38C	;94 $FFFFB774
puckvz	equ	$FFFFB38E	;94 $FFFFB776
puckc	equ	$FFFFB3C2	;94 $FFFFB7AA. Puck carrier SCnum, -1 = none
puck_pflags2	equ	$FFFFB3C5	;94 $FFFFB7AD. puckx+pflags2 (the puck struct)
Ylist	equ	$FFFFB462	;94 $FFFFB84A
OOlistpos	equ	$FFFFB482	;94 $FFFFB86A
OOlist	equ	$FFFFB4A2	;94 $FFFFB88A. Sort objects in draw order (SprSort)
crowdframe	equ	$FFFFB4B2	;94 $FFFFB89A
crowdlevel	equ	$FFFFB4B4	;94 $FFFFB89C
crowdcnt	equ	$FFFFB4B8	;94 $FFFFB8A0. updatecrowdf: frames to the next crowd frame
CwdExciteLvl	equ	$FFFFB4BA	;94 $FFFFB8A2
MaxCwdExciteLvl	equ	$FFFFB4BC	;94 $FFFFB8A4
NumCwdExciteLvl	equ	$FFFFB4BE	;94 $FFFFB8A6
SumCwdExciteLvl	equ	$FFFFB4C0	;94 $FFFFB8A8
crowdtblidx	equ	$FFFFB4C4	;95 only. updatecrowdf: the CrowdFrameTbl index
zamx	equ	$FFFFB4C6	;94 $FFFFB8AC
playoffspritex	equ	$FFFFB4C8	;94 $FFFFB8AE. Playoff sprite x offset while the tree is scrolled (UpdatePlayoffScroll)
playoffspritey	equ	$FFFFB4CA	;94 $FFFFB8B0
clampcounter	equ	$FFFFB4CC	;94 $FFFFB8B2
DMAList	equ	$FFFFB4CE	;94 $FFFFB8B4. Dma transfer list
DMAlistend	equ	$FFFFB92E	;94 $FFFFBD14
Vpos	equ	$FFFFB932	;94 $FFFFBD18
Oldrow	equ	$FFFFB934	;94 $FFFFBD1A. Rink map row of the last updatescroll
Hpos	equ	$FFFFB936	;94 $FFFFBD1C
Hscroll	equ	$FFFFB938	;94 $FFFFBD1E
Vscroll	equ	$FFFFB93A	;94 $FFFFBD20
wcradiusx	equ	$FFFFB93C	;94 $FFFFBD22. Wall collision radius x (checkwallcoll)
wcradiusy	equ	$FFFFB93E	;94 $FFFFBD24
palcount	equ	$FFFFB940	;94 $FFFFBD26
palfadenew	equ	$FFFFB942	;94 $FFFFBD28
fofdata2	equ	$FFFFB9C2	;94 $FFFFBDA8. Faceoff sprite entries: word frame, word flags (checkfo)
fofdata	equ	$FFFFB9CA	;94 $FFFFBDB0
pads	equ	$FFFFB9CE	;94 $FFFFBDB4. 6 pad objects of $1C bytes (95 has no glove object; 94: 7 with glovestruct)
Joy1Struct	equ	$FFFFB9EA	;94 $FFFFBDD0. pads+$1C
Joy3Struct	equ	$FFFFBA22	;94 $FFFFBE24. pads+$54 (94: pads+$70)
Joy4Struct	equ	$FFFFBA3E	;94 $FFFFBE40. pads+$70 (94: pads+$8C)
ReplayStarStruct	equ	$FFFFBA5A	;94 $FFFFBE08
replayactive	equ	$FFFFBA70	;94 $FFFFBE1E
PadControlBits	equ	$FFFFBA76	;94 $FFFFBE78 (a word; PadControlBits34 $FFFFBE86). 95 keeps the 4 pads' nibbles in one long
padcont	equ	$FFFFBA7A	;94 $FFFFBE7A. Label code of each pad object
sso	equ	$FFFFBA86	;94 $FFFFBE88. Off screen arrow objects, $14 bytes each
shotplayer	equ	$FFFFBAD6	;94 $FFFFBED8. The last shooter (SCnum)
lastplayer	equ	$FFFFBAD8	;94 $FFFFBEDA
passdir	equ	$FFFFBADA	;94 $FFFFBEDC. Direction of the pass (chk4pass)
awardpicchars	equ	$FFFFBADC	;95 only. SeasonAwards: first vram char of the award pictures. Shares passspeed
passspeed	equ	$FFFFBADC	;94 $FFFFBEDE
awardpanelchars	equ	$FFFFBADE	;95 only. SeasonAwards: first vram char of the finalists / winner panels. Shares passplayer
passplayer	equ	$FFFFBADE	;94 $FFFFBEE0
glovecords	equ	$FFFFBAE0	;94 $FFFFBEE2
threat	equ	$FFFFBAE2	;94 $FFFFBEE4. Direction of the threat on the puck handler (chk4pass)
puckcross	equ	$FFFFBAE4	;94 $FFFFBEE6. Puck crossing x and frames at each goal line, for the goalies
puckcross2	equ	$FFFFBAE6	;94 $FFFFBEE8
puckcross6	equ	$FFFFBAEA	;94 $FFFFBEEC
lj1	equ	$FFFFBAEC	;94 $FFFFBEEE. Last buttons read by ReadJoy1
lj2	equ	$FFFFBAEE	;94 $FFFFBEF0
lj3	equ	$FFFFBAF0	;94 $FFFFBEF2
lj4	equ	$FFFFBAF2	;94 $FFFFBEF4
pad4way1	equ	$FFFFBAF4	;94 $FFFFBEF6. Pad 1 byte read each vblank (ReadJoyData)
pad4way2	equ	$FFFFBAF5	;94 $FFFFBEF7
pad4way3	equ	$FFFFBAF6	;94 $FFFFBEF8
pad4way4	equ	$FFFFBAF7	;94 $FFFFBEF9
pad4wayword	equ	$FFFFBAF8	;94 $FFFFBEFA. The pad word the unused Read4WayPad1-4 swap a pad's saved word into (Read4WayPort1)
pad4wayword2	equ	$FFFFBAFA	;95 only. The same for Read4WayPort2
pad4waysave1	equ	$FFFFBAFC	;94 $FFFFBEFE. Read4WayPad1 saved pad word
pad4waysave2	equ	$FFFFBAFE	;94 $FFFFBF00
pad4waysave3	equ	$FFFFBB00	;94 $FFFFBF02
pad4waysave4	equ	$FFFFBB02	;94 $FFFFBF04
bholdtimer	equ	$FFFFBB04	;94 $FFFFBF06. B button hold timers of pads 1 / 2
bholdtimer34	equ	$FFFFBB06	;94 $FFFFBF08. Pads 3 / 4
TempWord1	equ	$FFFFBB10	;94 $FFFFBF12. A scratch word
TempWord2	equ	$FFFFBB12	;94 $FFFFBF14. A scratch word (setplayer: the attribute number for AttributeCalc)
TempRawSpd	equ	$FFFFBB14	;94 $FFFFBF16
TradeFromTeam	equ	$FFFFBB14	;95 only. Trade: the team giving the player (shares TempRawSpd)
TempMaxSpd	equ	$FFFFBB16	;94 $FFFFBF18
TradeToTeam	equ	$FFFFBB16	;95 only. Trade: the team getting the player (shares TempMaxSpd)
rosterscroll	equ	$FFFFBB1A	;95 only. First player row shown by DisplayPlayerList
TempLegSpd	equ	$FFFFBB1C	;94 $FFFFBF1E. A scratch word: leg speed (doplayeracc); assdefo keeps the furthest y of the other forwards here
linemarkbuf	equ	$FFFFBB1E	;95 only. PrintPlayerLines String: the lines a player is on
recuser1	equ	$FFFFBB1E	;95 only. UpdateRecords: a user (name log entry) word (GetTeamUser, GetPadUser). Shares linemarkbuf
SeasonGoalSum	equ	$FFFFBB1E	;95 only. Season goal total of the human games (a long; save RAM $1B44 with SeasonGameCount). Shares linemarkbuf
StatWork	equ	$FFFFBB1E	;95 only. Scratch of the season stat screens (League Leaders: +0 mode, +2 category, +4 top row, +6 bottom row, +8 rows, +$A last row, +$C count; SaveGameHighlights, PrintStatHighlight). Shares linemarkbuf
TempBuffer	equ	$FFFFBB1E	;94 $FFFFBF20. 40 byte scratch buffer (hot / cold sum byte pairs, Strings). Shares linemarkbuf
recuser2	equ	$FFFFBB20	;95 only. UpdatePlayerRecords: the other team's user word (GetPadUser)
SeasonGameCount	equ	$FFFFBB22	;95 only. Human season games counted in SeasonGoalSum
SRAMbyte	equ	$FFFFBB46	;95 only. Save RAM byte read by ReadAttributeNibbleD7 / ProcessNibbleSeason (ReadSRAM)
recwins	equ	$FFFFBB4C	;94 $FFFFBF4E. A scratch word (record page wins; assdefo clears it)
rosterteam	equ	$FFFFBB4E	;95 only. setplayer: the team number ($28 of the team struct) for GetRosterName / GetJerseyNumber
recties	equ	$FFFFBB50	;94 $FFFFBF4A. Record Holders: the row ties (PrintWinRecords)
reclosses	equ	$FFFFBB52	;94 $FFFFBF4C. Record Holders: the row losses (PrintWinRecords)
recwincount	equ	$FFFFBB54	;95 only. Record Holders: the row wins (PrintWinRecords; 94 recwins)
awayhotter	equ	$FFFFBB56	;94 $FFFFBF50. CompareHotColdTotals: the away team is hotter
awayhotidx	equ	$FFFFBB5A	;94 $FFFFBF54. Hot / cold list index, away (BuildHotColdLists)
homehotidx	equ	$FFFFBB5C	;94 $FFFFBF56. Hot / cold list index, home
awaycoldidx	equ	$FFFFBB5E	;94 $FFFFBF58. Hot / cold list index, away cold (NextAwayColdPlayer)
homecoldidx	equ	$FFFFBB60	;94 $FFFFBF5A. Hot / cold list index, home cold (NextHomeColdPlayer)
awayhotplayer	equ	$FFFFBB62	;94 $FFFFBF5C. The away team's hottest starter (BuildHotColdLists)
homehotplayer	equ	$FFFFBB64	;94 $FFFFBF5E. The home team's hottest starter
awaycoldplayer	equ	$FFFFBB66	;94 $FFFFBF60. The away team's coldest starter
homecoldplayer	equ	$FFFFBB68	;94 $FFFFBF62. The home team's coldest starter
ChkBodyG	equ	$FFFFBB6A	;94 $FFFFBF64. Goalie body reach (checkpuckcoll)
ChkBodySqG	equ	$FFFFBB6C	;94 $FFFFBF66. Long: reach squared
NegChkBodyG	equ	$FFFFBB70	;94 $FFFFBF6A
onetimerplayer	equ	$FFFFBB72	;94 $FFFFBF6C
onetimerclock	equ	$FFFFBB74	;94 $FFFFBF6E
onetimerflags	equ	$FFFFBB7C	;94 $FFFFBF76
disflags	equ	$FFFFBB7E	;94 $FFFFBF78
ltplayer	equ	$FFFFBB80	;94 $FFFFBF7A
ltx	equ	$FFFFBB82	;94 $FFFFBF7C. Last touch x (a2touchpuck)
lty	equ	$FFFFBB84	;94 $FFFFBF7E. Last touch y
iflags	equ	$FFFFBB86	;94 $FFFFBF80
icingPlayer	equ	$FFFFBB87	;94 $FFFFBF81. The low byte of iflags: SCnum of the player who iced it
clockram	equ	$FFFFBB8C	;94 $FFFFBF86. The clock chars for the dma list (showclockdma)
xc1	equ	$FFFFBB94	;94 $FFFFBF8E. Scroll lock x (sfslock)
yc1	equ	$FFFFBB96	;94 $FFFFBF90. Scroll lock y
yleader	equ	$FFFFBB98	;94 $FFFFBF92
fox	equ	$FFFFBB9A	;94 $FFFFBF94. Face off x
foy	equ	$FFFFBB9C	;94 $FFFFBF96. Face off y
fodir1	equ	$FFFFBB9E	;94 $FFFFBF98. Faceoff pull direction (dpad) of the bottom goal team
fodir2	equ	$FFFFBBA0	;94 $FFFFBF9A. Of the top goal team
deltax	equ	$FFFFBBA2	;94 $FFFFBF9C. avdgoal x correction
deltay	equ	$FFFFBBA4	;94 $FFFFBF9E. avdgoal y correction
collflag	equ	$FFFFBBA6	;94 $FFFFBFA0. Set by a player collision (checkcx)
mesarea	equ	$FFFFBBAA	;94 $FFFFBFA4. Message String: length word, then TextBuffer
TextBuffer	equ	$FFFFBBAC	;94 $FFFFBFA6
PushWidthBuf	equ	$FFFFBC0E	;94 $FFFFC008. PushNumberWidth String
PushNumberBuf	equ	$FFFFBC16	;94 $FFFFC010. End of the PushNumber digits
redrawicons	equ	$FFFFBC18	;94 $FFFFC012. Line editor: the line drawn last (-1 = redraw)
ltack	equ	$FFFFBC1A	;94 $FFFFC014. Last tackle sound
lastsfx	equ	$FFFFBC1C	;94 $FFFFC016
Satt	equ	$FFFFBC1E	;94 $FFFFC018. Sprite attribute table
Sattsize	equ	$FFFFBEEE	;94 $FFFFC2E8
gmode	equ	$FFFFBEF0	;94 $FFFFC2EA
sflags	equ	$FFFFBEF2	;94 $FFFFC2EC
sflags2	equ	$FFFFBEF4	;94 $FFFFC2EE
sflags3	equ	$FFFFBEF6	;94 $FFFFC2F0
BA_PS_flags	equ	$FFFFBEF8	;94 $FFFFC2F2
sflags4	equ	$FFFFBEFA	;94 $FFFFC2F4. Bit 4: reverse angle replay
sflags5	equ	$FFFFBEFC	;94 $FFFFC2F6
sflags6	equ	$FFFFBEFE	;94 $FFFFC2F8
gmode2	equ	$FFFFBF00	;94 $FFFFC2FA. Bit 0 shootout (main menu Shootout)
sflags7	equ	$FFFFBF02	;94 $FFFFC2FC. Bit 1 overtime
sflags8	equ	$FFFFBF04	;94 $FFFFC2FE
sflags9	equ	$FFFFBF06	;95 only. Bit 7 Practice Mode (main menu item 2)
GameFlags	equ	$FFFFBF08	;95 only. Flag byte: bit 7 holds MakeSRAMChecksum during a batch of save RAM writes; bits 0, 1 pick the second shot / pass tables
sflags10	equ	$FFFFBF0A	;95 only. Main menu: bit 2 Trade Players, bit 4 Create Player, bit 5 Sign Free Agents, bit 6 Release Players
sflags11	equ	$FFFFBF0C	;95 only. Bit 7 user records count (UserNameEntry: at most one pad per team), bit 6 Regular Game (main menu item 1; kept over the Opening2 RAM clear), bit 5 set around IntermissionMenu, bit 4 a team award (SeasonAwards), bit 3 the playoff stats (GetAwardGoals), bit 2 set around PlayoffScreen (PlayoffTreeScreen)
sflags12	equ	$FFFFBF0E	;95 only. Bit 7 Opening2 skips the sound restart (set by Opening), bit 6 SortAwardScores lowest first, bit 0 set while IntermissionMenu runs Pausemode
sflags13	equ	$FFFFBF10	;95 only. Bit 2: the Stanley Cup was won (clockcont_0; GameOver shows StanleyCupScreen)
cupwinner	equ	$FFFFBF12	;95 only. Team number of the Stanley Cup winner
LineHoldFlag	equ	$FFFFBF14	;95 only. Per pad (a word each): set when LineHoldTimer runs out (SetLCmode); lineinput clears it
lastpuckc	equ	$FFFFBF1C	;95 only. The puck carrier CheckNewCarrier saw last
homegoaliectl	equ	$FFFFBF1E	;95 only. Home goalie control (AssignPads: nonzero = pad does not take the goalie)
awaygoaliectl	equ	$FFFFBF20	;95 only. Away goalie control
menupadnum	equ	$FFFFBF26	;95 only. Pad (0-3) ReadMenuJoy reads
crowdnoisedelay	equ	$FFFFBF2A	;94 $FFFFC304
CurCrowdMeter	equ	$FFFFBF34	;94 $FFFFC30E. StartPer clears it as 94 does
CrowdPeak	equ	$FFFFBF3A	;94 $FFFFC314. The crowd peak of the game (UpdateCrowdRecord)
joypuckcarrier	equ	$FFFFBF3C	;94 $FFFFC318
msgtimer	equ	$FFFFBF3E	;94 $FFFFC31A
passmodetimer	equ	$FFFFBF40	;94 $FFFFC31C
savednewpnum	equ	$FFFFBF42	;94 $FFFFC31E. Penalty shot: the shooter newpnum ($61) kept by SetupPenaltyShot
c1playernum	equ	$FFFFBF44	;94 $FFFFC320
c2playernum	equ	$FFFFBF46	;94 $FFFFC322
c3playernum	equ	$FFFFBF48	;94 $FFFFC324
c4playernum	equ	$FFFFBF4A	;94 $FFFFC326
cont1team	equ	$FFFFBF4C	;94 $FFFFC328
cont2team	equ	$FFFFBF4E	;94 $FFFFC32A
cont3team	equ	$FFFFBF50	;94 $FFFFC32C
cont4team	equ	$FFFFBF52	;94 $FFFFC32E
HomeTeam	equ	$FFFFBF54	;94 $FFFFC330
VisTeam	equ	$FFFFBF56	;94 $FFFFC332
TeamBlockMaps	equ	$FFFFBF58	;95 only. Map words of the home and visitor team blocks (setupTeamBlocksMap, PutTeamBlock)
teamblocksmapptr	equ	$FFFFBFC8	;95 only. Address of the team blocks map
teamblockwidth	equ	$FFFFBFCC	;95 only. Team block width in chars
PenBuf	equ	$FFFFBFCE	;94 $FFFFC3A4. New penalties: player byte pairs, 0 ends
Pencntdwn	equ	$FFFFC010	;94 $FFFFC3E6
Penaltytimer	equ	$FFFFC012	;94 $FFFFC3E8
PBnum	equ	$FFFFC014	;94 $FFFFC3EA. Players in the penalty boxes: home in the high nibble, away in the low
InjCntDown	equ	$FFFFC016	;94 $FFFFC3EC
penmsgtimer	equ	$FFFFC018	;94 $FFFFC3EE
RefCnt	equ	$FFFFC01A	;94 $FFFFC3F0
RefStep	equ	$FFFFC01C	;94 $FFFFC3F2
RefPen	equ	$FFFFC01E	;94 $FFFFC3F4
gsp	equ	$FFFFC020	;94 $FFFFC466. Period: 0-2, 3 overtime, 4 game over
gameclock	equ	$FFFFC022	;94 $FFFFC468
PerTimeTotal	equ	$FFFFC026	;94 $FFFFC46C. Period length in seconds (ResetClock)
ChkCnt	equ	$FFFFC028	;94 $FFFFC46E
TempPlOffset	equ	$FFFFC02A	;94 $FFFFC470. Player for GetTempPlayerName (bit 15: away team)
ScoreSumbytes	equ	$FFFFC02C	;94 $FFFFC472
ScoreSum	equ	$FFFFC02E	;94 $FFFFC474. Goal summary, 6 bytes per goal (ScoreSumbytes)
PenSumLength	equ	$FFFFC196	;94 $FFFFC5DC
PenSum	equ	$FFFFC198	;94 $FFFFC5DE. Penalty summary, 4 bytes per penalty (PenSumLength)
HmShots	equ	$FFFFC288	;94 $FFFFC6CE. Home team struct
HmGoals	equ	$FFFFC294	;94 $FFFFC6DA. Home team struct goals
HomeTeamRosterPtr	equ	$FFFFC2A6	;94 $FFFFC6EC. HmShots+$1E: the team data address (TeamList entry)
AttribDeltas	equ	$FFFFC42C	;95 only. Modify Ratings: the attribute changes (16 bytes)
FieldTextBuf	equ	$FFFFC43C	;95 only. Modify Ratings: field value text
AwShots	equ	$FFFFC5EE	;94 $FFFFCA32. Away team struct (tmsize $366, 94: $364)
AwGoals	equ	$FFFFC5FA	;94 $FFFFCA3E
AwayTeamRosterPtr	equ	$FFFFC60C	;94 $FFFFCA50. AwShots+$1E: the team data address
statsbuffer	equ	$FFFFC954	;94 $FFFFCD96. Unpacked playoff stat words (ReadTeamStats)
gsstruct	equ	$FFFFCA24	;94 $FFFFCE66. Game structs, 8 games of $10 bytes
gamenum	equ	$FFFFCAA4	;94 $FFFFCEE6. Index of the current game in gsstruct
postarts	equ	$FFFFCAA6	;94 $FFFFCEE8
bosgames	equ	$FFFFCAA8	;94 $FFFFCEEA
gamelevel	equ	$FFFFCAAA	;94 $FFFFCEEC
potreeteam	equ	$FFFFCAAC	;94 $FFFFCEEE
pojoy	equ	$FFFFCAAE	;94 $FFFFCEF0
WinBits	equ	$FFFFCAB0	;94 $FFFFCEF2
potree	equ	$FFFFCAB2	;94 $FFFFCEF4
PlList	equ	$FFFFCAD2	;94 $FFFFCF14. SetPlList: the players wanted on the ice (6 bytes), then their positions (6 bytes)
menuitem	equ	$FFFFCADE	;94 $FFFFCF20. Menu state: selected item, then (+2) first item shown
menulist	equ	$FFFFCAE2	;94 $FFFFCF24. Menu item list (InitMenuState)
menudraw	equ	$FFFFCAE6	;94 $FFFFCF28. Menu screen draw routine
menuitemoffset	equ	$FFFFCAEA	;95 only. Long: offset of the shown items in menulist (SetPauseMenuItems)
TickerNum	equ	$FFFFCAEE	;94 $FFFFCF2C
PPBonus	equ	$FFFFCAF0	;94 $FFFFCF2E. setplayer attribute bonuses: power play
PKBonus	equ	$FFFFCAF1	;94 $FFFFCF2F. Penalty kill
ThirdPBonus	equ	$FFFFCAF2	;94 $FFFFCF30. Third period, behind or tied
HmAwBonus	equ	$FFFFCAF3	;94 $FFFFCF31. Home / away
callbackPtr	equ	$FFFFCAF4	;94 $FFFFCF32. DecompressGraphics: remap table, or 0 to dma the chars
CalTeam	equ	$FFFFCAF8	;95 only. CalendarScreen team (StandingsScreen: the group size). Shares ThreeStars
homeusers	equ	$FFFFCAF8	;95 only. ScoutingReport: the count of the home users, then their name log entries (GetHomeUsers). Shares ThreeStars
SeedCount	equ	$FFFFCAF8	;95 only. SortSeeds: the teams in the list. Shares ThreeStars
StatBuf	equ	$FFFFCAF8	;95 only. Season stat buffer read from / written to save RAM (team records, player stat blocks, highlights). Shares ThreeStars
ThreeStars	equ	$FFFFCAF8	;94 $FFFFCF36. 256 byte ring buffer of DecompressBytecode
CalMonth	equ	$FFFFCAFA	;95 only. CalendarScreen month (StandingsScreen: the 26 team points table)
SeedPoints	equ	$FFFFCAFA	;95 only. InitPlayoffs: 2 * wins + ties of each team (CalcSeedPoints)
CalDay	equ	$FFFFCAFC	;95 only. CalendarScreen schedule day
CalX	equ	$FFFFCAFE	;95 only. CalendarScreen day column
CalY	equ	$FFFFCB00	;95 only. CalendarScreen day row
awayusers	equ	$FFFFCB02	;95 only. ScoutingReport: the count of the away users, then their name log entries (GetAwayUsers)
CalMonths	equ	$FFFFCB02	;95 only. CalendarScreen last month of the season
CalFirst	equ	$FFFFCB06	;95 only. CalendarScreen first day shown
CalLast	equ	$FFFFCB08	;95 only. CalendarScreen last day shown
CalGamePtr	equ	$FFFFCB0A	;95 only. CalendarScreen game entry of the day
CalGames	equ	$FFFFCB0E	;95 only. CalendarScreen day game list (ReadDayGames)
StandingsMode	equ	$FFFFCB14	;95 only. StandingsScreen group: bit 0 conference, bit 1 division
SeedGames	equ	$FFFFCB16	;95 only. InitPlayoffs: the games of each team (CalcSeedPoints)
StandingsOrder	equ	$FFFFCB16	;95 only. StandingsScreen games of the 26 teams
StandingsBuf	equ	$FFFFCB30	;95 only. StandingsScreen records (ReadStandings, 3 bytes a team)
StandingsList	equ	$FFFFCB7E	;95 only. StandingsScreen teams of the group, sorted
nibblebuffer	equ	$FFFFCC24	;94 $FFFFD036. Word weights for WeightedRandomSelect
gamevarend	equ	$FFFFCC2C	;95 only. End of the RAM StartGame clears from VSCRLPM (94 $FFFFD03E)
SimFlags	equ	$FFFFCC30	;95 only. Bit 0 save the cup winner, bit 1 a game was simulated (SaveSimGame)
tradeteam1	equ	$FFFFCC32	;95 only. Trade Players: the first team (word), its 8 byte block
tradeteam2	equ	$FFFFCC3A	;95 only. Trade Players: the second team
pad1user	equ	$FFFFCC42	;94 homeuser $FFFFD042. Name log entry picked by pad 1 (UserNameEntry, NameEntryScreen a5)
pad2user	equ	$FFFFCC44	;94 awayuser $FFFFD044. Name log entry picked by pad 2
pad3user	equ	$FFFFCC46	;95 only. Name log entry picked by pad 3
pad4user	equ	$FFFFCC48	;95 only. Name log entry picked by pad 4
FourWayPlay	equ	$FFFFCC4A	;94 $FFFFD046. Four way adaptor in use
OptPlayMode	equ	$FFFFCC4C	;94 $FFFFD048. Start of the menu options
OptNOP	equ	$FFFFCC4E	;94 $FFFFD04A. Options menu: number of players
Opt1Team	equ	$FFFFCC50	;94 $FFFFD04C
Opt2Team	equ	$FFFFCC52	;94 $FFFFD04E
OptPerlen	equ	$FFFFCC54	;94 $FFFFD050
OptGoalie	equ	$FFFFCC56	;94 $FFFFD052
OptUserRec	equ	$FFFFCC58	;94 $FFFFD054. 0 = On
OptPen	equ	$FFFFCC5A	;94 $FFFFD056
OptLine	equ	$FFFFCC5C	;94 $FFFFD058
goaliemode1	equ	$FFFFCC5E	;94 $FFFFD05A
goaliemode2	equ	$FFFFCC60	;94 $FFFFD05C
demoflag	equ	$FFFFCC68	;94 $FFFFD064
RNGseed	equ	$FFFFCC6A	;94 $FFFFD066
dmaram	equ	$FFFFCC6E	;94 $FFFFD06A. Dma command long, written to the vdp as two words
music_global_tick_counter	equ	$FFFFCC72	;94 $FFFFD06E. Begin stores the VDP PAL bit here
TmpOptLine2	equ	$FFFFCC76	;94 $FFFFD072
TempOptPlayMode	equ	$FFFFCC78	;94 $FFFFD074
databuffer	equ	$FFFFCC7A	;94 $FFFFD076. Line data buffer (ReadLineData / WriteLineData)
pwddatabuffer	equ	$FFFFCC8C	;94 $FFFFD088
outputbuffer	equ	$FFFFCC96	;94 $FFFFD092
tpassbits	equ	$FFFFCD7A	;94 $FFFFD176
music_needs_z80_update	equ	$FFFFCD84	;94 $FFFFD180. The 94 sound driver RAM below (sound95_01), unused by 95
Z80_command_buffer	equ	$FFFFCD86	;94 $FFFFD182
per_channel_attenuation_table	equ	$FFFFCD8B	;94 $FFFFD187
per_channel_frequency_table	equ	$FFFFCD92	;94 $FFFFD18E
per_channel_patch_table	equ	$FFFFCDA0	;94 $FFFFD19C
fm_voice_usage_table	equ	$FFFFCDA8	;94 $FFFFD1A4
fm_channel_structs	equ	$FFFFCFA8	;94 $FFFFD3A4
fm_channel_struct6	equ	$FFFFCFD0	;94 $FFFFD3CC
fm_track_slots	equ	$FFFFCFD8	;94 $FFFFD3D4. 95 uses the first word as PlayingSong
PlayingSong	equ	$FFFFCFD8	;95 only. Song the sound driver is playing ($32-$55), -1 = none
BA_Team	equ	$FFFFD008	;94 $FFFFD404. Penalty shot / shootout: the shooting team (0 home, 1 away)
BA_Sktr_SCnum	equ	$FFFFD00A	;94 $FFFFD406
BA_Goalie_SCnum	equ	$FFFFD00C	;94 $FFFFD408
BA_Skater_Offset	equ	$FFFFD00E	;94 $FFFFD40A
BA_Goalie_Offset	equ	$FFFFD010	;94 $FFFFD40C. Penalty shot: the goalie (getBAplayerInfo)
BA_Checker_Offset	equ	$FFFFD012	;94 $FFFFD40E. Penalty shot: the checker (PenaltyShotBox " by")
pspenalty	equ	$FFFFD014	;94 $FFFFD410. Penalty shot: the penalty (PenShotChk)
holdreset	equ	$FFFFD016	;94 $FFFFD412
onetimertargetx	equ	$FFFFD018	;94 $FFFFD414
onetimertargety	equ	$FFFFD01A	;94 $FFFFD416
onetimerheight	equ	$FFFFD01C	;94 $FFFFD418
FallYPos	equ	$FFFFD01E	;94 $FFFFD41A. Ypos of the player falling into the boards
FallXPos	equ	$FFFFD020	;94 $FFFFD41C. Xpos of the player falling into the boards (FallDown)
LineHoldTimer	equ	$FFFFD022	;95 only. Per pad (a word each): frames A must stay held before doinput starts a line change
screen6chars1	equ	$FFFFD02A	;95 only. DrawTeamScreen6: the team block chars
screen6chars2	equ	$FFFFD02C	;95 only. DrawTeamScreen6: the Screen6Tiles1 chars
screen6chars3	equ	$FFFFD02E	;95 only. DrawTeamScreen6: the Screen6Tiles2 chars
logoteam	equ	$FFFFD030	;94 $FFFFD428
setuphome	equ	$FFFFD032	;94 $FFFFD42A
setupvis	equ	$FFFFD034	;94 $FFFFD42C
setupcardflags	equ	$FFFFD036	;94 $FFFFD42E
homepicchars	equ	$FFFFD038	;94 $FFFFD430
vispicchars	equ	$FFFFD03A	;94 $FFFFD432
cardroster	equ	$FFFFD03C	;94 $FFFFD434
cardtimer	equ	$FFFFD044	;94 $FFFFD43C
featuredplayer	equ	$FFFFD046	;94 $FFFFD43E
carddelay	equ	$FFFFD048	;94 $FFFFD440
cardprintx	equ	$FFFFD04A	;94 $FFFFD442
cardprinty	equ	$FFFFD04C	;94 $FFFFD444
cardteamnum	equ	$FFFFD04E	;94 $FFFFD446
homegoalies	equ	$FFFFD050	;94 $FFFFD448
awaygoalies	equ	$FFFFD052	;94 $FFFFD44A
homeplayers	equ	$FFFFD054	;94 $FFFFD44C. Players of the home team (CountPlayers)
awayplayers	equ	$FFFFD056	;94 $FFFFD44E. Players of the away team (CountPlayers)
shootoutclock	equ	$FFFFD05C	;94 $FFFFD454
shootoutjiffy	equ	$FFFFD05E	;94 $FFFFD456
namelog	equ	$FFFFD060	;94 $FFFFD45A. The user name log, 12 bytes per name
NameEntryBuf	equ	$FFFFD0E0	;95 only. Name entry: the name (18 characters)
NameEntryLen	equ	$FFFFD0F4	;95 only. Name entry: name length
CreateListRow	equ	$FFFFD0F6	;95 only. Create player list: the current row
CreateListOldRow	equ	$FFFFD0F8	;95 only. Create player list: the row with the markers
nameentryvis	equ	$FFFFD0FA	;94 $FFFFD4EE. Name entry: the team (pad) entering a name (UserNameEntry)
nameframechars	equ	$FFFFD13C	;95 only. Name entry frame chars (NameEntryFramer)
recsort1	equ	$FFFFD13E	;94 $FFFFD532. Record Holders row order sorted on record byte 0 (ReadTeamRecords), read by PrintPlayerRecords
recsort2	equ	$FFFFD146	;94 $FFFFD53A. Record Holders row order sorted on record byte 4 (ReadTeamRecords, sflags6 bit 6)
winsort	equ	$FFFFD14E	;94 $FFFFD542. Record Holders win row order (CalcWinPercents), read by PrintWinRecords
winpcts	equ	$FFFFD156	;94 $FFFFD54A. The win % byte of each of the 8 records (CalcWinPercents)
winties	equ	$FFFFD15E	;94 $FFFFD552. The ties word of each record (record bytes $C-$D)
wingames	equ	$FFFFD16E	;94 $FFFFD562. The games word of each record (record bytes $A-$B)
sohomegoals	equ	$FFFFD180	;95 only. Shootout goals, home
soawaygoals	equ	$FFFFD182	;95 only. Shootout goals, away
playoffround	equ	$FFFFD184	;94 $FFFFD578. Shootout round (ShootoutInit sets 1)
homeshooters	equ	$FFFFD186	;94 $FFFFD57A. The home shootout shooter list (6 words below homeshootnum, InitShooters)
homeshootnum	equ	$FFFFD192	;94 $FFFFD586. The shooter index of the shootout
awayshooters	equ	$FFFFD194	;94 $FFFFD588. The away shootout shooter list (6 words below shootoutteam)
shootoutteam	equ	$FFFFD1A0	;95 only. Shootout: 0 home shoots, 1 away
SeasonStartDay	equ	$FFFFD1A4	;95 only. Schedule day the season starts on (sub_8E26A picks it at random)
SeasonLength	equ	$FFFFD1A5	;95 only. Days in the season ($C0 = the whole schedule)
SeasonDay	equ	$FFFFD1A6	;95 only. Days played; the byte after it is the season flags
SeasonFlags	equ	$FFFFD1A7	;95 only. The byte after SeasonDay: bit 1 best of seven, bit 2 multi-game injuries, bit 3 regular season over, bit 4 playoffs over, bit 5 playoffs
SeasonPerlen	equ	$FFFFD1A8	;95 only. Season period length (ReadSeasonHeader)
SeasonPen	equ	$FFFFD1A9	;95 only. Season penalties
SeasonLine	equ	$FFFFD1AA	;95 only. Season line changes
seasonteamsel	equ	$FFFFD1AC	;95 only. Offset of the season matchup in SeasonTeams, -1 none
seasonchars1	equ	$FFFFD1AE	;95 only. Games today screen chars (GamesTodayMap3)
padcursorchars	equ	$FFFFD1B0	;95 only. ControllerSetupScreen: PadCursorMap chars
seasonchars2	equ	$FFFFD1B2	;95 only. Games today screen chars (GamesTodayMap1)
GamesTodayDay	equ	$FFFFD1B4	;95 only. GamesToday: SeasonDay on entry
padiconchars1	equ	$FFFFD1B6	;95 only. ControllerSetupScreen: PadIconMap1 ... 4 chars (PadIconChars)
padiconchars2	equ	$FFFFD1B8
padiconchars3	equ	$FFFFD1BA
padiconchars4	equ	$FFFFD1BC
calresultchars	equ	$FFFFD1BE	;95 only. CalendarScreen CalResultMap chars
calbgchars	equ	$FFFFD1C0	;95 only. CalendarScreen CalendarBgMap chars
AwardIndex	equ	$FFFFD1C2	;95 only. SeasonAwards: the award shown (0 Hart ... 8 Conn Smythe). Shares SimWeights
SimWeights	equ	$FFFFD1C2	;95 only. SimTeamGoals: the 10 goal weights
AwardTimer	equ	$FFFFD1C4	;95 only. SeasonAwards: frames of the award shown (a long)
AwardFlashTimer	equ	$FFFFD1C8	;95 only. SeasonAwards: frame count of the highlight and the winner flash
AwardCount	equ	$FFFFD1CA	;95 only. SeasonAwards: the candidates in AwardIds
AwardWinner	equ	$FFFFD1CC	;95 only. SeasonAwards: the winner id (the best score)
AwardHilite	equ	$FFFFD1CE	;95 only. SeasonAwards: the highlighted finalist * 2
AwardCycle	equ	$FFFFD1D0	;95 only. SeasonAwards: frames between highlight moves
AwardWait	equ	$FFFFD1D2	;95 only. AwardsLoop: frames left before it returns
SeasonTeams	equ	$FFFFD1DC	;95 only. Season team list (BuildSeasonTeamList)
matchup	equ	$FFFFD262	;94 $FFFFD598. PeriodStatsScreen: 0 goals, else shots
scoutunused	equ	$FFFFD264	;94 $FFFFD59A. Cleared by ScoutingReport, never read
matchuphome	equ	$FFFFD266	;94 $FFFFD59C. The home player of the matchup (GetMatchupPlayers)
matchupvis	equ	$FFFFD268	;94 $FFFFD59E. The visitors player of the matchup; also the scroll limit of GameStatisticsScreen
homerating	equ	$FFFFD26A	;94 $FFFFD5A0. The home rating of the matchup (PrintMatchupRatings)
visrating	equ	$FFFFD26C	;94 $FFFFD5A2. The visitors rating of the matchup
advframe	equ	$FFFFD26E	;94 $FFFFD5A4. Advantage marks step (PrintAdvantageMarks)
advcount	equ	$FFFFD270	;94 $FFFFD5A6. Advantage marks frame count
matchuptimer	equ	$FFFFD272	;94 $FFFFD5A8. PeriodStatsScreen: the running total
matchupslot	equ	$FFFFD274	;94 $FFFFD5AA. The line slot of the matchup (GetMatchupPlayer)
DispAttribCtr	equ	$FFFFD276	;94 $FFFFD5AC. Roster attribute page; game setup: first line shown (94 setupfirstline)
VertLineScrolling	equ	$FFFFD278	;94 $FFFFD5AE. Game setup: last line shown
PlayerScrollCtr	equ	$FFFFD27A	;94 $FFFFD5B0. Scroll step (playoff screen); TeamRosterScreen: nonzero stops the page keys
SelectedPlayerIdx	equ	$FFFFD27C	;94 $FFFFD5B2. Roster page 0-2; game setup: cursor line
typedelay	equ	$FFFFD27E	;94 $FFFFD5B4. ScoutTextPlayer: frames to the next word
screentimer	equ	$FFFFD280	;94 $FFFFD5B6. Line editor: the selected list row
setupvalues	equ	$FFFFD282	;95 only. 8 setup line values (mode, teams, ...)
TestList	equ	$FFFFD282	;94 $FFFFD5B8. Shootout shooters: the selected slot (0-4 shooters, 5 goalie). Shares setupvalues
setupprevline	equ	$FFFFD2E8	;94 $FFFFD424
setupdir	equ	$FFFFD2EA	;95 only. Last setup key: 0 up, 1 down, 2 left, 3 right, -1 none
setuplines	equ	$FFFFD2EC	;95 only. Number of setup lines for the mode
setupshown	equ	$FFFFD2EE	;95 only. Setup lines shown
arenaanim	equ	$FFFFD37E	;94 $FFFFD6B4
faceoffanim	equ	$FFFFD388	;94 $FFFFD6BE
NameEntryMode	equ	$FFFFD38E	;95 only. Create player: 0 list mode, else name edit mode
SongNum	equ	$FFFFD392	;94 $FFFFD6C8
HmTeam	equ	$FFFFD394	;94 $FFFFD6CA
SongIndex	equ	$FFFFD396	;94 $FFFFD6CC
attribsum	equ	$FFFFD398	;95 only. CalcAttribRating: sum of the attribute bytes
attribcount	equ	$FFFFD39A	;95 only. CalcAttribRating: count of them
homehotcoldsave	equ	$FFFFD39C	;94 $FFFFD6D2. clearTeamStats keeps the first $1A0 bytes of the home hot / cold table (HmShots+$1A4) here
awayhotcoldsave	equ	$FFFFD53C	;94 $FFFFD872. The same for AwShots+$1A4
sopath	equ	$FFFFD6DC	;94 $FFFFDA12. Shootout skate path (StartShootoutPath)
sopathpoint	equ	$FFFFD6DE	;94 $FFFFDA14. Point of the skate path (NextPathPoint)
sopathx	equ	$FFFFD6E0	;94 $FFFFDA16
sopathy	equ	$FFFFD6E2	;94 $FFFFDA18
sopathdir	equ	$FFFFD6E4	;94 $FFFFDA1A. passdir at the end of the path (PSandSOpassdir)
sopathend	equ	$FFFFD6E6	;94 $FFFFDA1C. Shoot distance at the end of the path (ShootoutShootCheck)
LeaderTeamTbls	equ	$FFFFD6E8	;95 only. League Leaders: 7 team value tables of $1A bytes (shares PlayoffSchedule)
picturebuf	equ	$FFFFD6E8	;94 $FFFFDA1E. UnpackPicture output
PlayoffSchedule	equ	$FFFFD6E8	;95 only. Playoff schedule (ReadPlayoffSchedule); a day list starts at +1
StandingsRecs	equ	$FFFFDAA0	;95 only. ReadStandings buffer (3 bytes a team) used by League Leaders
TeamLeaderValues	equ	$FFFFDB04	;95 only. League Leaders: team values (word a team), sorted
cupframe	equ	$FFFFDB6A	;95 only. StanleyCupScreen: the CupSprites animation frame. Shares picturebits
picturebits	equ	$FFFFDB6A	;94 $FFFFDEA0. UnpackPicture: the 3 packed bytes of the row
replayicontimer	equ	$FFFFDB7E	;94 $FFFFDEB4
TmpPuckX	equ	$FFFFDB80	;94 $FFFFDEB6. Goalie AI: the puck x it plays (assgoaliecpu)
songdelay	equ	$FFFFDB96	;94 $FFFFDECC
delayedsong	equ	$FFFFDB98	;94 $FFFFDECE
shootoutdelay	equ	$FFFFDB9A	;94 $FFFFDED0
waitxpad	equ	$FFFFDB9E	;94 $FFFFDED4. waitx: buttons held
inputjoy	equ	$FFFFDBA2	;94 $FFFFDED8
PlayerChked	equ	$FFFFDBA4	;94 $FFFFDEDC. Last player FallDown made fall
TmpJoyPuckCarrier	equ	$FFFFDBA4	;94 $FFFFDEDA
PlayerChking	equ	$FFFFDBA8	;94 $FFFFDEE0. The player who hit him
hoticonchars	equ	$FFFFDBAC	;95 only. First vram char of the hot icon (ScoutingReport, HotIconMap)
coldiconchars	equ	$FFFFDBAE	;95 only. First vram char of the cold icon (ColdIconMap)
iconplayer	equ	$FFFFDBB0	;94 $FFFFDEE8. HotColdIcon: the player
cupticks	equ	$FFFFDBB4	;95 only. StanleyCupScreen: frame count of the animation step. Shares pausetimeout
pausetimeout	equ	$FFFFDBB4	;95 only. Long: Pausemode frames left without a button while no pad is on a team
scoutwait	equ	$FFFFDBB4	;94 $FFFFDEEC. ScoutingReport: frames to wait for start after the text (a long). Shares pausetimeout
replaydelay	equ	$FFFFDBB8	;94 $FFFFDEF0
penboxattr	equ	$FFFFDBBA	;95 only. Attribute byte (4(a3)) of the player going into the penalty box: asspenalty saves it, assdopen puts it back
PALflag	equ	$FFFFDBBC	;94 $FFFFDEF2. Bit 0 set on a PAL (50 Hz) machine
RefRamMap	equ	$FFFFDBBE	;94 $FFFFC3F6. The ref window map in RAM ($38 words, PushRef)
menutimer	equ	$FFFFDC2E	;95 only. Set to $3C by Pausemode
framerchars	equ	$FFFFDC30	;95 only. Char start of the framer tiles (setupice, before AddFramer2)
seasonsetupreq	equ	$FFFFDC32	;95 only. Nonzero: GameSetUp opens on Continue Season
screenarg	equ	$FFFFDC34	;95 only. getNameandAttrib: the team number; DrawTeamScreen2 ... 6: the background bitmap address (long)
attribplayer	equ	$FFFFDC36	;95 only. getNameandAttrib player
optbgchars	equ	$FFFFDC38	;95 only. SeasonOptionsGfx: the wait box chars
ValidSRAM	equ	$FFFFDC3A	;94 $FFFFD458. 0 = save RAM checksum good, -1 = bad
CreatedPlayerBuf	equ	$FFFFDC3C	;95 only. Created player record read from save RAM (GetCreatedName reads it at +2)
jerseynum	equ	$FFFFDC3D	;95 only. Jersey number byte from GetJerseyNumber
SRAMChecksum	equ	$FFFFDC5E	;95 only. The complement and sum bytes MakeSRAMChecksum writes to save RAM bytes $7FFE-$7FFF
HmDefMode	equ	$FFFFDC62	;95 only. Home team defense mode: at 1 (Opening2 sets it) assdefd chases the carrier (assdefdchase) and asswingd covers (assign95_01)
AwDefMode	equ	$FFFFDC64	;95 only. Away team defense mode, as HmDefMode
turnstep	equ	$FFFFDC66	;95 only. doplayeracc: the turn step for the facing change
menucursor	equ	$FFFFDC68	;95 only. Pause menu column (Pausemode sets 2)
injurygames	equ	$FFFFDC6A	;95 only. Season: the games of the last injury (SetInjuryGames, CheckInjury)
ChkBodyP	equ	$FFFFDC6C	;95 only. Skater body reach for the puck (checkpuckcoll)
ChkStickP	equ	$FFFFDC6E	;95 only. Skater stick reach
NegChkBodyP	equ	$FFFFDC70	;95 only
NegChkStickP	equ	$FFFFDC72	;95 only
ChkBodySqP	equ	$FFFFDC74	;95 only. Body reach squared
ChkStickSqP	equ	$FFFFDC76	;95 only. Stick reach squared
AutoplayDay	equ	$FFFFDC79	;95 only. Play Until A Day: the last day to autoplay, 0 none
ShotTimer	equ	$FFFFDC7A	;95 only. Set to $1E by doshot, counted down by DoGameFrame
shotpflags	equ	$FFFFDC7C	;95 only. pflags of the last shooter (doshot)
varend	equ	$FFFFDC80	;93 name: end of variables, for clearing purposes only. Begin clears from VSCRLPM to here (94 $FFFFDEF4)
penaltymsgs	equ	$FFFFDC82	;95 only. Queue of penalty messages, a word each (penalty, player), 0 ends (ShowPenaltyMessages)
Stack	equ	$FFFFFDFA	;94 $FFFFFFFE. Begin's stack pointer; the sound driver RAM (SndDrvRAM) is above it
SndDrvRAM	equ	$FFFFFDFC	;95 only. Sound driver (sounddrv95) RAM base: word $1234 = driver ready, 0 = busy (SndUpdate does nothing)
SndSeqPtr	equ	$FFFFFDFE	;95 only. 8 song slots: song data (-1 = free)
SndSeqPos	equ	$FFFFFE1E	;95 only. 8 longs: offset of the next event in the song
SndSeqId	equ	$FFFFFE3E	;95 only. 8 words: the id SndStartSeq gave the slot (SndStopSeq finds it)
SndSeqWait	equ	$FFFFFE4E	;95 only. 8 words: ticks to the next event
SndSeqTempo	equ	$FFFFFE5E	;95 only. 8 words: tempo
SndSeqFrac	equ	$FFFFFE6E	;95 only. 8 words: tick fraction
SndSeqState	equ	$FFFFFE7E	;95 only. 8 longs: tick carry (word), running status (byte 2)
SndNotes	equ	$FFFFFE9E	;95 only. 32 note timers (long: count word, then the note), -1 = free
SndNoteCount	equ	$FFFFFF1E	;95 only. Notes in SndNotes
SndSeqIndex	equ	$FFFFFF20	;95 only. Slot SndUpdate is working on
SndStreamBase	equ	$FFFFFF22	;95 only. Sample being streamed to the Z80 (SndStreamZ80)
SndStreamPtr	equ	$FFFFFF26	;95 only. Next 256 bytes to stream, 0 = done
SndStreamLoop	equ	$FFFFFF2A	;95 only. Loop offset of the sample, -1 = none
SndStopSlot	equ	$FFFFFF2C	;95 only. Slot SndStopSeq frees
SndSeqArg1	equ	$FFFFFF2E	;95 only. SndStartSeq d1 (d2-d4 follow at SndDrvRAM+$134-$138)
SndBanks	equ	$FFFFFF36	;95 only. 4 sound banks (SndSetBank), -1 = none
