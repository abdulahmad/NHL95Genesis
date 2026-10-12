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

## tables/schedule95

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
| GetGoalieCtl | ok |
| GoalieCountTxt | ok |
| GoalieCtlLimits | ok |
| LockScroll | ok |
| PadIconChars | ok |
| PadIconMaps | ok |
| PracticeGoalieTbl | ok |
| PracticeGoalies | ok |
| PracticePlayersTxt | ok |
| PrintGoalieCount | ok |
| PrintPracticeGoalies | ok |
| PrintPracticeTitle | ok |
| PrintSetupStr | ok |
| PrintSetupStrHi | ok |
| ReadAllPads | ok |
| SetContTeams | ok |
| SetGoaliesCtl | ok |
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
| DrawTradeTeam | ok |
| DrawVisTradeRoster | ok |
| EvaluateTrade | ok |
| ExecuteTrade | ok |
| FixSavedLine | ok |
| FixSavedLine2 | ok |
| GMDecision | ok |
| GMDecisionRetry | ok |
| GetCreatedName | ok |
| GetHighlightSlot | ok |
| GetJerseyNumber | ok |
| GetRosterId | ok |
| GetRosterName | ok |
| GetRosterNameTail | ok |
| HighlightsHelp | ok |
| InvalidTradeText | ok |
| MoveSavedLines | ok |
| MoveTradedPlayer | ok |
| PositionLetters | ok |
| PositionLetters2 | ok |
| PrintTradeNames | ok |
| PrintTradedPlayers | ok |
| ReadEvalTradePads | ok |
| ReadGMDecisionPads | ok |
| ReadTeamRoster | ok |
| ReadTradePads | ok |
| RemoveTradedPlayer | ok |
| ShiftTradeDown | ok |
| ShiftTradeUp | ok |
| SortTradePlayers | ok |
| TeamRecordSRAM | ok |
| TradeDone | ok |
| TradeExit | ok |
| TradeGfx | ok |
| TradePlayers | ok |
| TradeRatingSteps | ok |
| TradeRatingValues | ok |
| TradeRulesText | ok |
| TradeStatOffsets | ok |
| TradeStatOffsets2 | ok |
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
| AssistText | ok |
| AssistsText | ok |
| BestGoalieSaves | ok |
| BlankLine40 | ok |
| BuildLeaders | ok |
| BuildLeadersDone | ok |
| BuildPlayerLeaders | ok |
| BuildPlayerLeadersDone | ok |
| ClearLeadersArea | ok |
| CompareHighlight | ok |
| CopyTeamLines | ok |
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
| GoalText | ok |
| GoalsText | ok |
| HighlightPlurals | ok |
| HighlightSingulars | ok |
| HighlightsScreen | ok |
| InitSeasonStats | ok |
| LeaderModeText | ok |
| LeaderPrintJumps | ok |
| LeaderTables | ok |
| LeadersField4 | ok |
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
| PrintStatHighlight | ok |
| PrintTeamCategory | ok |
| ReadHighlightsPad | ok |
| ReadLeadersPad | ok |
| ReadSeasonTeamRecord | ok |
| ReadStatBlock | ok |
| ReadTeamPlayerStats | ok |
| SaveGameHighlights | ok |
| SaveSimGame | ok |
| SaveTeamLines | ok |
| SaveText | ok |
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
| DrawGameCursor | ok |
| DrawGameResult | ok |
| DrawGameTeams | ok |
| DrawGameUser | ok |
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
| PrintGameLine | ok |
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
| InvalidNameWait | ok |
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
| SaveNameEnd | ok |
| SaveNameFail | ok |
| SaveNameLoop2 | ok |
| SaveNameNext | ok |
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
