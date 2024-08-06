package net.jpauclair.event
{
   import flash.events.Event;
   
   public class ChangeToolEvent extends Event
   {
      
      public static const CHANGE_TOOL_EVENT:String = "ChangeToolEvent";
       
      
      public var mTool:Class;
      
      public function ChangeToolEvent(newTool:Class)
      {
         this.mTool = newTool;
         super(CHANGE_TOOL_EVENT,true,false);
      }
   }
}
