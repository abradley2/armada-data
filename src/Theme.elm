module Theme exposing (Theme, theme)

import Css exposing (Color)


type alias Theme =
    { softWhite : Color
    }


theme : Theme
theme =
    { softWhite = Css.hex "#f5f5f5"
    }
