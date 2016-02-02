module Handler.HomeSpec (spec) where

import TestImport

spec :: Spec
spec = withApp $ do
    describe "getHomeR" $ do
        it "gives a 200" $ do
            get HomeR
            statusIs 200
            
