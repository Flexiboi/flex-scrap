Config = {}
Config.Debug = false

Config.blip = {
    blipname = 'Recyclecentrum',
    sprite = 365,
    color = 2,
    scale = 0.7
}

Config.tp = {
    enter =  {
        [1] = vector3(55.55, 6472.18, 31.43),
        [2] = vector3(-1069.62, -2083.52, 14.38),    
    },
    leave = vector3(1073.0, -3102.49, -39.0)
}

Config.StartJobLocation = vector3(1049.05, -3100.73, -39.0)
Config.DropOffLocation = vector3(1048.12, -3097.02, -39.0)

Config.GrabLocations = {
    vector3(1053.15, -3095.44, -39.0),
    vector3(1055.41, -3095.41, -39.0),
    vector3(1058.03, -3095.23, -39.0),
    vector3(1060.33, -3095.44, -39.0),
    vector3(1062.67, -3095.32, -39.0),
    vector3(1065.24, -3095.3, -39.0),
    vector3(1067.66, -3095.11, -39.0),
    vector3(1067.56, -3102.4, -39.0),
    vector3(1065.19, -3103.1, -39.0),
    vector3(1062.54, -3102.79, -39.0),
    vector3(1060.33, -3102.69, -39.0),
    vector3(1057.83, -3102.73, -39.0),
    vector3(1055.51, -3102.7, -39.0),
    vector3(1053.16, -3102.53, -39.0),
    vector3(1053.14, -3109.97, -39.0),
    vector3(1055.37, -3109.96, -39.0),
    vector3(1057.69, -3110.26, -39.0),
    vector3(1060.47, -3109.65, -39.0),
    vector3(1062.7, -3109.94, -39.0),
    vector3(1065.02, -3110.15, -39.0),
    vector3(1067.45, -3110.01, -39.0)
}

Config.deliverTime = 2 --seconds
Config.rewardAmount = math.random(5,7)
Config.items = {
    [1] = { 
        item = 'iron',
        propname = 'v_serv_metro_metaljunk2',
        itempos = {
            xPos = 0.138000,
            yPos = 0.050000,
            zPos = 0.200000,
            xRot = 90.000000,
            yRot = 0.000000,
            zRot = 0.000000,
        }
    },
    [2] = {
        item = 'steel',
        propname = 'xs_prop_arena_barrel_01a_wl',
        itempos = {
            xPos = 0.138000,
            yPos = 0.450000,
            zPos = 0.200000,
            xRot = 90.000000,
            yRot = 0.000000,
            zRot = 0.000000,
        }
    },
    [3] = {
        item = 'rubber',
        propname = 'v_ind_cm_tyre06',
        itempos = {
            xPos = 0.138000,
            yPos = 0.200000,
            zPos = 0.200000,
            xRot = -50.000000,
            yRot = 290.000000,
            zRot = 0.000000,
        }
    },
    [4] = {
        item = 'metalscrap',
        propname = 'prop_car_door_04',
        itempos = {
            xPos = 0.138000,
            yPos = 0.00000,
            zPos = 0.200000,
            xRot = -50.000000,
            yRot = 290.000000,
            zRot = 0.000000,
        }
    },
    [5] = {
        item = 'plastic',
        propname = 'v_res_smallplasticbox',
        itempos = {
            xPos = 0.138000,
            yPos = 0.00000,
            zPos = 0.200000,
            xRot = -95.000000,
            yRot = 200.000000,
            zRot = -20.000000,
        }
    },
    [6] = {
        item = 'glass',
        propname = 'prop_fncglass_01a',
        itempos = {
            xPos = 0.138000,
            yPos = 0.00000,
            zPos = 0.200000,
            xRot = -120.000000,
            yRot = 115.000000,
            zRot = 0.000000,
        }
    },
    [7] = {
        item = 'aluminum',
        propname = 'prop_car_exhaust_01',
        itempos = {
            xPos = 0.138000,
            yPos = 0.00000,
            zPos = 0.200000,
            xRot = -75.000000,
            yRot = 0.000000,
            zRot = 0.000000,
        }
    },
}

Config.WarehouseProps = {
    [1] = "prop_boxpile_05a",
    [2] = "prop_boxpile_04a",
    [3] = "prop_boxpile_06b",
    [4] = "prop_boxpile_02c",
    [5] = "prop_boxpile_02b",
    [6] = "prop_boxpile_01a",
    [7] = "prop_boxpile_08a",
}

-- Copper cutting
Config.CutItem = 'wirecutter'
Config.copperCuttingModels = {
    'prop_elecbox_09',
    'prop_elecbox_02a',
    'prop_elecbox_01a',
    'prop_elecbox_04a',
    'prop_elecbox_05a',
    'prop_elecbox_09',
    'prop_elecbox_10',
    'prop_elecbox_11',
    'prop_elecbox_13',
    'prop_elecbox_21',
    'prop_elecbox_25'
}
Config.steelCopperTarget = true -- qb target copper stealing
Config.shockChance = 50 -- lower than this to get chocked
Config.stealDamage = 5 -- damage to health from player
Config.cutTime = 10 -- time in seconds to cut
Config.policeAlertChance = 50 --lower than this
Config.LoseCutItemChance = 15 -- Lower to lose item after cut

function policealert()
    exports['ps-dispatch']:SuspiciousActivity()
end

-- GATHERING
Config.GatherReset = 60 --minutes
Config.GatherLocs = {
    [1] = {
        loc = vector4(249.15, -887.91, 29.17, 313.91),
        prop = 'prop_stag_do_rope',
        taken = false,
        reward = 'rope' --ITEM SPAWN NAME
    },
    [2] = {
        loc = vector4(-447.1, -1004.25, 23.21, 117.1),
        prop = 'prop_stag_do_rope',
        taken = false,
        reward = 'rope' --ITEM SPAWN NAME
    },
    [3] = {
        loc = vector4(127.53, 6644.72, 30.81, 251.06),
        prop = 'prop_stag_do_rope',
        taken = false,
        reward = 'rope' --ITEM SPAWN NAME
    },
}