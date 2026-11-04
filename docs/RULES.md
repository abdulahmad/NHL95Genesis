# Rules (95G)

The rules for this repo's part of the alignment, then the learned rules. Read before every unit. Any tool adds a learned
rule in the same commit as the fix that confirmed it, newest last: `- YYYY-MM-DD <area>: <rule>. (<evidence>)`.

## Who decides what (all games)

| Category | Decided by |
|---|---|
| Name of a routine several games share | the earliest game that has it (92G is the root); a fix goes to the earliest repo first, then down the lineage |
| Name of a feature new in year N | that year's Genesis game (94G for 94S and 94PC, 95G for 95S and 95PC) |
| Name of a platform-only job | the earlier repo on that platform (93S for 94S, 94PC for 95PC), else what the code does |
| Same name, different job | the earlier meaning keeps the name |
| Top folder or file | the same-year Genesis file |
| RAM order | the merged order (92G, 93G, 94G, 93S, 94S, then 95G, 96G) |
| Data, assets, banks | the earlier repo on the same platform |
| Order inside a file | ROM order (the report re-sorts for display) |
| History | `docs/name_map.csv` only, never source comments |

## This repo

- Names: the 94G name when the body is the same routine, then 93G, then 92G. A 95 feature (season, trade, create, awards) takes the name chosen here; 96G, 95S and 95PC copy it.
- Files: one file per subsystem under `engine/` and `front/`, in ROM order. That is 95's own layout; do not reshape it to 94G's files.
- 94G file names: use the current ones (logic94, setup94, middle94, video94...). The old checks94/assign94/input94/data94/attract94/display94 are gone, and the old video94 is now middle94.

## Learned

- 2026-11-04 contributing: CONTRIBUTING.md must not contradict History: lineage lives only in the name history file, never in source comments. (CONTRIBUTING rewrite vs RULES History row)
