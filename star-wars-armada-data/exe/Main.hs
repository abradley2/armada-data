{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Aeson ((.=))
import Data.Aeson qualified as Aeson
import Relude
import System.FilePath.Glob qualified as Glob


slurpDir :: FilePath -> ExceptT String IO [Aeson.Value]
slurpDir dir = ExceptT $ fmap join . mapM decode <$> getFiles
  where
    decode :: LByteString -> Either String [Aeson.Value]
    decode = Aeson.eitherDecode

    getFiles :: IO [LByteString]
    getFiles = Glob.globDir [Glob.compile "**/*.json"] dir >>= mapM readFileLBS . join

main :: IO ()
main =
    runExceptT
        ( do
            ships <- slurpDir "data/ship-card"
            upgrades <- slurpDir "data/upgrade-card"
            writeFileLBS "ship-cards.json" . Aeson.encode $ Aeson.object ["ships" .= ships] 
            writeFileLBS "upgrade-cards.json" . Aeson.encode $ Aeson.object ["upgrades" .= upgrades] 
            pure ()
        )
        >>= either
            putStrLn
            (const $ putStrLn "Success!")
