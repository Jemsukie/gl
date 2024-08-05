package esparragon.events
{
   import esparragon.display.ESprite;
   
   public interface EEventFactory
   {
       
      
      function translateEToApiEventType(param1:String) : String;
      
      function translateApiToEEvent(param1:Object, param2:ESprite) : EEvent;
   }
}
