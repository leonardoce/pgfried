module Main where

import Control.Concurrent
import Control.Exception
import Database.PostgreSQL.Simple qualified as D

{- |
 Main entry point.

 `just run` will invoke this function.
-}
main :: IO ()
main = do
  -- For withUtf8, see https://serokell.io/blog/haskell-with-utf8
  connectionCycle

connectionTest :: IO ()
connectionTest = do
  putStrLn "Creating a connection to PG"
  _ <- D.connectPostgreSQL "connect_timeout=2"
  putStrLn "Waiting for a bit"
  threadDelay 1000000

connectionCycle :: IO ()
connectionCycle = do
  result <- try connectionTest
  case result of
    Left (err :: SomeException) -> do
      putStrLn $ "error " ++ show err
      threadDelay 1000000
    Right _ -> putStrLn "Everything fine"
  connectionCycle
