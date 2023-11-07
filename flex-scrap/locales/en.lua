local Translations = {
    error = {
        offduty = 'Off duty!',
        stoped = 'Stopped..',
        gooffduty = 'Go off duty before you leave..',
        stoppedcutting = 'Stopped cutting',
        missingcutitem = 'You need something to cut with..',
        cutherealready = 'You already cut something here..',
    },
    success = {
        onduty = 'Went on duty!',
        startedjob = 'You got a new order!',
    },
    info = {
        deliver = 'Deliver stuff..'
    },
    text = {
        enterloc = ' to enter warehouse',
        leaveloc = ' to leave warehouse',
        startjob = ' to start working',
        stopjob = ' to stop working',
        droploc = ' to deliver',
        pickuploc = ' to grab stuff',
        stealcopper = 'Steal copper',
        cuttinhcopper = 'Cutting Copper..',
        gather = 'Take',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
