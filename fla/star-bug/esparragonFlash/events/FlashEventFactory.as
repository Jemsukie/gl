package esparragonFlash.events
{
   import esparragon.display.ESprite;
   import esparragon.events.EEvent;
   import esparragon.events.EEventFactory;
   import flash.events.Event;
   
   public class FlashEventFactory implements EEventFactory
   {
       
      
      public function FlashEventFactory()
      {
         super();
      }
      
      public function translateEToApiEventType(type:String) : String
      {
         return type;
      }
      
      public function translateApiToEEvent(e:Object, target:ESprite) : EEvent
      {
         var apiEvent:Event;
         target = (apiEvent = e as Event).target as ESprite;
         var parent:Object = apiEvent.target.parent;
         while(!target && parent)
         {
            target = parent as ESprite;
            parent = parent.parent;
         }
         var returnValue:EEvent = new EEvent(target,apiEvent.type);
         if(target != null)
         {
            switch(apiEvent.type)
            {
               case "mouseMove":
               case "mouseDown":
               case "mouseUp":
               case "click":
                  returnValue.localX = e.localX;
                  returnValue.localY = e.localY;
                  returnValue.stageX = e.stageX;
                  returnValue.stageY = e.stageY;
                  returnValue.buttonDown = e.buttonDown;
               case "rollOver":
                  target.eventsSetIsMouseOver(true);
                  returnValue.buttonDown = e.buttonDown;
                  break;
               case "rollOut":
                  target.eventsSetIsMouseOver(false);
                  returnValue.buttonDown = e.buttonDown;
            }
         }
         return returnValue;
      }
   }
}
