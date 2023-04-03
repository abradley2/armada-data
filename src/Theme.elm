module Theme exposing (darkGray, softWhite, tabletUp, transparent, turquoiseBlue, whiteGlass)

import Css exposing (Color, Style)
import Css.Media as Media


softWhite : Color
softWhite =
    Css.rgb 250 250 250


whiteGlass : Color
whiteGlass =
    Css.rgba 250 250 250 0.125


darkGray : Color
darkGray =
    Css.rgb 50 50 50


turquoiseBlue : Color
turquoiseBlue =
    Css.rgb 0 200 200


transparent : Color
transparent =
    Css.rgba 0 0 0 0


tabletUp : List Style -> Style
tabletUp =
    Media.withMedia
        [ Media.only Media.screen
            [ Media.minWidth (Css.em 30)
            ]
        ]
