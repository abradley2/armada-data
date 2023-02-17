module Gen.ShipData exposing (annotation_, attackDecoder, attackProfileDecoder, call_, caseOf_, defenseTokenDecoder, factionDecoder, make_, moduleName_, shieldDecoder, shipDataDecoder, sizeDecoder, speedChartDecoder, tokenDecoder, upgradeSlotDecoder, values_, yawDecoder)

{-| 
@docs values_, call_, caseOf_, make_, annotation_, sizeDecoder, factionDecoder, attackProfileDecoder, attackDecoder, shieldDecoder, defenseTokenDecoder, yawDecoder, speedChartDecoder, upgradeSlotDecoder, shipDataDecoder, tokenDecoder, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Elm.Case
import Tuple


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "ShipData" ]


{-| tokenDecoder: String -> a -> Decoder a -}
tokenDecoder : String -> Elm.Expression -> Elm.Expression
tokenDecoder tokenDecoderArg tokenDecoderArg0 =
    Elm.apply
        (Elm.value
            { importFrom = [ "ShipData" ]
            , name = "tokenDecoder"
            , annotation =
                Just
                    (Type.function
                        [ Type.string, Type.var "a" ]
                        (Type.namedWith [] "Decoder" [ Type.var "a" ])
                    )
            }
        )
        [ Elm.string tokenDecoderArg, tokenDecoderArg0 ]


{-| shipDataDecoder: Decoder ShipData -}
shipDataDecoder : Elm.Expression
shipDataDecoder =
    Elm.value
        { importFrom = [ "ShipData" ]
        , name = "shipDataDecoder"
        , annotation =
            Just
                (Type.namedWith [] "Decoder" [ Type.namedWith [] "ShipData" [] ]
                )
        }


{-| upgradeSlotDecoder: Decoder UpgradeSlot -}
upgradeSlotDecoder : Elm.Expression
upgradeSlotDecoder =
    Elm.value
        { importFrom = [ "ShipData" ]
        , name = "upgradeSlotDecoder"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Decoder"
                    [ Type.namedWith [] "UpgradeSlot" [] ]
                )
        }


{-| speedChartDecoder: Decoder SpeedChart -}
speedChartDecoder : Elm.Expression
speedChartDecoder =
    Elm.value
        { importFrom = [ "ShipData" ]
        , name = "speedChartDecoder"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Decoder"
                    [ Type.namedWith [] "SpeedChart" [] ]
                )
        }


{-| yawDecoder: Decoder Yaw -}
yawDecoder : Elm.Expression
yawDecoder =
    Elm.value
        { importFrom = [ "ShipData" ]
        , name = "yawDecoder"
        , annotation =
            Just (Type.namedWith [] "Decoder" [ Type.namedWith [] "Yaw" [] ])
        }


{-| defenseTokenDecoder: Decoder DefenseToken -}
defenseTokenDecoder : Elm.Expression
defenseTokenDecoder =
    Elm.value
        { importFrom = [ "ShipData" ]
        , name = "defenseTokenDecoder"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Decoder"
                    [ Type.namedWith [] "DefenseToken" [] ]
                )
        }


{-| shieldDecoder: Decoder Shield -}
shieldDecoder : Elm.Expression
shieldDecoder =
    Elm.value
        { importFrom = [ "ShipData" ]
        , name = "shieldDecoder"
        , annotation =
            Just (Type.namedWith [] "Decoder" [ Type.namedWith [] "Shield" [] ])
        }


{-| attackDecoder: Decoder Attack -}
attackDecoder : Elm.Expression
attackDecoder =
    Elm.value
        { importFrom = [ "ShipData" ]
        , name = "attackDecoder"
        , annotation =
            Just (Type.namedWith [] "Decoder" [ Type.namedWith [] "Attack" [] ])
        }


{-| attackProfileDecoder: Decoder AttackProfile -}
attackProfileDecoder : Elm.Expression
attackProfileDecoder =
    Elm.value
        { importFrom = [ "ShipData" ]
        , name = "attackProfileDecoder"
        , annotation =
            Just
                (Type.namedWith
                    []
                    "Decoder"
                    [ Type.namedWith [] "AttackProfile" [] ]
                )
        }


{-| factionDecoder: Decoder Faction -}
factionDecoder : Elm.Expression
factionDecoder =
    Elm.value
        { importFrom = [ "ShipData" ]
        , name = "factionDecoder"
        , annotation =
            Just
                (Type.namedWith [] "Decoder" [ Type.namedWith [] "Faction" [] ])
        }


{-| sizeDecoder: Decoder Size -}
sizeDecoder : Elm.Expression
sizeDecoder =
    Elm.value
        { importFrom = [ "ShipData" ]
        , name = "sizeDecoder"
        , annotation =
            Just (Type.namedWith [] "Decoder" [ Type.namedWith [] "Size" [] ])
        }


annotation_ :
    { shipData : Type.Annotation
    , speedChart : Type.Annotation
    , shield : Type.Annotation
    , attack : Type.Annotation
    , attackProfile : Type.Annotation
    , upgradeSlot : Type.Annotation
    , yaw : Type.Annotation
    , defenseToken : Type.Annotation
    , faction : Type.Annotation
    , size : Type.Annotation
    }
annotation_ =
    { shipData =
        Type.alias
            moduleName_
            "ShipData"
            []
            (Type.record
                [ ( "name", Type.string )
                , ( "size", Type.namedWith [] "Size" [] )
                , ( "faction", Type.namedWith [] "Faction" [] )
                , ( "hull", Type.int )
                , ( "squadronAttack", Type.namedWith [] "AttackProfile" [] )
                , ( "command", Type.int )
                , ( "squadron", Type.int )
                , ( "engineering", Type.int )
                , ( "attack", Type.namedWith [] "Attack" [] )
                , ( "shield", Type.namedWith [] "Shield" [] )
                , ( "defenseTokens"
                  , Type.list (Type.namedWith [] "DefenseToken" [])
                  )
                , ( "speedChart", Type.namedWith [] "SpeedChart" [] )
                , ( "slots", Type.list (Type.namedWith [] "UpgradeSlot" []) )
                , ( "points", Type.int )
                , ( "shipImage", Type.namedWith [] "Maybe" [ Type.string ] )
                , ( "image", Type.namedWith [] "Maybe" [ Type.string ] )
                ]
            )
    , speedChart =
        Type.alias
            moduleName_
            "SpeedChart"
            []
            (Type.record
                [ ( "one", Type.list (Type.namedWith [] "Yaw" []) )
                , ( "two"
                  , Type.namedWith
                        []
                        "Maybe"
                        [ Type.list (Type.namedWith [] "Yaw" []) ]
                  )
                , ( "three"
                  , Type.namedWith
                        []
                        "Maybe"
                        [ Type.list (Type.namedWith [] "Yaw" []) ]
                  )
                , ( "four"
                  , Type.namedWith
                        []
                        "Maybe"
                        [ Type.list (Type.namedWith [] "Yaw" []) ]
                  )
                ]
            )
    , shield =
        Type.alias
            moduleName_
            "Shield"
            []
            (Type.record
                [ ( "front", Type.int )
                , ( "right", Type.int )
                , ( "left", Type.int )
                , ( "rear", Type.int )
                ]
            )
    , attack =
        Type.alias
            moduleName_
            "Attack"
            []
            (Type.record
                [ ( "front", Type.namedWith [] "AttackProfile" [] )
                , ( "right", Type.namedWith [] "AttackProfile" [] )
                , ( "left", Type.namedWith [] "AttackProfile" [] )
                , ( "rear", Type.namedWith [] "AttackProfile" [] )
                ]
            )
    , attackProfile =
        Type.alias
            moduleName_
            "AttackProfile"
            []
            (Type.record
                [ ( "red", Type.int )
                , ( "blue", Type.int )
                , ( "black", Type.int )
                ]
            )
    , upgradeSlot = Type.namedWith [ "ShipData" ] "UpgradeSlot" []
    , yaw = Type.namedWith [ "ShipData" ] "Yaw" []
    , defenseToken = Type.namedWith [ "ShipData" ] "DefenseToken" []
    , faction = Type.namedWith [ "ShipData" ] "Faction" []
    , size = Type.namedWith [ "ShipData" ] "Size" []
    }


make_ :
    { shipData :
        { name : Elm.Expression
        , size : Elm.Expression
        , faction : Elm.Expression
        , hull : Elm.Expression
        , squadronAttack : Elm.Expression
        , command : Elm.Expression
        , squadron : Elm.Expression
        , engineering : Elm.Expression
        , attack : Elm.Expression
        , shield : Elm.Expression
        , defenseTokens : Elm.Expression
        , speedChart : Elm.Expression
        , slots : Elm.Expression
        , points : Elm.Expression
        , shipImage : Elm.Expression
        , image : Elm.Expression
        }
        -> Elm.Expression
    , speedChart :
        { one : Elm.Expression
        , two : Elm.Expression
        , three : Elm.Expression
        , four : Elm.Expression
        }
        -> Elm.Expression
    , shield :
        { front : Elm.Expression
        , right : Elm.Expression
        , left : Elm.Expression
        , rear : Elm.Expression
        }
        -> Elm.Expression
    , attack :
        { front : Elm.Expression
        , right : Elm.Expression
        , left : Elm.Expression
        , rear : Elm.Expression
        }
        -> Elm.Expression
    , attackProfile :
        { red : Elm.Expression, blue : Elm.Expression, black : Elm.Expression }
        -> Elm.Expression
    , officer : Elm.Expression
    , supportTeam : Elm.Expression
    , defensiveRetrofit : Elm.Expression
    , offensiveRetrofit : Elm.Expression
    , turbolasers : Elm.Expression
    , ordnance : Elm.Expression
    , fleetCommand : Elm.Expression
    , weaponsTeam : Elm.Expression
    , ionCannons : Elm.Expression
    , fleetSupport : Elm.Expression
    , experimentalRetrofit : Elm.Expression
    , superweapon : Elm.Expression
    , yawZero : Elm.Expression
    , yawOne : Elm.Expression
    , yawTwo : Elm.Expression
    , evade : Elm.Expression
    , redirect : Elm.Expression
    , contain : Elm.Expression
    , brace : Elm.Expression
    , scatter : Elm.Expression
    , salvo : Elm.Expression
    , galacticEmpire : Elm.Expression
    , rebelAlliance : Elm.Expression
    , small : Elm.Expression
    , medium : Elm.Expression
    , large : Elm.Expression
    , huge : Elm.Expression
    }
make_ =
    { shipData =
        \shipData_args ->
            Elm.withType
                (Type.alias
                    [ "ShipData" ]
                    "ShipData"
                    []
                    (Type.record
                        [ ( "name", Type.string )
                        , ( "size", Type.namedWith [] "Size" [] )
                        , ( "faction", Type.namedWith [] "Faction" [] )
                        , ( "hull", Type.int )
                        , ( "squadronAttack"
                          , Type.namedWith [] "AttackProfile" []
                          )
                        , ( "command", Type.int )
                        , ( "squadron", Type.int )
                        , ( "engineering", Type.int )
                        , ( "attack", Type.namedWith [] "Attack" [] )
                        , ( "shield", Type.namedWith [] "Shield" [] )
                        , ( "defenseTokens"
                          , Type.list (Type.namedWith [] "DefenseToken" [])
                          )
                        , ( "speedChart", Type.namedWith [] "SpeedChart" [] )
                        , ( "slots"
                          , Type.list (Type.namedWith [] "UpgradeSlot" [])
                          )
                        , ( "points", Type.int )
                        , ( "shipImage"
                          , Type.namedWith [] "Maybe" [ Type.string ]
                          )
                        , ( "image", Type.namedWith [] "Maybe" [ Type.string ] )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "name" shipData_args.name
                    , Tuple.pair "size" shipData_args.size
                    , Tuple.pair "faction" shipData_args.faction
                    , Tuple.pair "hull" shipData_args.hull
                    , Tuple.pair "squadronAttack" shipData_args.squadronAttack
                    , Tuple.pair "command" shipData_args.command
                    , Tuple.pair "squadron" shipData_args.squadron
                    , Tuple.pair "engineering" shipData_args.engineering
                    , Tuple.pair "attack" shipData_args.attack
                    , Tuple.pair "shield" shipData_args.shield
                    , Tuple.pair "defenseTokens" shipData_args.defenseTokens
                    , Tuple.pair "speedChart" shipData_args.speedChart
                    , Tuple.pair "slots" shipData_args.slots
                    , Tuple.pair "points" shipData_args.points
                    , Tuple.pair "shipImage" shipData_args.shipImage
                    , Tuple.pair "image" shipData_args.image
                    ]
                )
    , speedChart =
        \speedChart_args ->
            Elm.withType
                (Type.alias
                    [ "ShipData" ]
                    "SpeedChart"
                    []
                    (Type.record
                        [ ( "one", Type.list (Type.namedWith [] "Yaw" []) )
                        , ( "two"
                          , Type.namedWith
                                []
                                "Maybe"
                                [ Type.list (Type.namedWith [] "Yaw" []) ]
                          )
                        , ( "three"
                          , Type.namedWith
                                []
                                "Maybe"
                                [ Type.list (Type.namedWith [] "Yaw" []) ]
                          )
                        , ( "four"
                          , Type.namedWith
                                []
                                "Maybe"
                                [ Type.list (Type.namedWith [] "Yaw" []) ]
                          )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "one" speedChart_args.one
                    , Tuple.pair "two" speedChart_args.two
                    , Tuple.pair "three" speedChart_args.three
                    , Tuple.pair "four" speedChart_args.four
                    ]
                )
    , shield =
        \shield_args ->
            Elm.withType
                (Type.alias
                    [ "ShipData" ]
                    "Shield"
                    []
                    (Type.record
                        [ ( "front", Type.int )
                        , ( "right", Type.int )
                        , ( "left", Type.int )
                        , ( "rear", Type.int )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "front" shield_args.front
                    , Tuple.pair "right" shield_args.right
                    , Tuple.pair "left" shield_args.left
                    , Tuple.pair "rear" shield_args.rear
                    ]
                )
    , attack =
        \attack_args ->
            Elm.withType
                (Type.alias
                    [ "ShipData" ]
                    "Attack"
                    []
                    (Type.record
                        [ ( "front", Type.namedWith [] "AttackProfile" [] )
                        , ( "right", Type.namedWith [] "AttackProfile" [] )
                        , ( "left", Type.namedWith [] "AttackProfile" [] )
                        , ( "rear", Type.namedWith [] "AttackProfile" [] )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "front" attack_args.front
                    , Tuple.pair "right" attack_args.right
                    , Tuple.pair "left" attack_args.left
                    , Tuple.pair "rear" attack_args.rear
                    ]
                )
    , attackProfile =
        \attackProfile_args ->
            Elm.withType
                (Type.alias
                    [ "ShipData" ]
                    "AttackProfile"
                    []
                    (Type.record
                        [ ( "red", Type.int )
                        , ( "blue", Type.int )
                        , ( "black", Type.int )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "red" attackProfile_args.red
                    , Tuple.pair "blue" attackProfile_args.blue
                    , Tuple.pair "black" attackProfile_args.black
                    ]
                )
    , officer =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "Officer"
            , annotation = Just (Type.namedWith [] "UpgradeSlot" [])
            }
    , supportTeam =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "SupportTeam"
            , annotation = Just (Type.namedWith [] "UpgradeSlot" [])
            }
    , defensiveRetrofit =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "DefensiveRetrofit"
            , annotation = Just (Type.namedWith [] "UpgradeSlot" [])
            }
    , offensiveRetrofit =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "OffensiveRetrofit"
            , annotation = Just (Type.namedWith [] "UpgradeSlot" [])
            }
    , turbolasers =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "Turbolasers"
            , annotation = Just (Type.namedWith [] "UpgradeSlot" [])
            }
    , ordnance =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "Ordnance"
            , annotation = Just (Type.namedWith [] "UpgradeSlot" [])
            }
    , fleetCommand =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "FleetCommand"
            , annotation = Just (Type.namedWith [] "UpgradeSlot" [])
            }
    , weaponsTeam =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "WeaponsTeam"
            , annotation = Just (Type.namedWith [] "UpgradeSlot" [])
            }
    , ionCannons =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "IonCannons"
            , annotation = Just (Type.namedWith [] "UpgradeSlot" [])
            }
    , fleetSupport =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "FleetSupport"
            , annotation = Just (Type.namedWith [] "UpgradeSlot" [])
            }
    , experimentalRetrofit =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "ExperimentalRetrofit"
            , annotation = Just (Type.namedWith [] "UpgradeSlot" [])
            }
    , superweapon =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "Superweapon"
            , annotation = Just (Type.namedWith [] "UpgradeSlot" [])
            }
    , yawZero =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "YawZero"
            , annotation = Just (Type.namedWith [] "Yaw" [])
            }
    , yawOne =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "YawOne"
            , annotation = Just (Type.namedWith [] "Yaw" [])
            }
    , yawTwo =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "YawTwo"
            , annotation = Just (Type.namedWith [] "Yaw" [])
            }
    , evade =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "Evade"
            , annotation = Just (Type.namedWith [] "DefenseToken" [])
            }
    , redirect =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "Redirect"
            , annotation = Just (Type.namedWith [] "DefenseToken" [])
            }
    , contain =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "Contain"
            , annotation = Just (Type.namedWith [] "DefenseToken" [])
            }
    , brace =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "Brace"
            , annotation = Just (Type.namedWith [] "DefenseToken" [])
            }
    , scatter =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "Scatter"
            , annotation = Just (Type.namedWith [] "DefenseToken" [])
            }
    , salvo =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "Salvo"
            , annotation = Just (Type.namedWith [] "DefenseToken" [])
            }
    , galacticEmpire =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "GalacticEmpire"
            , annotation = Just (Type.namedWith [] "Faction" [])
            }
    , rebelAlliance =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "RebelAlliance"
            , annotation = Just (Type.namedWith [] "Faction" [])
            }
    , small =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "Small"
            , annotation = Just (Type.namedWith [] "Size" [])
            }
    , medium =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "Medium"
            , annotation = Just (Type.namedWith [] "Size" [])
            }
    , large =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "Large"
            , annotation = Just (Type.namedWith [] "Size" [])
            }
    , huge =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "Huge"
            , annotation = Just (Type.namedWith [] "Size" [])
            }
    }


caseOf_ :
    { upgradeSlot :
        Elm.Expression
        -> { upgradeSlotTags_0_0
            | officer : Elm.Expression
            , supportTeam : Elm.Expression
            , defensiveRetrofit : Elm.Expression
            , offensiveRetrofit : Elm.Expression
            , turbolasers : Elm.Expression
            , ordnance : Elm.Expression
            , fleetCommand : Elm.Expression
            , weaponsTeam : Elm.Expression
            , ionCannons : Elm.Expression
            , fleetSupport : Elm.Expression
            , experimentalRetrofit : Elm.Expression
            , superweapon : Elm.Expression
        }
        -> Elm.Expression
    , yaw :
        Elm.Expression
        -> { yawTags_1_0
            | yawZero : Elm.Expression
            , yawOne : Elm.Expression
            , yawTwo : Elm.Expression
        }
        -> Elm.Expression
    , defenseToken :
        Elm.Expression
        -> { defenseTokenTags_2_0
            | evade : Elm.Expression
            , redirect : Elm.Expression
            , contain : Elm.Expression
            , brace : Elm.Expression
            , scatter : Elm.Expression
            , salvo : Elm.Expression
        }
        -> Elm.Expression
    , faction :
        Elm.Expression
        -> { factionTags_3_0
            | galacticEmpire : Elm.Expression
            , rebelAlliance : Elm.Expression
        }
        -> Elm.Expression
    , size :
        Elm.Expression
        -> { sizeTags_4_0
            | small : Elm.Expression
            , medium : Elm.Expression
            , large : Elm.Expression
            , huge : Elm.Expression
        }
        -> Elm.Expression
    }
caseOf_ =
    { upgradeSlot =
        \upgradeSlotExpression upgradeSlotTags ->
            Elm.Case.custom
                upgradeSlotExpression
                (Type.namedWith [ "ShipData" ] "UpgradeSlot" [])
                [ Elm.Case.branch0 "Officer" upgradeSlotTags.officer
                , Elm.Case.branch0 "SupportTeam" upgradeSlotTags.supportTeam
                , Elm.Case.branch0
                    "DefensiveRetrofit"
                    upgradeSlotTags.defensiveRetrofit
                , Elm.Case.branch0
                    "OffensiveRetrofit"
                    upgradeSlotTags.offensiveRetrofit
                , Elm.Case.branch0 "Turbolasers" upgradeSlotTags.turbolasers
                , Elm.Case.branch0 "Ordnance" upgradeSlotTags.ordnance
                , Elm.Case.branch0 "FleetCommand" upgradeSlotTags.fleetCommand
                , Elm.Case.branch0 "WeaponsTeam" upgradeSlotTags.weaponsTeam
                , Elm.Case.branch0 "IonCannons" upgradeSlotTags.ionCannons
                , Elm.Case.branch0 "FleetSupport" upgradeSlotTags.fleetSupport
                , Elm.Case.branch0
                    "ExperimentalRetrofit"
                    upgradeSlotTags.experimentalRetrofit
                , Elm.Case.branch0 "Superweapon" upgradeSlotTags.superweapon
                ]
    , yaw =
        \yawExpression yawTags ->
            Elm.Case.custom
                yawExpression
                (Type.namedWith [ "ShipData" ] "Yaw" [])
                [ Elm.Case.branch0 "YawZero" yawTags.yawZero
                , Elm.Case.branch0 "YawOne" yawTags.yawOne
                , Elm.Case.branch0 "YawTwo" yawTags.yawTwo
                ]
    , defenseToken =
        \defenseTokenExpression defenseTokenTags ->
            Elm.Case.custom
                defenseTokenExpression
                (Type.namedWith [ "ShipData" ] "DefenseToken" [])
                [ Elm.Case.branch0 "Evade" defenseTokenTags.evade
                , Elm.Case.branch0 "Redirect" defenseTokenTags.redirect
                , Elm.Case.branch0 "Contain" defenseTokenTags.contain
                , Elm.Case.branch0 "Brace" defenseTokenTags.brace
                , Elm.Case.branch0 "Scatter" defenseTokenTags.scatter
                , Elm.Case.branch0 "Salvo" defenseTokenTags.salvo
                ]
    , faction =
        \factionExpression factionTags ->
            Elm.Case.custom
                factionExpression
                (Type.namedWith [ "ShipData" ] "Faction" [])
                [ Elm.Case.branch0 "GalacticEmpire" factionTags.galacticEmpire
                , Elm.Case.branch0 "RebelAlliance" factionTags.rebelAlliance
                ]
    , size =
        \sizeExpression sizeTags ->
            Elm.Case.custom
                sizeExpression
                (Type.namedWith [ "ShipData" ] "Size" [])
                [ Elm.Case.branch0 "Small" sizeTags.small
                , Elm.Case.branch0 "Medium" sizeTags.medium
                , Elm.Case.branch0 "Large" sizeTags.large
                , Elm.Case.branch0 "Huge" sizeTags.huge
                ]
    }


call_ : { tokenDecoder : Elm.Expression -> Elm.Expression -> Elm.Expression }
call_ =
    { tokenDecoder =
        \tokenDecoderArg tokenDecoderArg0 ->
            Elm.apply
                (Elm.value
                    { importFrom = [ "ShipData" ]
                    , name = "tokenDecoder"
                    , annotation =
                        Just
                            (Type.function
                                [ Type.string, Type.var "a" ]
                                (Type.namedWith [] "Decoder" [ Type.var "a" ])
                            )
                    }
                )
                [ tokenDecoderArg, tokenDecoderArg0 ]
    }


values_ :
    { tokenDecoder : Elm.Expression
    , shipDataDecoder : Elm.Expression
    , upgradeSlotDecoder : Elm.Expression
    , speedChartDecoder : Elm.Expression
    , yawDecoder : Elm.Expression
    , defenseTokenDecoder : Elm.Expression
    , shieldDecoder : Elm.Expression
    , attackDecoder : Elm.Expression
    , attackProfileDecoder : Elm.Expression
    , factionDecoder : Elm.Expression
    , sizeDecoder : Elm.Expression
    }
values_ =
    { tokenDecoder =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "tokenDecoder"
            , annotation =
                Just
                    (Type.function
                        [ Type.string, Type.var "a" ]
                        (Type.namedWith [] "Decoder" [ Type.var "a" ])
                    )
            }
    , shipDataDecoder =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "shipDataDecoder"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Decoder"
                        [ Type.namedWith [] "ShipData" [] ]
                    )
            }
    , upgradeSlotDecoder =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "upgradeSlotDecoder"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Decoder"
                        [ Type.namedWith [] "UpgradeSlot" [] ]
                    )
            }
    , speedChartDecoder =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "speedChartDecoder"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Decoder"
                        [ Type.namedWith [] "SpeedChart" [] ]
                    )
            }
    , yawDecoder =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "yawDecoder"
            , annotation =
                Just
                    (Type.namedWith [] "Decoder" [ Type.namedWith [] "Yaw" [] ])
            }
    , defenseTokenDecoder =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "defenseTokenDecoder"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Decoder"
                        [ Type.namedWith [] "DefenseToken" [] ]
                    )
            }
    , shieldDecoder =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "shieldDecoder"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Decoder"
                        [ Type.namedWith [] "Shield" [] ]
                    )
            }
    , attackDecoder =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "attackDecoder"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Decoder"
                        [ Type.namedWith [] "Attack" [] ]
                    )
            }
    , attackProfileDecoder =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "attackProfileDecoder"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Decoder"
                        [ Type.namedWith [] "AttackProfile" [] ]
                    )
            }
    , factionDecoder =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "factionDecoder"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Decoder"
                        [ Type.namedWith [] "Faction" [] ]
                    )
            }
    , sizeDecoder =
        Elm.value
            { importFrom = [ "ShipData" ]
            , name = "sizeDecoder"
            , annotation =
                Just
                    (Type.namedWith [] "Decoder" [ Type.namedWith [] "Size" [] ]
                    )
            }
    }


