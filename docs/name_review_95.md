# Name review: NHL95 (names not in 94G/93G/92G)

Verdicts from reading each routine body / usage. "ok" = name matches behavior.

## main95

| name | verdict |
|---|---|
| AdrErr | ok |
| AndTxt | ok |
| BusErr | ok |
| DevelopedTxt | ok |
| DivBy0 | ok |
| InvOpCode | ok |
| NtscGenesisTxt | ok |
| NtscMegaDriveTxt | ok |
| PalMegaDriveTxt | ok |
| RegionFont | ok |
| RegionLetters | ok |
| RegionOK | ok |
| RegionPrint | ok |
| RegionSystems | ok |
| SystemsTxt | ok |
| ZeroLong | ok |

## engine/lines95

| name | verdict |
|---|---|
| CheckSavedLines | ok |
| CheckTeamLines | ok |
| DefaultLineData | ok |
| DrawTeamScreen2 | ok |
| DrawTeamScreen3 | ok |
| DrawTeamScreen4 | ok |
| DrawTeamScreen4Body | ok |
| DrawTeamScreen4NoSetup | ok |
| DrawTeamScreen5 | ok |
| DrawTeamScreen6 | ok |
| FixSavedLines | ok |
| LineSlotFixTbl | ok |
| LoadTeamLines | ok |
| ReadTeamSRAM | ok |
| SetupTeamLine | ok |
| rtslc | ok |

## front/scout95

| name | verdict |
|---|---|
| GetAwayUsers | ok |
| GetHomeUsers | ok |
| GetMatchupLogo | ok |
| GetPlayerPicture | ok |
| NextAwayUser | ok |
| NextHomeUser | ok |
| NullSaveClear | ok |
| PopUserName | ok |
| TeamRatingsLine | ok |
| UserNameString | ok |
| rtsScoutText | ok |

## front/injury95

| name | verdict |
|---|---|
| ClearPowerPlay | ok |
| DeleteInjurySlot | ok |
| GetInjuryGames | ok |
| InsertInjurySlot | ok |
| SetInjuryGames | ok |
| SetSeasonInjuries | ok |
| TickInjuries | ok |
| TickTeamInjuries | ok |
| rtsPowerPlay | ok |

## front/title95

| name | verdict |
|---|---|
| AddSpriteFrame | ok |
| CupBuildSprites | ok |
| CupDrawTeam | ok |
| CupExit | ok |
| CupReadPads | ok |
| CupVBlank | ok |
| CupWaitFrame | ok |
| StanleyCupScreen | ok |

## front/records95

| name | verdict |
|---|---|
| ClearNameHelp | ok |
| CountTeamPads | ok |
| GetPadUser | ok |
| NameInUse | ok |
| SkipPadName | ok |
| UpdateUserRecord | ok |

## engine/logic95

| name | verdict |
|---|---|
| assdefdchase | ok |
| check4check2 | ok |
| doassignment | ok |
| rtsskate | ok |
| rtsskateto | ok |
| saveanim | ok |

## control95

| name | verdict |
|---|---|
| burstchk | ok |
| setc3player | ok |
| setc4player | ok |
| setcplayer | ok |
| updatepadinput | ok |

## front/crowd95

| name | verdict |
|---|---|
| CrowdFrameTbl | ok |
| ShowCrowdFrame | ok |
| ShowCrowdPb | ok |
| rtsShowCrowd | ok |

## engine/video95

| name | verdict |
|---|---|
| AddFramer2 | ok |
| NoJoy | ok |
| ReadMenuJoy | ok |
| orjoy4way | ok |

## engine/skate95

| name | verdict |
|---|---|
| GoalieReadySPA | ok |
| dirtab2 | ok |
| doinput_goaliedive | ok |
| updatevel | ok |

## engine/players95

| name | verdict |
|---|---|
| BoostAttribute | ok |
| GetPlayerCountD7 | ok |
| PuckcIsGoalie | ok |
| StickHandTable | ok |

## engine/fourway95

| name | verdict |
|---|---|
| AnyPadAssigned | ok |
| Read4WayPort1 | ok |
| Read4WayPort2 | ok |
| ReadJoyJmp | ok |

## schedule95

| name | verdict |
|---|---|
| Day | ok |
| SeasonSchedule | ok |
| SeasonScheduleEnd | ok |

## sram95

| name | verdict |
|---|---|
| BuildLeaderList | ok |
| BuildLeaderListPct | ok |
| BuildLeaderListSum | ok |

## engine/replay95

| name | verdict |
|---|---|
| CanBlock | ok |
| chkblock | ok |
| rtsAdda4 | ok |

## engine/collide95

| name | verdict |
|---|---|
| DropPuck | ok |
| checkinglist2 | ok |
| rtspuck | ok |

## front/summary95

| name | verdict |
|---|---|
| rtsPenaltyScroll | ok |
| rtsScoringScroll | ok |

## engine/faceoff95

| name | verdict |
|---|---|
| DrawFaceoffWindow | ok |
| rtsfaceoff | ok |

## hockey95

| name | verdict |
|---|---|
| IntermissionMenu | ok |

## front/shootout95

| name | verdict |
|---|---|
| PenShotTable | ok |

## engine/penalty95

| name | verdict |
|---|---|
| rtspen | ok |

## display95

| name | verdict |
|---|---|
| rtssdisp | ok |

## sega/SegaIDTable95

| name | verdict |
|---|---|
| CountryCode | ok |

## stubinc/equals.inc

| name | verdict |
|---|---|
| SB_LIST | ok |
| SB_PATCH | ok |
| SB_SAMPLE | ok |
| SB_SONG | ok |

## engine/setup95

| name | verdict |
|---|---|
| BlankNameTxt | ok |
| CheckPlayoffsStarted | ok |
| ClearLogoPalettes | ok |
| DrawSetupLogo | ok |
| EraseCardText | ok |
| FindPlayerLine | ok |
| GetBlankChar | ok |
| GetSetupValues | ok |
| InjuryGamesTbl | ok |
| LoadRosterFont | ok |
| ModeToSetupMode | ok |
| NOPJoyTbl | ok |
| PrintOptionName | ok |
| PrintPlayerLines | ok |
| PrintSetupText | ok |
| PrintSetupTextHi | ok |
| SetTreeGameTeams | ok |
| SetupModeToMode | ok |
| StepSeasonTeam | ok |
| UpdateSetupLogos | ok |
| WrapOptionDown | ok |
| WrapOptionUp | ok |
| rtsLineData | ok |

## engine/goal95

| name | verdict |
|---|---|
| AssignTeam | ok |
| BlankLineTxt | ok |
| ContTeamOrder1 | ok |
| ContTeamOrder2 | ok |
| ControllerSetupScreen | ok |
| DrawPadCursor | ok |
| DrawPadIcon | ok |
| DrawPadSetup | ok |
| DrawSetupTeamBlock | ok |
| GetPracticePlayers | renamed (was GetGoalieCtl; body checked) |
| PlayerCountTxt | renamed (was GoalieCountTxt; body checked) |
| PracticePlayerLimits | renamed (was GoalieCtlLimits; body checked) |
| LockScroll | ok |
| PadIconChars | ok |
| PadIconMaps | ok |
| PracticePlayersTbl | renamed (was PracticeGoalieTbl; body checked) |
| PracticeGoalies | ok |
| PracticePlayersTxt | ok |
| PrintPlayerCount | renamed (was PrintGoalieCount; body checked) |
| PrintPracticePlayers | renamed (was PrintPracticeGoalies; body checked) |
| PrintPracticeTitle | ok |
| PrintSetupStr | ok |
| PrintSetupStrHi | ok |
| ReadAllPads | ok |
| SetContTeams | ok |
| PullPracticePlayers | renamed (was SetGoaliesCtl; body checked) |
| rtsgoal | ok |

## engine/middle95

| name | verdict |
|---|---|
| AddFonts | ok |
| AssignPads | ok |
| CalcAttribRating | ok |
| CheckNewCarrier | ok |
| ClockDigitChar | ok |
| ControlCode_None | ok |
| FormatFirstNameD7 | ok |
| FormatLastNameAlt | ok |
| FormatLastNameD7 | ok |
| FormatPlayerInitialD7 | ok |
| FormatPlayerNameD7 | ok |
| FormatPlayerNumInitialD7 | ok |
| GetDefenseStartD7 | ok |
| GetForwardCountD7 | ok |
| GetForwardCountSeason | ok |
| GetForwards | ok |
| GetGoalieCountD7 | ok |
| NumInitialBody | ok |
| PrintListItem | ok |
| PrintSmallListItem | ok |
| PushNumberWidthZero | ok |
| PutClockDigit | ok |
| ReAddFramer | ok |
| ReAddSmallFont | ok |
| SeasonPlayerOut | ok |
| formatlastbody | ok |
| getnameD7 | ok |
| getnamea0 | ok |
| getnamebody | ok |
| getplayernameD7 | ok |
| printbig1 | ok |
| printbig2 | ok |
| printbigtext | ok |
| printbigz1 | ok |
| printbigz2 | ok |
| showclockdma | ok |

## engine/pause95

| name | verdict |
|---|---|
| AbortGame | ok |
| ClearInfoTab | ok |
| ClearMenuBox | ok |
| ClearOldFrames | ok |
| ClearPauseTab | ok |
| ClearStatsTab | ok |
| DrawMenuInfo | ok |
| DrawTab | ok |
| DrawTabSelected | ok |
| InfoMenus | ok |
| ListPenaltyBox | ok |
| MenuInfoList | ok |
| PauseInfo | ok |
| PauseInfoText | ok |
| PauseMenus | ok |
| PauseScores | ok |
| PauseScreenDraw | ok |
| PlayGame | ok |
| PrintLines | ok |
| PutScoreDigit | ok |
| RedrawMenu | ok |
| RestoreGameScreen | ok |
| SelectInfoTab | ok |
| SelectPauseTab | ok |
| SelectStatsTab | ok |
| SetInfoMenuItems | ok |
| SetMenuPadSide | ok |
| SetPauseMenuItems | ok |
| SetStatsMenuItems | ok |
| ShowPenaltyBox | ok |
| ShowPenaltyBoxPlayer | ok |
| ShowPenaltyBoxes | ok |
| ShowPenaltyMessages | ok |
| StatsMenus | ok |
| padteams | ok |
| rtsmenu | ok |

## front/trade95

| name | verdict |
|---|---|
| BuildTradeList | ok |
| CheckTrade | ok |
| CountChosen | ok |
| DefaultRosters | ok |
| DrawHomeTradeRoster | ok |
| DrawTradeLogo | ok |
| DrawTradeRosterRows | ok |
| BuildTradeRoster | renamed (was DrawTradeTeam; body checked) |
| DrawVisTradeRoster | ok |
| EvaluateTrade | ok |
| ExecuteTrade | ok |
| FixLinesRemoved | renamed (was FixSavedLine; body checked) |
| FixLinesInserted | renamed (was FixSavedLine2; body checked) |
| GMDecisionGfx | renamed (was GMDecision; body checked) |
| GMDecisionScreen | renamed (was GMDecisionRetry; body checked) |
| GetCreatedName | ok |
| GetHighlightSlot | ok |
| GetJerseyNumber | ok |
| GetRosterId | ok |
| GetRosterName | ok |
| GetRosterNameTail | ok |
| HighlightsHelp | ok |
| InvalidTradeText | ok |
| FixJerseyNumber | renamed (was MoveSavedLines; body checked) |
| ExtractTradedPlayer | renamed (was MoveTradedPlayer; body checked) |
| PositionLetters | ok |
| PositionLetters2 | ok |
| PrintTradeNames | ok |
| PrintTradedPlayers | ok |
| ReadEvalTradePads | ok |
| ReadGMDecisionPads | ok |
| ReadTeamRoster | ok |
| ReadTradePads | ok |
| InsertTradedPlayer | renamed (was RemoveTradedPlayer; body checked) |
| ShiftTradeDown | ok |
| ShiftTradeUp | ok |
| TagTradePositions | renamed (was SortTradePlayers; body checked) |
| TeamRecordSRAM | ok |
| TradeDone | ok |
| TradeExit | ok |
| TradeGfx | ok |
| TradePlayers | ok |
| TradeRatingSteps | ok |
| TradeRatingValues | ok |
| TradeRulesText | ok |
| TradeCountOffsets | renamed (was TradeStatOffsets; body checked) |
| TradeCountOffsets2 | renamed (was TradeStatOffsets2; body checked) |
| TradeValue | ok |
| WriteTeamRoster | ok |
| rtsTrade | ok |

## front/awards95

| name | verdict |
|---|---|
| ArtRossScore | ok |
| AwardDescs | ok |
| AwardDescs2 | ok |
| AwardNames | ok |
| AwardNotQualified | ok |
| AwardPictureX | ok |
| AwardPictureY | ok |
| AwardPictures | ok |
| AwardQualifies | ok |
| AwardScanTbl | ok |
| AwardWinnerNop | ok |
| AwardsLoop | ok |
| AwardsScreenSetup | ok |
| BuildPlayoffDayGames | renamed from PlayoffRoundDone |
| CalcSeedPoints | ok |
| CollectSeriesWinners | ok |
| ConferenceTeams1 | ok |
| ConferenceTeams2 | ok |
| ConnSmytheScore | ok |
| CopyBytes | ok |
| DrawAwardPanel | ok |
| DrawAwardPicture | ok |
| DrawFinalistsPanel | ok |
| DrawWinnerPanel | ok |
| FindAwardFinalists | ok |
| FlashWinnerCaption | ok |
| GetAwardAssists | ok |
| GetAwardGoals | ok |
| GetGoalieAwardStats | ok |
| GetRoundPairings | ok |
| GetTeamUser | ok |
| HartScore | ok |
| InitPlayoffSeries | ok |
| InitPlayoffs | ok |
| JenningsScore | ok |
| NextPlayoffRound | ok |
| NorrisScore | ok |
| PearsonScore | ok |
| PlayoffTreeScreen | ok |
| PresidentsScore | ok |
| PrintAwardTitle | ok |
| PrintFinalists | ok |
| ReadPlayoffSchedule | ok |
| RecordPlayoffGame | ok |
| RestoreSeasonHeader | ok |
| RoundPairOffsets | ok |
| RoundSeriesCounts | ok |
| RoundSeriesOffsets | ok |
| ScanAllPlayers | ok |
| ScanArtRoss | ok |
| ScanConnSmythe | ok |
| ScanHart | ok |
| ScanJennings | ok |
| ScanNorris | ok |
| ScanPearson | ok |
| ScanPresidents | ok |
| ScanSelke | ok |
| ScanVezina | ok |
| SeasonAwards | ok |
| SeedPairings | ok |
| SelkeScore | ok |
| SeriesCountTbl | ok |
| SeriesInRound | ok |
| SetupPlayoffs | ok |
| SortAwardScores | ok |
| SortSeeds | ok |
| VezinaScore | ok |
| rtsAwardScan | ok |

## front/stats95

| name | verdict |
|---|---|
| AddHighlight | ok |
| AddPlayerSeasonStats | ok |
| AddTeamSeasonStats | ok |
| GoalsText | renamed (was AssistText; body checked) |
| AssistText | renamed (was AssistsText; body checked) |
| BestGoalieSaves | ok |
| BlankLine40 | ok |
| BuildLeaders | ok |
| BuildLeadersDone | ok |
| BuildPlayerLeaders | ok |
| BuildPlayerLeadersDone | ok |
| ClearLeadersArea | ok |
| CompareHighlight | ok |
| LoadSavedLines | ok |
| DrawHighlightEntry | ok |
| DrawHighlightLogo | ok |
| DrawHighlightPage | ok |
| DrawLeaderLogo | ok |
| DrawLeaderRows | ok |
| DrawLineEditorScreen | ok |
| DrawPlayerLeaderRows | ok |
| DrawSeasonStatsList | ok |
| DrawSeasonStatsLogo | ok |
| DrawSeasonStatsRow | ok |
| DrawTeamStatsLogo | ok |
| GatherAndSort | ok |
| GetPlayoffStat | ok |
| SaveText | renamed (was GoalText; body checked) |
| AssistsText | renamed (was GoalsText; body checked) |
| HighlightPlurals | ok |
| HighlightSingulars | ok |
| HighlightsScreen | ok |
| InitSeasonStats | ok |
| LeaderModeText | ok |
| LeaderPrintJumps | ok |
| LeaderTables | ok |
| LeadersPenMinAvg | renamed (was LeadersField4; body checked) |
| LeadersGoalsAllowed | ok |
| LeadersGoalsAvg | ok |
| LeadersHelp | ok |
| LeadersPoints | ok |
| LeadersSavePct | ok |
| LeadersScrollArrows | ok |
| LeadersShootPct | ok |
| LeadersShotsAllowed | ok |
| LeadersShotsAvg | ok |
| LeagueLeadersScreen | ok |
| LineEditorBg | ok |
| LineEditorReturn | ok |
| MarkSeasonRosters | ok |
| MostAssists | ok |
| MostGoals | ok |
| PeriodStatsCaption | ok |
| PeriodStatsColumns | ok |
| PeriodStatsTeam | ok |
| PeriodStatsValue | ok |
| PlayerCategoryText | ok |
| PlayerLeaderJumps | ok |
| PlayerLeadersAssists | ok |
| PlayerLeadersGAA | ok |
| PlayerLeadersGoals | ok |
| PlayerLeadersPoints | ok |
| PlayerSelectBg | ok |
| PrintGameScore2 | ok |
| PrintHighlight | ok |
| PrintHighlightsTitle | ok |
| PrintLeaderAvg | ok |
| PrintLeaderNum | ok |
| PrintLeaderPct | ok |
| PrintLeadersHeader | ok |
| PrintPlayerCategory | ok |
| PrintScore2 | ok |
| PrintSeasonTeamStats | ok |
| PrintRecordHighlight | renamed (was PrintStatHighlight; body checked) |
| PrintTeamCategory | ok |
| ReadHighlightsPad | ok |
| ReadLeadersPad | ok |
| ReadSeasonTeamRecord | ok |
| ReadStatBlock | ok |
| ReadTeamPlayerStats | ok |
| SaveGameHighlights | ok |
| SaveSimGame | ok |
| SaveTeamLines | ok |
| GoalText | renamed (was SaveText; body checked) |
| SavesText | ok |
| SeasonGetStatColumn | ok |
| SeasonPlayerStats | ok |
| SeasonPlayersScreen | ok |
| SeasonReadStatColumn | ok |
| SeasonScrollArrowTbl | ok |
| SeasonScrollArrows | ok |
| SeasonSkipStatColumn | ok |
| SeasonStatColumnHeaders | ok |
| SeasonStatColumnOffsets | ok |
| SeasonStatSortTitles | ok |
| SeasonStatsList | ok |
| SeasonStatsListDraw | ok |
| SeasonStatsListScroll | ok |
| SeasonStatsListScrollReg | ok |
| SeasonStatsRowDown | ok |
| SeasonStatsRowUp | ok |
| SeasonTeamStats | ok |
| SeasonTeamStatsRun | ok |
| SeasonTeamsScreen | ok |
| SkipStatColumn | ok |
| SortLeadersDown | ok |
| SortLeadersUp | ok |
| StatScrollStep | ok |
| TeamCategoryText | ok |
| TeamLeaderJumps | ok |
| TeamLinesOffset | ok |
| WriteStatBlock | ok |
| WriteTeamPlayerStats | ok |
| rtsHighlight | ok |
| rtsLeaderRows | ok |
| rtsSeasonStats | ok |
| rtsStatsList | ok |

## front/season95

| name | verdict |
|---|---|
| AddSeasonGoals | ok |
| AutoplayCancel | ok |
| AutoplayMessage | ok |
| BuildSeasonTeamList | ok |
| CalendarBg | ok |
| CalendarFirstDay | ok |
| CalendarFirstDayTbl | ok |
| CalendarFirstX | ok |
| CalendarFirstXTbl | ok |
| CalendarGfx | ok |
| CalendarScreen | ok |
| ClearSeasonData | ok |
| CompText | ok |
| CountSeasonMonths | ok |
| CountTeamGames | ok |
| DateToDay | ok |
| DayHasGames | ok |
| DayToDate | ok |
| DrawCalendar | ok |
| DrawCalendarDay | ok |
| DrawCalendarMonth | ok |
| DrawCalendarOpponent | ok |
| DrawCalendarResult | ok |
| DrawCalendarTeam | ok |
| DrawGameLogo | renamed (was DrawGameCursor; body checked) |
| DrawCompMark | renamed (was DrawGameResult; body checked) |
| DrawGameCursor | renamed (was DrawGameTeams; body checked) |
| DrawHumanMark | renamed (was DrawGameUser; body checked) |
| DrawGamesToday | ok |
| DrawSeasonMenu | ok |
| DrawSeasonSetup | ok |
| DrawStandings | ok |
| DrawStandingsLogo | ok |
| FindDayGames | ok |
| GameRowsTbl1 | ok |
| GameRowsTbl2 | ok |
| GameRowsTbl3 | ok |
| GameRowsTbl4 | ok |
| GameRowsTbl5 | ok |
| GameRowsTbl6 | ok |
| GamesToday | ok |
| GamesTodayDone | ok |
| GamesTodayDown | ok |
| GamesTodayExit | ok |
| GamesTodayGfx | ok |
| GamesTodayHelp | ok |
| GamesTodayLines | ok |
| GamesTodayLoop | ok |
| GamesTodayNext | ok |
| GamesTodayPrev | ok |
| GamesTodayToggle | ok |
| GamesTodayUp | ok |
| GetSeasonMenu | ok |
| HumanText | ok |
| MakeDateString | ok |
| MenuCalendar | ok |
| MenuEndSeason | ok |
| MenuGamesToday | ok |
| MenuHighlights | ok |
| MenuLeagueLeaders | ok |
| MenuPlayGames | ok |
| MenuPlayUntil | ok |
| MenuPlayerStats | ok |
| MenuPlayoffPlayerStats | ok |
| MenuPlayoffTeamStats | ok |
| MenuPlayoffTree | ok |
| MenuStandings | ok |
| MenuStay | ok |
| MenuTeamStats | ok |
| MonthDays | ok |
| MonthNames | ok |
| NextSeasonDay | ok |
| NextSeasonTeam | ok |
| PickAssist | ok |
| PickSeasonStartDay | ok |
| PickSimGoalie | ok |
| PlayoffMenuJumps | ok |
| PlayoffMenuText | ok |
| PrevSeasonDay | ok |
| PrevSeasonTeam | ok |
| PrintAutoplayDay | ok |
| PrintGameScores | renamed (was PrintGameLine; body checked) |
| PrintGameScore | ok |
| PrintGamesToday | ok |
| PrintOption | ok |
| PrintOptionHi | ok |
| PrintPreviousDay | ok |
| PrintSetupName | ok |
| PrintSetupValue | ok |
| PrintStandingsHelp | ok |
| PrintStandingsLine | ok |
| PrintWait | ok |
| RandomSetupTeams | ok |
| ReadAnyPad | ok |
| ReadCalendarPad | ok |
| ReadDayGames | ok |
| ReadGamesTodayPad | ok |
| ReadSeasonHeader | ok |
| ReadSeasonMenuPad | ok |
| ReadStandings | ok |
| ReadStandingsPad | ok |
| RecordGameResult | ok |
| RecordTeamResult | ok |
| ScaleSimScore | ok |
| SeasonEndMenuJumps | ok |
| SeasonEndMenuText | ok |
| SeasonGameOver | ok |
| SeasonMain | ok |
| SeasonMenuJumps | ok |
| SeasonMenuText | ok |
| SeasonOptions | ok |
| SeasonOptionsGfx | ok |
| SeasonSetup | ok |
| SeasonSetupCounts | ok |
| SeasonSetupGfx | ok |
| SeasonSetupHelp | ok |
| SeasonSetupLines | ok |
| SetupNameText | ok |
| SetupValueText | ok |
| SimAssists | ok |
| SimDayGames | ok |
| SimGameStats | ok |
| SimGoalie | ok |
| SimGoalieStats | ok |
| SimGoalsAway | ok |
| SimGoalsAwayDef | ok |
| SimGoalsHome | ok |
| SimGoalsHomeDef | ok |
| SimScore | ok |
| SimScorers | ok |
| SimShots | ok |
| SimShotsTbl | ok |
| SimTeamGoals | ok |
| SimTeamTbl | ok |
| SimTieBreak | ok |
| SimTieTbl | ok |
| SkipToGameDay | ok |
| SortStandings | ok |
| StandingsGfx | ok |
| StandingsGroup0 | ok |
| StandingsGroup1 | ok |
| StandingsGroup2 | ok |
| StandingsGroup3 | ok |
| StandingsGroupTbl | ok |
| StandingsGroups | ok |
| StandingsPoints | ok |
| StandingsScreen | ok |
| StandingsTitles | ok |
| StoreSeasonSetup | ok |
| TeamScoring0 | ok |
| TeamScoring1 | ok |
| TeamScoring10 | ok |
| TeamScoring11 | ok |
| TeamScoring12 | ok |
| TeamScoring13 | ok |
| TeamScoring14 | ok |
| TeamScoring15 | ok |
| TeamScoring16 | ok |
| TeamScoring17 | ok |
| TeamScoring18 | ok |
| TeamScoring19 | ok |
| TeamScoring2 | ok |
| TeamScoring20 | ok |
| TeamScoring21 | ok |
| TeamScoring22 | ok |
| TeamScoring23 | ok |
| TeamScoring24 | ok |
| TeamScoring25 | ok |
| TeamScoring3 | ok |
| TeamScoring4 | ok |
| TeamScoring5 | ok |
| TeamScoring6 | ok |
| TeamScoring7 | ok |
| TeamScoring8 | ok |
| TeamScoring9 | ok |
| TeamScoringTbls | ok |
| WrapSetupDown | ok |
| WrapSetupUp | ok |
| WriteDayGames | ok |
| WriteSeasonHeader | ok |
| rtsdemo | ok |

## front/create95

| name | verdict |
|---|---|
| AdjustAttrib | ok |
| BuildEnteredName | ok |
| BuildFreeAgentList | ok |
| CheckCreateSlots | ok |
| CheckMaxDefense | ok |
| CheckMaxForwards | ok |
| CheckMaxGoalies | ok |
| CheckMinDefense | ok |
| CheckMinForwards | ok |
| CheckMinGoalies | ok |
| ClearAttribDeltas | ok |
| ClearCreateArea | ok |
| ClearCreatedPlayers | ok |
| CommitAttribJumps | ok |
| CommitCreatedPlayer | ok |
| CommitNone1 | ok |
| CommitNone2 | ok |
| CopyNameWords | ok |
| CountNameLength | ok |
| CrScale | ok |
| CrScaleEven | ok |
| CrScaleLookup | renamed from CrScaleTable |
| CreateLetterGrid | ok |
| CreatePlayer | ok |
| CreateRatingsGfx | ok |
| CreateRecordTail1 | ok |
| CreateRecordTail2 | ok |
| CreateScreenGfx | ok |
| DeleteCreatedPlayer | ok |
| DrawCreateList | ok |
| DrawField | ok |
| DrawFreeAgents | ok |
| DrawRatingValue | ok |
| DrawRatings | ok |
| DrawReleaseRoster | ok |
| EditAggression | ok |
| EditAgility | ok |
| EditChecking | ok |
| EditCol3 | ok |
| EditCol4 | ok |
| EditDefAware | ok |
| EditEndurance | ok |
| EditField | ok |
| EditGAgility | ok |
| EditGDefAware | ok |
| EditGGloveL | ok |
| EditGGloveR | ok |
| EditGPuckCtrl | ok |
| EditGStickL | ok |
| EditGStickR | ok |
| EditHand | ok |
| EditJersey | ok |
| EditNone | ok |
| EditOffAware | ok |
| EditPassAcc | ok |
| EditPlayerType | ok |
| EditShotAcc | ok |
| EditShotPower | ok |
| EditSpeed | ok |
| EditStickhandling | ok |
| EditWeight | ok |
| FieldAggression | ok |
| FieldAgility | ok |
| FieldBlank1 | ok |
| FieldBlank2 | ok |
| FieldChecking | ok |
| FieldCol3 | ok |
| FieldCol4 | ok |
| FieldDefAware | ok |
| FieldDone | ok |
| FieldEndurance | ok |
| FieldGAgility | ok |
| FieldGDefAware | ok |
| FieldGGloveL | ok |
| FieldGGloveR | ok |
| FieldGPuckCtrl | ok |
| FieldGStickL | ok |
| FieldGStickR | ok |
| FieldHand | ok |
| FieldHighlight | ok |
| FieldJersey | ok |
| FieldOffAware | ok |
| FieldPassAcc | ok |
| FieldPos | ok |
| FieldPrintSetup | ok |
| FieldShotAcc | ok |
| FieldShotPower | ok |
| FieldSpeed | ok |
| FieldStickhandling | ok |
| FieldWeight | ok |
| FindGridLetter | ok |
| FixFirstLetter | ok |
| FormatNameRecord | ok |
| FreeAgentArrows | ok |
| FreeAgentExit | ok |
| FreeAgentLoop | ok |
| FreeAgentMsgText | ok |
| FreeAgentRedraw | ok |
| FreeAgentTeamBlock | ok |
| FreeAgentViolation | ok |
| FreeAgentsEmpty | ok |
| FreeAgentsFull | ok |
| GetCreateName | ok |
| GetCreatedId | ok |
| GoalieEditCol1 | ok |
| GoalieEditCol2 | ok |
| GoalieEditTbl | ok |
| GoalieFieldCol1 | ok |
| GoalieFieldCol2 | ok |
| GoalieFieldTbls | ok |
| GoalieLabelLists | ok |
| GoalieLastRows | ok |
| GoalieSaveLabels | ok |
| GoalieSkillLabels | ok |
| GridLetterPos | ok |
| HandText | ok |
| HandUniformLabels | ok |
| InitCreateRecord | ok |
| InitCreateRecord2 | ok |
| InvalidName | ok |
| SaveNameError | renamed (was InvalidNameWait; body checked) |
| LastFieldRow | ok |
| ListMarkers | ok |
| ListMarkersOff | ok |
| LoadCreateTemplate | ok |
| ModifyRatings | ok |
| MoveListMarkers | ok |
| NameEntry | ok |
| NameEntryBg | ok |
| NameEntryBgTail | ok |
| NameEntryDone | ok |
| NameListHelp | ok |
| NameListMode | ok |
| NewCreateRecord | ok |
| PosText | ok |
| PosWeightLabels | ok |
| PositionCountFns | ok |
| PositionLetters3 | ok |
| PositionLetters4 | ok |
| PositionMaxChecks | ok |
| PositionMinChecks | ok |
| PrintCreateName | ok |
| PrintEditName | ok |
| PrintFieldLabel | ok |
| PrintGridLetter | ok |
| PrintListMarkers | ok |
| PrintUnallocated | ok |
| ReadCreateList | ok |
| ReadCreatedPlayers | ok |
| ReadFreeAgentPads | ok |
| ReadReleasePads | ok |
| ReleaseArrows | ok |
| ReleaseExit | ok |
| ReleaseLoop | ok |
| ReleaseMsgText | ok |
| ReleasePlayers | ok |
| ReleaseRedraw | ok |
| ReleaseTeamBlock | ok |
| ReleaseViolation | ok |
| SaveCreateName | ok |
| SaveNameNoSlot | renamed (was SaveNameEnd; body checked) |
| SaveNameDone | renamed (was SaveNameFail; body checked) |
| SaveNameListFull | renamed (was SaveNameLoop2; body checked) |
| SaveNewName | renamed (was SaveNameNext; body checked) |
| SaveNameOk | ok |
| SaveNameRet | ok |
| SetPointsPool | ok |
| SignFreeAgents | ok |
| SkaterEditCol1 | ok |
| SkaterEditCol2 | ok |
| SkaterEditTbl | ok |
| SkaterFieldCol1 | ok |
| SkaterFieldCol2 | ok |
| SkaterFieldTbls | ok |
| SkaterLabelLists | ok |
| SkaterLastRows | ok |
| SkaterShotLabels | ok |
| SkaterSkillLabels | ok |
| TestFreeAgents | ok |
| WriteCreateList | ok |
| rtsAdjustAttrib | ok |
| rtsCreate2 | ok |
| rtsCreate3 | ok |
| rtsCreate4 | ok |
| rtsCreate5 | ok |

## sound95

| name | verdict |
|---|---|
| SfxTable | ok |
| SndAddNote | ok |
| SndClearNotes | ok |
| SndDriver | ok |
| SndFindBankItem | ok |
| SndFreeBlocks | ok |
| SndLoadList | ok |
| SndLoadZ80 | ok |
| SndPauseZ80 | ok |
| SndPutZ80Cmd | ok |
| SndReadBlock | ok |
| SndReleaseNotes | ok |
| SndResetBlocks | ok |
| SndResumeZ80 | ok |
| SndSendZ80 | ok |
| SndSetBank | ok |
| SndStartSeq | ok |
| SndStopAll | ok |
| SndStopSeq | ok |
| SndStreamZ80 | ok |
| SndUpdate | ok |
| SndUpdateNotes | ok |
| SndUploadBlock | ok |
| SndWriteBlock | ok |
| SoundBanks | ok |
| SoundCmd | ok |
| SoundOff | ok |
| StartSong | ok |
| Z80BusRelease | ok |
| Z80BusRequest | ok |
| Z80Program | ok |
| sfxplay | ok |
| stop_current_song2 | renamed from play_new_song2 |

## frames95

| name | verdict |
|---|---|
| SPAblock | ok |
| SPAblock_table | ok |
| SPAfakeshotb | ok |
| SPAfakeshotb_table | ok |
| SPAfakeshotf | ok |
| SPAfakeshotf_table | ok |
| SPAghighr | ok |
| SPAghighr_table | ok |
| SPAgglovel2 | ok |
| SPAgglovel2_table | ok |
| SPAglidewp | ok |
| SPAglidewp_table | ok |
| SPAgofallback | ok |
| SPAgofallback_table | ok |
| SPAgofallglove | ok |
| SPAgofallglove_table | ok |
| SPAinjury2 | ok |
| SPAinjury2_table | ok |
| SPApassb2 | ok |
| SPApassb2_table | ok |
| SPAdroppass | ok |
| SPAdroppass_table | ok |
| SPApump3 | ok |
| SPApump3_table | ok |
| SPAhipchkl | ok |
| SPAhipchkl_table | ok |
| SPAhipchkr | ok |
| SPAhipchkr_table | ok |
| SPAskate | ok |
| SPAskate_table | ok |
| SPAburst | ok |
| SPAburst_table | ok |
| SPAskatewp2 | ok |
| SPAskatewp2_table | ok |
| SPAstopwp | ok |
| SPAstopwp_table | ok |
| SPAturnlwp | ok |
| SPAturnlwp_table | ok |
| SPAturnrwp | ok |
| SPAturnrwp_table | ok |
| SPFblock | ok |
| SPFboard | ok |
| SPFboardchk | ok |
| SPFboardmid | ok |
| SPFburst | ok |
| SPFfaceoff | ok |
| SPFgextra1 | ok |
| SPFgextra2 | ok |
| SPFglide | ok |
| SPFglidewp | ok |
| SPFgskate | ok |
| SPFgslambot | ok |
| SPFgslamtop | ok |
| SPFgstack | ok |
| SPFgstackalt | ok |
| SPFpad34 | ok |
| SPFpump2 | ok |
| SPFshoulder2 | ok |
| SPFstopwp | ok |
| SPFswingb | ok |
| SPFturnlwp | ok |
| SPFturnrwp | ok |

## graphics95

| name | verdict |
|---|---|
| ArtRossPic | ok |
| AwardsBgMap | ok |
| BigFontMap2 | ok |
| BigFontMap3 | ok |
| CalCheckMap | ok |
| CalDayMap | ok |
| CalMonthMap | ok |
| CalOpponentMap | ok |
| CalResultMap | ok |
| CalendarBgMap | ok |
| CardAdamGraves | ok |
| CardAlexeiGusarov | ok |
| CardAlexeiYashin | ok |
| CardAlexnderDaigle | ok |
| CardAlexnderGodynyuk | ok |
| CardAndreiLomakin | ok |
| CardBillHoulder | ok |
| CardBobCorkum | ok |
| CardBrianBenning | ok |
| CardBryanSmolinski | ok |
| CardChrisGratton | ok |
| CardChrisPronger | ok |
| CardCoreyMillen | ok |
| CardCraigBillington | ok |
| CardDarenPuppa | ok |
| CardDerianHatcher | ok |
| CardDominicRoussel | ok |
| CardDominikHasek | ok |
| CardGarryValk | ok |
| CardGordMurphy | ok |
| CardGuyHebert | ok |
| CardIgorLarionov | ok |
| CardJamieMacoun | ok |
| CardJariKurri | ok |
| CardJeffNorton | ok |
| CardJesseBelanger | ok |
| CardJoeMurphy | ok |
| CardJohnMacLean | ok |
| CardKeithTkachuk | ok |
| CardMikeRichter | ok |
| CardSandisOzolinsh | ok |
| CardScottNiedrmayer | ok |
| CardSeanHill | ok |
| CardSergeiMakarov | ok |
| CardSergeiZubov | ok |
| CardShawnChambers | ok |
| CardStephaneFiset | ok |
| CardSylvainCote | ok |
| CardTerryYake | ok |
| CardUlfDahlen | ok |
| CardValeriKamensky | ok |
| CardWendelClark | ok |
| CardZdenoCiger | ok |
| ClockDigitsBitmap | ok |
| ConnSmythePic | ok |
| ControllerBgMap | ok |
| ControllerTitleMap | ok |
| CreateBgMap | ok |
| CupSprites | ok |
| FaceoffTiles | ok |
| FaceoffTiles2 | ok |
| FeaturedPicIdx | ok |
| FinalistsPanelMap | ok |
| Framermap2 | ok |
| FreeAgentMap1 | ok |
| FreeAgentMap2 | ok |
| GMDecisionMap | ok |
| GamesTodayLogoMap | ok |
| GamesTodayMap1 | ok |
| GamesTodayMap2 | ok |
| GamesTodayMap3 | ok |
| HartPic | ok |
| HiScoreBgMap | ok |
| HighlightsBgMap | ok |
| JenningsPic | ok |
| LineEditorBgMap | ok |
| NameEntryBgMap | ok |
| NorrisPic | ok |
| PadCursorMap | ok |
| PadIconMap1 | ok |
| PadIconMap2 | ok |
| PadIconMap3 | ok |
| PadIconMap4 | ok |
| PauseBgBitmap | ok |
| PauseFontMap | ok |
| PauseTeamBlocksMap | ok |
| PearsonPic | ok |
| PeriodNumberBitmap | ok |
| PeriodStatsMap | ok |
| PlayerSelectMap1 | ok |
| PlayerSelectMap2 | ok |
| PlayerStatsBgMap | ok |
| PlayerStatsTitleMap | ok |
| PresidentsPic | ok |
| RefTiles | ok |
| RefTilesHor | ok |
| ReplayIconMap | ok |
| RosterBitmap | ok |
| RosterFont | ok |
| ScoutReportMap | ok |
| Screen6Tiles1 | ok |
| Screen6Tiles2 | ok |
| SelkePic | ok |
| SetupBgMap1 | ok |
| SetupBgMap2 | ok |
| SetupFont | ok |
| SmallFontMap2 | ok |
| StanleyCupImg | ok |
| TabBitmap | ok |
| TradeAdvantageMap1 | ok |
| TradeAdvantageMap2 | ok |
| TradeBgMap | ok |
| VezinaPic | ok |
| WaitBoxMap | ok |
| WinnerPanelMap | ok |

## RAM names (ram95.asm), checked by usage
| name | verdict |
|---|---|
| AttribDeltas | ok |
| AutoplayDay | ok |
| AwDefMode | ok |
| AwardCount | ok |
| AwardCycle | ok |
| AwardFlashTimer | ok |
| AwardHilite | ok |
| AwardIds | ok |
| AwardIndex | ok |
| AwardScores | ok |
| AwardTimer | ok |
| AwardWait | ok |
| AwardWinner | ok |
| CalDay | ok |
| CalFirst | ok |
| CalGamePtr | ok |
| CalGames | ok |
| CalLast | ok |
| CalMonth | ok |
| CalMonths | ok |
| CalTeam | ok |
| CalX | ok |
| CalY | ok |
| ChkBodyP | ok |
| ChkBodySqP | ok |
| ChkStickP | ok |
| ChkStickSqP | ok |
| CreateCursorX | ok |
| CreateCursorY | ok |
| CreateIndex | ok |
| CreateListOldRow | ok |
| CreateListRow | ok |
| CreateListSel | ok |
| CreateListTop | ok |
| CreatePoints | ok |
| CreateRecord | ok |
| CreateType | ok |
| CreateWork | ok |
| CreatedIds | ok |
| CreatedList | ok |
| CreatedPlayerBuf | ok |
| FieldTextBuf | ok |
| GameFlags | ok |
| GamesTodayDay | ok |
| HmDefMode | ok |
| LeaderPlayers | ok |
| LeaderTeamTbls | ok |
| LeaderValues | ok |
| LineHoldFlag | ok |
| LineHoldTimer | ok |
| NameEntryBuf | ok |
| NameEntryLen | ok |
| NameEntryMode | ok |
| NegChkBodyP | ok |
| NegChkStickP | ok |
| PlayingSong | ok |
| PlayoffSchedule | ok |
| ReplayIconChars | ok |
| RosterRatings | ok |
| RosterTable | ok |
| SRAMChecksum | ok |
| SRAMSize | ok |
| SRAMbyte | ok |
| SRAssists | ok |
| SRChecksum | ok |
| SRCreateCount | ok |
| SRCreatedPlayers | ok |
| SRCrowdRecords | ok |
| SRCupWinner | ok |
| SRFreeAgentCount | ok |
| SRFreeAgentJerseys | ok |
| SRFreeAgentList | ok |
| SRGameResults | ok |
| SRGamesPlayed | ok |
| SRGoalTotal | ok |
| SRGoals | ok |
| SRHighlights | ok |
| SRInjuries | ok |
| SRJerseyNums | ok |
| SRLineData | ok |
| SRLines | ok |
| SRNameLog | ok |
| SRPOAssists | ok |
| SRPODay | ok |
| SRPOGamesPlayed | ok |
| SRPOGoals | ok |
| SRPOPairings | ok |
| SRPOPenMin | ok |
| SRPORound | ok |
| SRPOSchedule | ok |
| SRPOSeries | ok |
| SRPOShots | ok |
| SRPOStandings | ok |
| SRPOTeamStats | ok |
| SRPenMin | ok |
| SRRosters | ok |
| SRSavedLines1 | ok |
| SRSavedLines2 | ok |
| SRSavedLines3 | ok |
| SRSeasonHeader | ok |
| SRSeasonHeaderSave | ok |
| SRSeasonMark | ok |
| SRShots | ok |
| SRStandings | ok |
| SRTeamBlock2 | ok |
| SRTeamRecords | ok |
| SRTeamStats | ok |
| SaveRAM | ok |
| SeasonDay | ok |
| SeasonFlags | ok |
| SeasonGameCount | ok |
| SeasonGoalSum | ok |
| SeasonLength | ok |
| SeasonLine | ok |
| SeasonPen | ok |
| SeasonPerlen | ok |
| SeasonStartDay | ok |
| SeasonTeams | ok |
| SeedCount | ok |
| SeedGames | ok |
| SeedPoints | ok |
| ShotTimer | ok |
| SimFlags | ok |
| SimWeights | ok |
| SndBanks | ok |
| SndDrvRAM | ok |
| SndNoteCount | ok |
| SndNotes | ok |
| SndSeqArg1 | ok |
| SndSeqFrac | ok |
| SndSeqId | ok |
| SndSeqIndex | ok |
| SndSeqPos | ok |
| SndSeqPtr | ok |
| SndSeqState | ok |
| SndSeqTempo | ok |
| SndSeqWait | ok |
| SndStopSlot | ok |
| SndStreamBase | ok |
| SndStreamLoop | ok |
| SndStreamPtr | ok |
| StandingsBuf | ok |
| StandingsList | ok |
| StandingsMode | ok |
| StandingsOrder | ok |
| StandingsRecs | ok |
| StatBuf | ok |
| StatWork | kept: multi-use scratch |
| TeamBlockMaps | ok |
| TeamLeaderValues | ok |
| TradeBuf | kept: multi-use scratch |
| TradeData | ok |
| TradeFromTeam | ok |
| TradeRoster1 | ok |
| TradeRoster2 | ok |
| TradeToTeam | ok |
| TradeWork | kept: multi-use scratch |
| attribcount | ok |
| attribplayer | ok |
| attribsum | ok |
| awardpanelchars | ok |
| awardpicchars | ok |
| awaypracplayers | renamed (was awaygoaliectl; body checked) |
| awayusers | ok |
| bigfontptr | ok |
| calbgchars | ok |
| calresultchars | ok |
| clockdigitchars | ok |
| createdcount | ok |
| crowdtblidx | ok |
| cupframe | ok |
| cupticks | ok |
| cupwinner | ok |
| framerchars | ok |
| framermapptr | ok |
| gamestoday1chars | ok |
| gamestoday3chars | ok |
| gamevarend | ok |
| homepracplayers | renamed (was homegoaliectl; body checked) |
| homeusers | ok |
| injurygames | ok |
| jerseynum | ok |
| lastpuckc | ok |
| linemarkbuf | ok |
| menucursor | ok |
| menuitemoffset | ok |
| menupadnum | ok |
| menutimer | ok |
| optbgchars | ok |
| pad1user | ok |
| pad2user | ok |
| pad3user | ok |
| pad4user | ok |
| pad4wayword2 | ok |
| padcursorchars | ok |
| padiconchars1 | ok |
| padiconchars2 | ok |
| padiconchars3 | ok |
| padiconchars4 | ok |
| pauselogochars | ok |
| pausetimeout | ok |
| penaltymsgs | ok |
| penboxattr | ok |
| recuser1 | ok |
| recuser2 | ok |
| recwincount | ok |
| rosterscroll | ok |
| rosterteam | ok |
| screen6chars1 | ok |
| screen6chars2 | ok |
| screen6chars3 | ok |
| screenarg | ok |
| seasonsetupreq | ok |
| seasonteamsel | ok |
| setupdir | ok |
| setuplines | ok |
| setupshown | ok |
| setupvalues | ok |
| sflags10 | ok |
| sflags11 | ok |
| sflags12 | ok |
| sflags13 | ok |
| sflags9 | ok |
| shotpflags | ok |
| smallfont3chars | ok |
| smallfont4chars | ok |
| smallfontptr | ok |
| soawaygoals | renamed awayshootgoals (94 name) |
| sohomegoals | renamed homeshootgoals (94 name) |
| tabchars | ok |
| teamblocksmapptr | ok |
| teamblockwidth | ok |
| tradeteam1 | ok |
| tradeteam2 | ok |
| turnstep | ok |

## Local labels

| scope | status |
|---|---|
| routines with the same structure as 94 | 94 local names propagated (24 renames) |
| everything else | open |
| prop.py MISMATCH routines (renumbered in 95) | 76 locals given the 94 name where the instruction at the label matches a unique 94 label (tools_ll/align.py): doinput, dopass, Pausemode, HandleMenuInput, UpdateMenuSelection, ManualGoalieMenu, printsmall, stats/scout/summary/shootout/records screens ... |
| all routines with a same-named 94 routine | 470 more locals given the 94 name by unique instruction match at the label (align.py); comment text verified unchanged |
| routines matching a 93 or 92 routine by name | 48 more locals given the 93/92 name (align.py) |
| new-in-95: video, summary, replay, display, control, main, crowd, hockey, playoff | routine names ok; ReplayMode .exit, ShowCrowdFrame .find/.next, PlayoffScreen .wait; rest short skips |
| 94->95 propagation + consistency (consist.py) | all 94G local names checked against the matching 95 routine: 110 present; hand-aligned this step: GameSetUp .fix, HandleMenuInput .sel, LineEditorExit/Pausemode .loop, ManualGoalieMenu .g1, Scoring/PenaltySummaryScreen .toend, WaitVSyncAndReadInput .wait, checkanim .far, checkgoal .stat, doinput .bpress/.brel/.goalie/.noswitch, goaliesave .done, PeriodStatsScreen .title, CalcAttribRating .bit/.next/.attribadd/.pos (the 94 CalcAttrib loop moved there). Open (95 code at that point restructured, no label at the same instruction; needs hand read): DisplayPlayerList .row, DrawGoalieSelectList .row/.skip, DrawStatsList .skip, DrawTeamLogo .draw, FormatLastName .pad, GameStatisticsScreen .scroll, GetGoalieCount .count, HotColdIcon .draw, PeriodStatsScreen .lines/.team/.num, RecordHoldersScreen .show, ResolveGames .win, ShowGoalBox .print, UpdateScoutingDisplay .roster, assscore .chkx, checkanim .save, checkgoal .addg/.sum, doinput .nostart/.chkfight, p_music_vblank .next, printbig .nocom. Routines named differently in 95 (not found by name): AddArenaAnimSprite, ChangeOption, GetLeagueCrowdRecord, Intermission, PlayerCardScreen, PlayerCards, PrintOptionNames, RunArenaAnim, doinput_ispc, waitxsr |
| new-in-95: shootout, players, logic, injury, input, skate | routine names ok; injury slot loops .loop/.next, CheckInjury .done; the rest short skips or 94 names |
| 94->95 consistency gaps (hand read) | aligned: FormatLastName .pad, HotColdIcon .loop/.loop2/.draw, GetGoalieCountD7 .count, ResolveGames (all 94 locals), ShowGoalBox .frame/.print (+numbers), printbigtext .nocom, DisplayPlayerList .row, DrawGoalieSelectList .row, UpdateScoutingDisplay .roster/.loop4, assscore .chkx, PeriodStatsScreen .3 (was a wrong .title; 94 .title/.lines/.team/.num are now PeriodStatsCaption/PeriodStatsColumns), checkanim .save, Goal (94 checkgoal goal part) .loop/.addg/.loop2 (+numbers), doinput .nostart. No counterpart (95 rewritten): DrawStatsList .skip, DrawTeamLogo .draw, GameStatisticsScreen .scroll (now StatScrollStep), RecordHoldersScreen .show, p_music_vblank .next, checkgoal .sum (already .sum in Goal), doinput .chkfight (95 has no fight check there; .islocked kept) |
| routines named differently in 95 | IntermissionMenu -> Intermission (94 routine, same body start; .1/.clr aligned). PlayerCardScreen merged into 95 PlayerCardTimer (.loop aligned). AddArenaAnimSprite .spr part = 95 ShowCrowdFrame (crowd frames; name kept, .loop2/.x aligned). No 95 counterpart: ChangeOption (WrapOptionUp/Down), PrintOptionNames (PrintOptions rewritten), RunArenaAnim, GetLeagueCrowdRecord, PlayerCards, doinput_ispc (inlined as doinput .ispc), waitxsr (no zamboni) |
| new-in-95 locals: season | full body read of every new-in-95 routine (181): game list marks/cursor renamed to what they draw (DrawGameTeams->DrawGameCursor, DrawGameCursor->DrawGameLogo, DrawGameUser->DrawHumanMark, DrawGameResult->DrawCompMark, PrintGameLine->PrintGameScores; flags bit 0 set = computer game); headers fixed (those, GamesTodayToggle, PrintPreviousDay, ReadAnyPad never times out, ReadGamesTodayPad does, ReadStandings is W/T/L, SimTieBreak, SimScore, SimTeamTbl, ClearSeasonData, SortStandings, PrintStandingsLine); locals named in SeasonMain, PickSeasonStartDay, Read/WriteDayGames, SimScorers, ScaleSimScore, SeasonSetup, DrawGamesToday, SeasonOptions, MenuPlayUntil, CalendarScreen, DrawCalendar, StandingsScreen, SortStandings and the five pad readers (.wait) |
| new-in-95 locals: stats | full body read of every new-in-95 routine (117): highlight suffix labels were swapped against their strings, renamed so each matches its text (GoalsText/GoalText/AssistsText/AssistText/SaveText); PrintStatHighlight->PrintRecordHighlight (type 4 prints a team W-L-T record), LeadersField4->LeadersPenMinAvg; headers fixed (AddPlayerSeasonStats goalie PIM, SeasonStatColumnOffsets, PrintRecordHighlight, PrintHighlight, DrawHighlightPage, DrawHighlightEntry, LeadersHelp, DrawLineEditorScreen); locals named in SaveGameHighlights, AddPlayerSeasonStats, SeasonStatsListDraw, DrawSeasonStatsList, DrawSeasonStatsRow, SeasonTeamStatsRun, LeagueLeadersScreen, ReadLeadersPad, ReadHighlightsPad, SortLeadersDown/Up, DrawLeaderRows, DrawPlayerLeaderRows, HighlightsScreen; RAM homegoaliectl/awaygoaliectl -> homepracplayers/awaypracplayers |
| new-in-95 locals: create | full body read of every new-in-95 routine (185): SaveCreateName tail labels renamed to what they do (SaveNameNext->SaveNewName, SaveNameLoop2->SaveNameListFull, SaveNameEnd->SaveNameNoSlot, InvalidNameWait->SaveNameError, SaveNameFail->SaveNameDone: it returns d0 = 0); headers fixed (those, SaveNameOk, CopyNameWords and BuildEnteredName use StatWork, NameEntryBgTail unreferenced, FieldHighlight, FieldDone, EditPlayerType wraps, CommitAttribJumps, ClearCreateArea); locals: CreatePlayer .edit/.invalid, AdjustAttrib .undo, ModifyRatings .draw/.frame/.vwait/.column/.clamp/.done, FreeAgentLoop and ReleaseLoop .check/.input, ReleaseLoop .find/.block/.shift, ReadFreeAgentPads / ReadReleasePads .wait |
| new-in-95 locals: trade | full body read of every new-in-95 routine (50): renamed MoveTradedPlayer->ExtractTradedPlayer (takes the player out) and RemoveTradedPlayer->InsertTradedPlayer (puts him in; names were reversed), FixSavedLine->FixLinesRemoved, FixSavedLine2->FixLinesInserted, MoveSavedLines->FixJerseyNumber (makes the jersey number unique), SortTradePlayers->TagTradePositions (no sort), TradeStatOffsets(2)->TradeCountOffsets(2), DrawTradeTeam->BuildTradeRoster (draws nothing), GMDecision->GMDecisionGfx (graphics only), GMDecisionRetry->GMDecisionScreen (the GM DECISION screen); headers fixed for these and DefaultRosters (count order), GetRosterName (no SRAM address), ShiftTradeUp/Down, TradePlayers (buttons), CheckTrade (Z flag result), EvaluateTrade, ReadEvalTradePads / ReadGMDecisionPads (no timeout); locals named in all routines with branches (CheckTrade error setters were auto .loop names, not loops) |
| new-in-95 locals: setup | full body read of every new-in-95 routine (23): names ok; headers fixed: GetSetupValues, UpdateSetupLogos, DrawSetupLogo (broken text); locals: FindPlayerLine .next/.found, PrintOptionName .hi (was auto .loop2, not a loop)/.nothi/.normal/.done/.chksel, UpdateSetupLogos .changed/.delay/.swaph/.homeblk/.vis/.swapv/.visblk, DrawSetupLogo .gotchars/.vispal/.pal/.draw, StepSeasonTeam .prev/.chk, SetTreeGameTeams .noflip |
| new-in-95 locals: sound | full body read of every new-in-95 routine (33; SoundBanks item list only scanned, it is data): routine names and headers ok; ROM address removed from the Z80Program pad comment; locals named in SndLoadZ80, SndUpdate (event decoder: .events/.event/.running/.ctrl/.chkloop/.prog/.bend/.chkend/.delay/.nextslot ...), SndStartSeq, SndStopSeq, SndPutZ80Cmd, SndUploadBlock, SndReadBlock, SndWriteBlock, SndPauseZ80, SndResumeZ80, SndStopAll, SndClearNotes, SndReleaseNotes, SndUpdateNotes, SndStreamZ80, SndFindBankItem, SndSetBank, SndLoadList, SndFreeBlocks, SndResetBlocks, Z80BusRequest, sfxplay; SndDriver dispatch keeps .0-.15 |
| new-in-95 locals: awards | full body read of every new-in-95 routine (68): names ok; headers fixed: GetTeamUser (tmstruct), SelkeScore (score formula); locals named in GetTeamUser, SeasonAwards, PrintFinalists (.blank String, .player, .item ...), FlashWinnerCaption, AwardsLoop, SortAwardScores, ScanPresidents, ScanAllPlayers, SortSeeds, CalcSeedPoints, SetupPlayoffs, RestoreSeasonHeader, NextPlayoffRound, InitPlayoffSeries, BuildPlayoffDayGames, ReadPlayoffSchedule, RecordPlayoffGame, CollectSeriesWinners, PlayoffTreeScreen |
| new-in-95 locals: pause | full body read of every new-in-95 routine (36): names ok; ShowPenaltyMessages header fixed (shows and removes the last queued entry); locals: SetStatsMenuItems .set, ShowPenaltyBox .count/.counted/.list/.next, ListPenaltyBox .next, ShowPenaltyBoxPlayer .full, RestoreGameScreen .clrpal/.ref/.load/.rink/.wait, ClearOldFrames .sort/.sso/.pads, DrawMenuInfo .get/.draw/.done, ShowPenaltyMessages .notempty/.next/.empty/.end/.skip/.find/.found/.done/.exit, PauseScores .tens/.ones/.tens2/.ones2 |
| new-in-95 locals: middle | full body read of every new-in-95 routine (36): names ok; AssignPads header fixed (practice player counts, not goalie control); locals: showclockdma .gotclock, GetGoalieCountD7 .teamdata, name formatters .skipfirst/.copy (were auto .loop/.loop2), CalcAttribRating .create/.chkmax/.add, PushNumberWidthZero .pow/.digit/.num/.put; printbigtext keeps print's .0/.1 pattern (auto .loop -> .0) |
| new-in-95 locals: lines | full body read of every new-in-95 routine (16): names ok; headers fixed: LoadTeamLines (sets per line change option, SRAM rule), DrawTeamScreen4 (no dma); locals: DrawTeamScreen2-6 vblank wait .0 as in DrawTeamScreen, DefaultLineData .team/.set, LoadTeamLines .nolc/.teamdata/.copy/.teamdata2/.copy2, FixSavedLines .rec/.line/.nextrec and clamp subroutines .goalie/.defense/.dlow/.forward/.flow/.extra/.nextslot (were auto .loop3-.loop9), CheckTeamLines .rec/.slot/.nextslot/.nextrec/.invalid, LineSlotFixTbl handlers .goalie/.defense/.forward/.extra/.none with .d*/.f*/.x* steps and .inlines/.search/.found |
| new-in-95 locals: records | full body read of every new-in-95 routine (CountTeamPads, NameInUse, SkipPadName, ClearNameHelp, GetPadUser, UpdateUserRecord): names and headers ok; UpdateUserRecord .hasteam, .chkaway, .order, .awayfirst, .user (was an auto .loop, not a loop) |
| new-in-95 locals: goal | full body read of every new-in-95 routine (27): the practice 'goalie control' is the practice player count (strings 'No. of Players', limits by position), renamed SetGoaliesCtl->PullPracticePlayers, GoalieCtlLimits->PracticePlayerLimits, GetGoalieCtl->GetPracticePlayers, PrintPracticeGoalies->PrintPracticePlayers, PrintGoalieCount->PrintPlayerCount, GoalieCountTxt->PlayerCountTxt, PracticeGoalieTbl->PracticePlayersTbl (RAM renamed homepracplayers / awaypracplayers); headers fixed (those, PracticeGoalies, SetContTeams, PrintPracticeTitle had highlight inverted); locals: AssignTeam .assign/.next, PullPracticePlayers .team/.pull/.next, PracticeGoalies .home/.chkaway/.away/.done, SetContTeams .clear (auto .loop, not a loop)/.setup/.frame/.wait/.keys/.up/.pads/.pad/.right/.fewer/.more/.nextpad, DrawPadSetup .draw, PrintPracticeTitle .normal |
| new-in-95 locals: scout | full body read of every new-in-95 routine (10): names ok; GetPlayerPicture header fixed (featured picture for the first six, else generic) and locals .sram, .gotslot, .find, .featured, .generic, .alt, .done |
| new-in-95 locals: faceoff | full body read of every new-in-95 routine (rtsfaceoff, DrawFaceoffWindow): names and headers ok; DrawFaceoffWindow .setx, .names |
| new-in-95 locals: title | full body read of every new-in-95 routine (8): names and headers ok; CupVBlank .skip/.nodma, CupBuildSprites .add, AddSpriteFrame .full; StanleyCupScreen / CupWaitFrame / AddSpriteFrame .loop are real loops |
| new-in-95 locals: collide | full body read of every new-in-95 routine (checkinglist2, rtspuck, DropPuck): names and headers ok; DropPuck .0 a trivial skip |
| new-in-95 locals: penalty | full body read of every new-in-95 routine (rtspen): name and header ok; no locals |
| data labels / equates (usage check) | every equate and global label checked for references: all unreferenced ones are marked as such in their comment; TmpJoyPuckCarrier removed (not used in 95, it shared PlayerChked's address); duplicate-address equates are RAM overlays used by different screens; SPAcelebrate / SPApump2 comments fixed |
