Config = {}

Config.Auth = {
    police = {'Priority', 'PeaceTime', 'AOP'},
    ems = {'Priority', 'PeaceTime', 'AOP'},
    moderator = {'Priority', 'PeaceTime', 'AOP'},
    admin = {'Priority', 'PeaceTime', 'AOP'},
    headadmin = {'Priority', 'PeaceTime', 'AOP'},
    owner = {'Priority', 'PeaceTime', 'AOP'},
}

Config.AOP = {
    FlashOnChange = true,
    UseAOP = true,
    AOPFontColor = '<font color="#FFFF00">', --Use any hex color you wish
}

Config.Priority = {
    FlashOnChange = true,
    UsePriority = true,
    SplitCountyandCity = true, --if true, Two different priorities between County and City will be present
    CooldownLength = 2, --in Minutes
    CooldownColor = '<font color="#FFFF00">', --Use any hex color you wish
    InProgressColor = '<font color="#FFFF00">', --Use any hex color you wish
    AvailableColor = '<font color="#FFFF00">', --Use any hex color you wish
    HoldColor = '<font color="#FFFF00">', --Use any hex color you wish
    PendingColor = '<font color="#FFFF00">', --Use any hex color you wish
}


Config.PeaceTime = {
    FlashOnChange = true,
    UsePeaceTime = true,
    TakeDamage = {
        FromEverything = true, --If FromEverything is true, all variables underneath will be ignored
        FromPlayers = false,
        FromVehicles = false,
    },
    PeaceTimeColorEnabled = '<font color="#FFFF00">', --Use any hex color you wish
    PeaceTimeColorDisabled = '<font color="#FFFF00">', --Use any hex color you wish
}

Config.Postals = {
    UsePostals = true,
    PostalColor = '<font color="#FFFF00">' --Use any hex color you wish
}

Config.Location = {
    UseLocation = true,
    UseCardinalDirection= true,
    UseStreetName = true,
    CardinalDirectionColor = '<font color="#FFFF00">', --Use any hex color you wish
    StreeNameColor = '<font color="#FFFF00">' --Use any hex color you wish
}

Config.StartupDefaults = {
    city_priority = 'hold',
    county_priority = 'hold',
    state_priority = 'hold',
    pt_text = 'Disabled',  -- Either Disabled or Enabled
    aop_text = 'Sandy'
}