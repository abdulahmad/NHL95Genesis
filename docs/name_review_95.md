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
