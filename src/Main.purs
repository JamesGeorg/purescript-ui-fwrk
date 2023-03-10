module Main where

import Prelude

import Effect (Effect)
import Framework.Core (createScreen)
import Framework.Elements (layout)
import Framework.Props (height, onClick, text, width)
import Halogen.VDom (VDom)
import Halogen.VDom.DOM.Prop (Prop)

main :: Effect Unit
main = do
  void $ createScreen 
    { view
    , update
    , state
    }

type State = {
  count :: Int
}

data Action
  = Increment

state :: State
state = {
  count : 0
}

view :: (Action -> Effect Unit) -> State -> VDom (Array (Prop (Effect Unit)))
view push st = 
  layout
    [ height "100%"
    , width "100%"
    , text $ show st.count
    , onClick push (const Increment)
    ]
    [
    ]

update :: Action -> State -> State
update Increment st = st {count = st.count + 1}