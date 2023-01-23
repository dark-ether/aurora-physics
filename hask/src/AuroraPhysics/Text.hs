
module AuroraPhysics.Text (
createManualFT
)
where
import Data.Text
import qualified Data.Text as Text
import Text.LaTeX
import Text.LaTeX.Packages.Babel
import Effectful
import Effectful.Reader.Static
import Effectful.State.Static.Local
import Data.Map.Strict(Map)
import qualified Data.Map.Strict as Map

createManualFT::Reader (Map Text LaTeX):> es => Eff es LaTeX
createManualFT =  do
  p <- createPreamble
  d <- createDocument
  pure $ p <> d

tryLookup::Reader (Map Text LaTeX) :> es => Text -> Eff es LaTeX
tryLookup key = do
  allText <- ask
  case Map.lookup key allText of
    (Just a) -> pure a
    Nothing -> pure $ comment ("FIXME: key '" <> key <>  "' not found")
createPreamble:: Reader (Map Text LaTeX):> es => Eff es LaTeX
createPreamble = do
  undefined


createDocument = undefined
