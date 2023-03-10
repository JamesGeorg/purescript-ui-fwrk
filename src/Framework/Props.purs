module Framework.Props where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen.VDom.DOM.Prop (Prop(..))
import Unsafe.Coerce (unsafeCoerce)
import Unsafe.Coerce as U
import Web.Event.Event as DOM


event :: forall a. DOM.EventType -> (DOM.Event → Maybe a) -> Prop a
event = Handler

makeEvent :: forall a. (a -> Effect Unit ) -> (DOM.Event → Effect Unit)
makeEvent push = \ev -> do
    _ <- push (U.unsafeCoerce ev)
    pure unit

prop :: forall value. String -> value -> Prop (Effect Unit)
prop name = Property name <<< unsafeCoerce

onClick :: forall a. (a ->  Effect Unit) -> (Unit -> a) -> Prop (Effect Unit)
onClick push f = event (DOM.EventType "onClick") (Just <<< (makeEvent (push <<< f)))

height :: String -> Prop (Effect Unit)
height a = prop "height" a

width :: String -> Prop (Effect Unit)
width a = prop "width" a

text :: String -> Prop (Effect Unit)
text a = prop "text" a