module Framework.Elements where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen.VDom (ElemName(..), VDom(..))
import Halogen.VDom.DOM.Prop (Prop)

element :: String -> Array (Prop (Effect Unit)) -> Array (VDom (Array (Prop (Effect Unit)))) -> VDom (Array (Prop (Effect Unit)))
element elemName = Elem Nothing (ElemName elemName)

layout :: Array (Prop (Effect Unit)) -> Array (VDom (Array (Prop (Effect Unit)))) -> VDom (Array (Prop (Effect Unit)))
layout = element "layout"