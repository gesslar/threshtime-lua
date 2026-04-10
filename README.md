# ThreshTime

A Lua library that provides a fantasy in-game calendar and time system. It converts real-world UNIX timestamps into a fictional calendar with custom months, weekdays, seasons, and a devotion (patron) cycle.

## Features

- **12 named months** (30 days each): Dawn, Cuspis, Thawing, Renasci, Tempest, Serenus, Solaria, Torrid, Sojourn, Hoerfest, Twilight, Deepchill
- **12-day weeks**: Vidi, Aubus, Tikun, Coronea, Dashen, Merida, Solus, Ganymor, Dianis, Misma, Duskus, Lunas
- **4 seasons** with progress stages (start, early, middle, late, end)
- **13 devotion patrons** rotating every 24 game days, plus "The Void"
- **Hour and minute** tracking within each game day

## Time Scale

| Real Time | Game Time |
| --------- | --------- |
| 2 hours | 1 day |
| 60 hours | 1 month |
| 30 days | 1 year |

## Installation

Copy `ThreshTime.lua` into your project. No external dependencies are required.

## Usage

```lua
-- Load the module
dofile("ThreshTime.lua")

-- Get the current game time
local time = ThreshTime.getTime()

-- Or pass a specific UNIX timestamp
local time = ThreshTime.getTime(1700000000)

-- Access the results
print(time.year)        -- e.g. 544
print(time.month)       -- e.g. 7
print(time.monthName)   -- e.g. "Solaria"
print(time.day)         -- e.g. 15
print(time.hour)        -- e.g. 14
print(time.minute)      -- e.g. 30
print(time.season)      -- e.g. "summer"
print(time.seasonStage) -- e.g. "middle"
print(time.weekday)     -- e.g. "Coronea"
print(time.devotion)    -- e.g. "Calypso"
```

## API

### `ThreshTime.getTime([current])`

Converts a UNIX timestamp to game time.

**Parameters:**

- `current` (number, optional) - A UNIX timestamp. Defaults to `os.time()`.

**Returns:** A table with the following fields:

| Field | Type | Description |
| ----- | ---- | ----------- |
| `year` | number | The in-game year |
| `month` | number | Month number (1-12) |
| `monthName` | string | Name of the current month |
| `day` | number | Day of the month (1-30) |
| `hour` | number | Hour of the day (0-23) |
| `minute` | number | Minute of the hour (0-59) |
| `season` | string | Current season (spring, summer, autumn, winter) |
| `seasonStage` | string | Progress within the season (start, early, middle, late, end) |
| `weekday` | string | Name of the day in the 12-day week |
| `devotion` | string | Current devotion patron |

### `ThreshTime.debug()`

Prints the current game time to stdout for debugging.

### `ThreshTime.config`

A table containing all calendar configuration values (epoch, month names, day names, season mappings, etc.). Can be modified before calling `getTime()` to customize the calendar system.

## License

[0BSD](LICENSE.txt)
