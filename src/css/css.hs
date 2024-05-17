{-# language OverloadedStrings #-}

import Clay
import Control.Monad  ( forM_ )
import Prelude hiding
 ( span
 , div
 , rem
 )
import qualified Data.Text  as Text
import qualified Clay.Media as Media
import Clay.Flexbox  qualified as Flex

-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
--
-- Helpful things

allMargin n       = margin  n n n n
allPadding n      = padding n n n n
allBorderRadius n = borderRadius n n n n

margin0  = margin  (px 0) (px 0) (px 0) (px 0)
padding0 = padding (px 0) (px 0) (px 0) (px 0)

coreTextFont = fontFamily ["Work Sans"] [sansSerif]
monoFont     = fontFamily ["Fira Code"] [monospace]
titleFont    = fontFamily ["Literata"]  [sansSerif]
menuFont     = coreTextFont

bgColour :: Color
bgColour = "#fffbf0"

selectionColour :: Color
selectionColour = "#eaeaea"

textColour :: Color
textColour = "#383838"

softTextColour :: Color
softTextColour = "#989888"

linkColour :: Color
-- linkColour = "#c832ff"
linkColour = "#9a99dd"

otherStrongColour :: Color
otherStrongColour = "#6232ff"

linkSoftColour :: Color
linkSoftColour = bgColour

commentColour :: Color
commentColour = otherStrongColour

withSmallDisplay = query Clay.all [Media.maxWidth 1200]
withPhoneDisplay = query Clay.all [Media.maxWidth  450]

replaced = "#dd99dc"
removed  = "#dd9a99"
added    = "#99dd9a"

-- ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~


main :: IO ()
main = putCss
  $  basics
  >> fonts
  >> headings
  >> offerings
  >> centralLayout
  >> guides
  >> blog


blog :: Css
blog = do
  div # ".post" |> div # ".top" |> div # ".image" ? do
    height $ px 600

  div # ".image" ? do
    height $ px 400
    backgroundColor bgColour
    backgroundSize cover
    allBorderRadius $ px 20
    "background-position"   -: "center"
    "background-blend-mode" -: "multiply"
    "box-shadow" -: "4.7px 9.3px 9.3px hsl(0deg 0% 0% / 0.15);"

  div # ".content" ? do
    marginTop $ px 20
  --   alignItems center
  --   flexDirection column
  --   div # ".summary" ? do
  --     fontStyle italic
  --     width $ pct 80
      -- backgroundColor ("#eaeaea")
      -- fontSize $ em 1.2

  section # ".posts" ? do
    display flex
    div # ".post" ? do

      display flex
      flexDirection column
      width (px 1000)

      h3 ? do
        a ? do
          fontSize $ em 0.7


guides :: Css
guides = do
  div # ".guides" ? do
    display flex
    flexDirection row
    flexWrap Flex.wrap
    alignItems center
    justifyContent center

    let mkGuide sel c =
          div # sel ? do
            border (px 1) solid (lighten 0.0 c)
            h4 ? (backgroundColor $ lighten 0.74 c)
            div # ".img" ? do
              backgroundColor $ lighten 0.74 c
              span ? background (lighten 0.0 c)
            div # ".link" ? do
              a ? do
                backgroundColor (lighten 0.3 c)
                hover & backgroundColor (lighten 0.6 c)

    mkGuide ".guide.one"   linkColour
    mkGuide ".guide.two"   added
    mkGuide ".guide.three" replaced

    div # ".guide" ? do
      display flex
      flexDirection column
      width  $ px 500
      allMargin $ px 30
      allBorderRadius $ px 20
      "box-shadow" -: "4.7px 9.3px 9.3px hsl(0deg 0% 0% / 0.15);"

      div # ".img" ? do
        borderRadius (px 20) (px 20) 0 0
        marginBottom $ px 0
        paddingTop    $ px 30
        paddingBottom $ px 20
        span ? do
          allMargin $ px 20
          marginBottom $ px 0
          allPadding $ px 10
          allBorderRadius $ px 10

      div ? do
        margin0

      p ? do
        allMargin $ px 20

      h4 ? do
        margin0
        allPadding $ px 10
        titleFont
        fontSize $ em 1.4

      div # ".link" ? do
        marginBottom $ px 20
        display flex
        justifyContent center
        alignItems center
        a ? do
          color black
          allPadding      $ px 10
          allBorderRadius $ px 10


centralLayout :: Css
centralLayout = do
  div # ".links" ? do
    display flex
    flexDirection row
    allMargin $ px 20
    a ? do
      marginLeft  $ px 10
      marginRight $ px 10

  div # ".banner" ? do
    backgroundColor bgColour
    allPadding (px 20)

  footer ? do
    alignItems center
    color softTextColour
    fontSize (em 0.8)

  code ? do
    monoFont
    fontSize (em 0.9)

  pre ? do
    monoFont
    paddingTop $ px 15
    paddingBottom $ px 15
    lineHeight $ px 40
    marginLeft (px 10)
    borderLeft (px 7) solid ("#eaeaea" :: Color)
    backgroundColor ("#fafafa" :: Color)
    paddingLeft $ px 10
    whiteSpace preWrap

    span # ".comment" ? do
      color commentColour


offerings :: Css
offerings = do
  div # ".offerings" ? do
    allMargin (px 30)
    display flex
    flexDirection column
    alignItems center

    withPhoneDisplay $ do
      allMargin (px 10)

    div # ".offering" ? do
      display flex
      flexDirection column
      maxWidth (pct 80)

      query Clay.all [Media.maxWidth 1600] $ do
        flexDirection column
        maxWidth (pct 100)

      justifyContent center

      div # ".product-image" ? do
        display flex
        flexDirection row
        paddingRight (px 20)
        alignItems center
        justifyContent center
        marginBottom (px 20)

        query Clay.all [Media.maxWidth 1400] $ do
          flexDirection column

        img ? do
          backgroundColor bgColour
          allMargin (px 10)
          border (px 1) solid black
          allBorderRadius (px 20)
          "box-shadow" -: "4.7px 9.3px 9.3px hsl(0deg 0% 0% / 0.15);"
          withPhoneDisplay $ do
            width $ px 400

      div # ".content" ? do
        marginLeft (px 20)


headings :: Css
headings = do
  h1 <> h2 <> h3 <> h4 <> h5 ? do
    allMargin (px 0)
    titleFont


  h2 |> span # ".beta" ? do
    allBorderRadius (px 5)
    allMargin (px 8)
    allPadding (px 2)
    background linkColour
    color white
    fontSize (em 0.5)
    monoFont
    paddingLeft (px 5)
    paddingRight (px 5)
    "box-shadow" -: "3.7px 4.3px 4.3px hsl(0deg 0% 0% / 0.15);"

  div # ".title" ? do
    marginBottom $ px 20
    withPhoneDisplay $ do
      fontSize $ em 0.8

    h2 ? do
      fontSize $ em 2.2

    h3 ? do
      fontSize     $ em 1.9
      marginTop    $ px 40
      marginBottom $ px 40
      fontWeight   normal
      border (px 0) solid black
      color linkColour

    h4 ? do
      fontWeight normal
      fontSize $ em 1.4
      lineHeight $ em 1.8
      marginBottom $ px 30


  div # ".top" ? do
    display flex
    flexDirection column

  h4 ? do
    marginTop (px 20)
    coreTextFont

  h3 ? do
    borderBottom (px 1) solid otherStrongColour

  h1 # ".banner" ? do
    fontSize $ em 1.6
    small ? do
      fontSize $ em 0.6
      fontStyle italic
      fontWeight normal
      color softTextColour


basics :: Css
basics = do
  let elts
        =  body
        <> section
        <> footer
        <> nav

  elts ? do
    display flex
    flexDirection column
    margin0
    padding0

  p <> li <> pre ? do
    lineHeight (px 40)

  a ? do
    color black

  a # hover ? do
    fontStyle italic

  let selectionStyle =
        do
          background selectionColour
          color      black

  selection          & selectionStyle
  "::-moz-selection" & selectionStyle


fonts :: Css
fonts = do
  body ? do
    coreTextFont
    fontSize (px 22)
    color textColour

