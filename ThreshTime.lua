ThreshTime = ThreshTime or {
    config = {
        epochStart = 631170000, -- The start of the game's clock in UNIX time
        start = { date = 1, month = 1, year = 100 }, -- The first game day, arrays are 1-based
        dayLength = 7200, -- The number of UNIX seconds in a game day
        monthLength = 216000,   -- The number of UNIX seconds in a game month
        daysInMonth = 30, -- The number of game days in a game month
        yearLength = 2592000, -- The number of UNIX seconds in a game year
        months = { "Dawn", "Cuspis", "Thawing", "Renasci", "Tempest", "Serenus", "Solaria", "Torrid", "Sojourn", "Hoerfest", "Twilight", "Deepchill" },
        days = { "Vidi", "Aubus", "Tikun", "Coronea", "Dashen", "Merida", "Solus", "Ganymor", "Dianis", "Misma", "Duskus", "Lunas" },
        seasonProgress = { 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0 },
        seasons = { "spring", "summer", "autumn", "winter" },
        monthsInSeasons = { 3, 3, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3 },
        monthsPerSeason = { 3, 3, 3, 3 },
        seasonsProgress = { 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0 },
        devotions = { "Vishnu", "Erosia", "Herastia", "Vivoria", "Tempest", "Silvanus", "Calypso", "Mortis", "Loviatar", "Belphegore", "Bast", "Gethsemane", "Set" },
        voidDevotion = "The Void"
    };
}

function ThreshTime.getTime(current)
    -- The results will be put in this variable to be returned
    local results = {} 
    
    -- Setup the time if not passed
    current = current or os.time()

    -- Remove the starting epoch time from current to get the amount
    -- of time that has passed since the beginning of the game
    current = current - ThreshTime.config.epochStart

    -- Store the current time in another variable for later use
    local now = current 

    -- Determine the current IC year
    results.year = ThreshTime.config.start.year
    while current > ThreshTime.config.yearLength do
        current = current - ThreshTime.config.yearLength
        results.year = results.year + 1
    end

    -- Determine the current month
    results.month = ThreshTime.config.start.month
    while current > ThreshTime.config.monthLength do
      current = current - ThreshTime.config.monthLength
      results.month = results.month + 1
    end

    -- Determine the current month's name
    results.monthName = ThreshTime.config.months[results.month]
    
    -- Determine the current day
    results.day = math.floor(current / ThreshTime.config.dayLength) + 1

    -- Determine the current hour/minute
    current = now
    current = current % ThreshTime.config.dayLength
    current = (current * 86400) / ThreshTime.config.dayLength

    results.hour = math.floor(current / 3600)
    results.minute = math.floor((current - results.hour * 3600) / 60)

    -- Determine the season
    local seasonIndex = ThreshTime.config.monthsInSeasons[results.month]
    results.season = ThreshTime.config.seasons[seasonIndex + 1]

    -- Determine the season stage
    local thisSeasonProgress = ThreshTime.config.seasonsProgress[results.month]
    local curProgress = results.day + ThreshTime.config.daysInMonth * thisSeasonProgress
    local totalDaysInSeason = ThreshTime.config.daysInMonth * 3
    local progress = tonumber(string.format("%.0f", (curProgress / totalDaysInSeason) * 100))
       
    if progress < 10 then results.seasonStage = "start"
    elseif progress < 30 then results.seasonStage = "early"
    elseif progress < 67 then results.seasonStage = "middle"
    elseif progress < 90 then results.seasonStage = "late"
    else results.seasonStage = "end" end

    -- Determine the weekday
    local days = ThreshTime.config.daysInMonth * (results.month - 1) + results.day
    local day = math.floor(days % #ThreshTime.config.days)
    if day == 0 then day = #ThreshTime.config.days end
    results.weekday = ThreshTime.config.days[day]
    
    -- Determine the Devotion
    local devotionCount = #ThreshTime.config.devotions
    local devotionDaysDuration = 24
    local currentDay = ( ( results.month - 1 ) * 30 ) + results.day
    local devotionIndex = math.floor( currentDay / devotionDaysDuration )

    if devotionIndex < devotionCount then results.devotion = ThreshTime.config.devotions[devotionIndex]
    else results.devotion = ThreshTime.config.voidDevotion end
    
    return results
end

function ThreshTime.debug()
    function dump(o)
        if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ', '
        end
        return s .. '} '
        else
        return tostring(o)
        end
    end

    print(dump(ThreshTime.getTime()))
end

ThreshTime.debug()
