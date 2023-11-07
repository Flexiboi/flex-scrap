local Translations = {
    error = {
        offduty = 'Uit dienst gegaan!',
        stoped = 'Gestopped..',
        gooffduty = 'Voor ge verlaat, zet u eerst uit dienst',
        stoppedcutting = 'Gestopt me knippen',
        missingcutitem = 'Je hebt geen tang om te knippen..',
        cutherealready = 'Je hebt hier al geknipt..',
    },
    success = {
        onduty = 'In dienst gegaan!',
        startedjob = 'Nieuwe bestelling binnen gekomen!',
    },
    info = {
        deliver = 'Spul inleveren..'
    },
    text = {
        enterloc = ' om het warenhuis binnen te gaan',
        leaveloc = ' om het warenhuis te verlaten',
        startjob = ' om je job te starten',
        stopjob = ' om je job te stoppen',
        droploc = ' om het af te geven',
        pickuploc = ' om spullen te pakken',
        stealcopper = 'Steel koper',
        cuttinhcopper = 'Koper aan het knippen..',
        gather = 'Raap op',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
