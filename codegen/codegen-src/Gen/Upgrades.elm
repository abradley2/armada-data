module Gen.Upgrades exposing (annotation_, make_, moduleName_, upgradeDecoder, values_)

{-| 
@docs values_, make_, annotation_, upgradeDecoder, moduleName_
-}


import Elm
import Elm.Annotation as Type
import Tuple


{-| The name of this module. -}
moduleName_ : List String
moduleName_ =
    [ "Upgrades" ]


{-| upgradeDecoder: Decoder Upgrade -}
upgradeDecoder : Elm.Expression
upgradeDecoder =
    Elm.value
        { importFrom = [ "Upgrades" ]
        , name = "upgradeDecoder"
        , annotation =
            Just
                (Type.namedWith [] "Decoder" [ Type.namedWith [] "Upgrade" [] ])
        }


annotation_ : { upgrade : Type.Annotation }
annotation_ =
    { upgrade =
        Type.alias
            moduleName_
            "Upgrade"
            []
            (Type.record
                [ ( "name", Type.string )
                , ( "unique", Type.bool )
                , ( "text", Type.string )
                , ( "faction"
                  , Type.namedWith [] "Maybe" [ Type.namedWith [] "Faction" [] ]
                  )
                , ( "slots", Type.list (Type.namedWith [] "UpgradeSlot" []) )
                , ( "points", Type.int )
                ]
            )
    }


make_ :
    { upgrade :
        { name : Elm.Expression
        , unique : Elm.Expression
        , text : Elm.Expression
        , faction : Elm.Expression
        , slots : Elm.Expression
        , points : Elm.Expression
        }
        -> Elm.Expression
    }
make_ =
    { upgrade =
        \upgrade_args ->
            Elm.withType
                (Type.alias
                    [ "Upgrades" ]
                    "Upgrade"
                    []
                    (Type.record
                        [ ( "name", Type.string )
                        , ( "unique", Type.bool )
                        , ( "text", Type.string )
                        , ( "faction"
                          , Type.namedWith
                                []
                                "Maybe"
                                [ Type.namedWith [] "Faction" [] ]
                          )
                        , ( "slots"
                          , Type.list (Type.namedWith [] "UpgradeSlot" [])
                          )
                        , ( "points", Type.int )
                        ]
                    )
                )
                (Elm.record
                    [ Tuple.pair "name" upgrade_args.name
                    , Tuple.pair "unique" upgrade_args.unique
                    , Tuple.pair "text" upgrade_args.text
                    , Tuple.pair "faction" upgrade_args.faction
                    , Tuple.pair "slots" upgrade_args.slots
                    , Tuple.pair "points" upgrade_args.points
                    ]
                )
    }


values_ : { upgradeDecoder : Elm.Expression }
values_ =
    { upgradeDecoder =
        Elm.value
            { importFrom = [ "Upgrades" ]
            , name = "upgradeDecoder"
            , annotation =
                Just
                    (Type.namedWith
                        []
                        "Decoder"
                        [ Type.namedWith [] "Upgrade" [] ]
                    )
            }
    }


