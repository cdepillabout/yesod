{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE CPP #-}
{-# LANGUAGE OverloadedStrings #-}
-- | Provides a dummy authentication module that simply lets a user specify
-- his/her identifier. This is not intended for real world use, just for
-- testing.
module Yesod.Helpers.Auth.Dummy
    ( authDummy
    ) where

import Yesod.Helpers.Auth
import Yesod.Form (runFormPost', stringInput)
import Yesod.Handler (notFound)
import Text.Hamlet (hamlet)

authDummy :: YesodAuth m => AuthPlugin m
authDummy =
    AuthPlugin "dummy" dispatch login
  where
    dispatch "POST" [] = do
        ident <- runFormPost' $ stringInput "ident"
        setCreds True $ Creds "dummy" ident []
    dispatch _ _ = notFound
    url = PluginR "dummy" []
    login authToMaster =
#if GHC7
        [hamlet|
#else
        [$hamlet|
#endif
<form method="post" action="@{authToMaster url}">
    \Your new identifier is: 
    <input type="text" name="ident">
    <input type="submit" value="Dummy Login">
|]
