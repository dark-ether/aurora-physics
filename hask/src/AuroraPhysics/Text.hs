
module AuroraPhysics.Text (
createManualFT,
mainLL,
mainCsvll,
)
where
import GHC.Generics
import Data.Text (Text)
import qualified Data.Text as Text
import qualified Data.Text.IO as Text
import Text.LaTeX
import Text.LaTeX.Packages.Babel
import Text.LaTeX.Packages.LongTable
import Effectful
import Effectful.Reader.Static
import Effectful.State.Static.Local
import Data.Maybe
import Data.Map.Strict(Map)
import Text.LaTeX.Base.Pretty
import qualified Data.Map.Strict as Map
import Prettyprinter
import Prettyprinter.Render.Text (renderStrict)
import Data.Functor.Identity (Identity (..))
import Control.Monad (unless, forM_)
import Data.Csv
import qualified Data.ByteString.Lazy as BS
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
data Entrada = MkEntrada Int Int Int
  deriving (Eq,Ord,Show,Generic)
instance FromRecord Entrada
instance ToRecord Entrada

n2ll:: Int -> Int
n2ll n = n * (n + 1 ) `div` 2

fazerEntrada::Int -> Int -> Entrada
fazerEntrada mult n = MkEntrada n (n * mult) (mult * n2ll n)

fillRowsWith::Int -> [Entrada] -> LaTeX
fillRowsWith n listae = snd $ foldr (nentParaLista n) ([],mempty) (reverse listae)
fillRowsWith2::Int -> [Entrada] -> LaTeX
fillRowsWith2 n listae = runIdentity . execLaTeXT $ encherColunas (dividirEmN n listae)
safeHead:: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:_) = Just x

umDeCada::[[a]] -> [a]
umDeCada = mapMaybe safeHead

semOPrimeiro::[[a]]-> [[a]]
semOPrimeiro = fmap (drop 1)

emNdeN:: Int -> Int -> [a] -> [[a]]
emNdeN porVez 1 lista = [take porVez lista]
emNdeN porVez vezes lista = take porVez lista : emNdeN porVez (vezes - 1) (drop porVez lista)

dividirEmN :: Int -> [a] -> [[a]]
dividirEmN n lista = emNdeN (length lista `div` n) n lista

encherColunas::[[Entrada]] -> LaTeXT Identity ()
encherColunas lle = do
  textell . listaEntParaColunas . umDeCada $ lle
  unless (any null $ semOPrimeiro lle) (encherColunas $ semOPrimeiro lle)

nentParaLista:: Int -> Entrada -> ([Entrada],LaTeX) -> ([Entrada],LaTeX)
nentParaLista n ent (lent,b)
  | length lent == n-1 = ([],b <> listaEntParaColunas (reverse $ ent:lent))
  | otherwise = (ent:lent,b)

listaEntParaColunas :: [Entrada] -> LaTeX
listaEntParaColunas lent =  foldr1 (&) (fmap entParaColunas lent) <> tabularnewline

entParaColunas:: Entrada -> LaTeX
entParaColunas (MkEntrada n1 n2 n3) = " "<> texy n1 <> " " & " " <> texy n2 <> " " & " "<> texy n3 <> " "

fazerlltable :: Int -> Int -> LaTeX
fazerlltable até pll  = section ("tabela " <> texy pll <>"/nível/nível") <> (longtable Nothing (take 19 $ cycle [VerticalLine,CenterColumn]) .
  (("nível" & "custo +1" & "custo do zero" &"nível" & "custo +1" & "custo do zero" &"nível" & "custo +1" & "custo do zero" <> tabularnewline) <>)
  . fillRowsWith2 3
     $ fmap (fazerEntrada pll) [1..até])

mainLL::IO ()
mainLL = Text.writeFile "lltables.tex"
  (renderStrict . layoutPretty defaultLayoutOptions . docLaTeX . foldr1 (<>) $
    fmap (fazerlltable 48) [1..10])

mainCsvll::IO ()
mainCsvll = do
  forM_ [1..10] (\x ->BS.writeFile ("./tabela" <> show x <> "nívelnível.csv") . encode $ fmap (fazerEntrada x) [1..50]) 

-- optimal mental skill points
-- optimal fisical skill points
