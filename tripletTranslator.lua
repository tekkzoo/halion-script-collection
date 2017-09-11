--this is using the same technique as the sample selector, 
--taken from an example at developer.steinberg.help, but for setting combinations of parameters.

--usage: connect the syncVDropdown parameter to a menu on a macropage.

syncTimeTable = {
    { timeValue = "1/256", time = 9, triplets = 0 },
    { timeValue = "1/256T", time = 9, triplets = 1 },
    { timeValue = "1/128", time = 8, triplets = 0 },
    { timeValue = "1/128T", time = 8, triplets = 1 },
    { timeValue = "1/64", time = 7, triplets = 0 },
    { timeValue = "1/64T", time = 7, triplets = 1 },
    { timeValue = "1/32", time = 6, triplets = 0 },
    { timeValue = "1/32T", time = 6, triplets = 1 },
    { timeValue = "1/16", time = 5, triplets = 0 },
    { timeValue = "1/16T", time = 5, triplets = 1 },
    { timeValue = "1/8", time = 4, triplets = 0 },
    { timeValue = "1/8T", time = 4, triplets = 1 },
    { timeValue = "1/4", time = 3, triplets = 0 },
    { timeValue = "1/4T", time = 3, triplets = 1 },
    { timeValue = "1/2", time = 2, triplets = 0 },
    { timeValue = "1/2T", time = 2, triplets = 1 },
    { timeValue = "1/1", time = 1, triplets = 0 },
    { timeValue = "1/1T", time = 1, triplets = 1 },
    { timeValue = "Off", time = 0, triplets = 0 },
}

-- create table with the drop down values
function getTimeValues()
  selectedValue = {}
  for i, list in ipairs(syncTimeTable) do
    selectedValue[i] = list.timeValue
    print(list.timeValue)
  end
end

getTimeValues()

giveTheDogAZone = this.parent:getZone("TheZone")
print(giveTheDogAZone.name)

defineParameter("syncVDropdown", "Time", 1, selectedValue, function() setSyncTime(syncTimeTable[syncVDropdown], giveTheDogAZone) end)

function setSyncTime(syncTimeValue, aZone)
    print("syncTimeValue is: "..syncTimeValue.timeValue)
    print(aZone.name)
    aZone:setParameterNormalized("VoiceControl.GlideSyncT", syncTimeValue.triplets)
    aZone:setParameter("VoiceControl.GlideSyncV", syncTimeValue.time)
end
