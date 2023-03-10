module Framework.Core where

import Prelude

import Effect (Effect)
import Effect.Ref (Ref, new, read, write)
import Effect.Uncurried (runEffectFn1, runEffectFn2)
import FRP.Behavior (sample_, unfold)
import FRP.Event (EventIO, create, subscribe)
import Halogen.VDom (Step, VDom, VDomSpec(..), buildVDom, step)
import Halogen.VDom.DOM.Prop (Prop, buildProp)
import Web.DOM (Document)

type Screen state action = 
  { state :: state
  , update :: action -> state -> state
  , view :: (action -> Effect Unit) -> state -> VDom (Array (Prop (Effect Unit)))
  }

foreign import getDocument :: Effect Document
foreign import attachMachine :: forall a b. Step a b -> Effect Unit

spec :: Document -> VDomSpec (Array (Prop (Effect Unit)))
spec doc = VDomSpec {
  buildAttributes : buildProp identity
, document : doc
}

createScreen :: forall state action. Screen state action -> Effect (Effect Unit)
createScreen screen = do

  -- Create an empty event reciever as a base to recieve events for the behavior
  -- push is a function that will call all subscribers to the event
  ({push, event} :: EventIO action) <- create

  -- Make shift mechanism to draw UI
  doc <- getDocument

  -- VDOM
  machine <- runEffectFn1 (buildVDom (spec doc)) $ screen.view push screen.state
  attachMachine machine

  -- Create a reference
  latestMachine <- new machine

  -- Connect the behavior to the event and use state as the base
  let stateBehavior = unfold screen.update event screen.state

  -- Sample the behavior whenever the event triggers
  let stateEvent = sample_ stateBehavior event

  -- Trigger UI update whenever state changes
  stateEvent `subscribe` (\state -> updateUI latestMachine screen push state)
  
updateUI :: forall state action b. Ref (Step (VDom (Array (Prop (Effect Unit)))) b) -> Screen state action -> (action -> Effect Unit) -> state ->  Effect Unit
updateUI machineRef screen push state = do
  -- get the last machine
  machine <- read machineRef
  
  -- get the update Screen UI
  let vdom = screen.view push state

  -- Check the diff between the dom
  newMachine <- runEffectFn2 step machine vdom

  -- Update the machine reference
  void $ write newMachine machineRef