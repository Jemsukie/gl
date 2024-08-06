package esparragon.events
{
   public class EEvent
   {
      
      public static const IMMEDIATELY:String = "immediately";
      
      public static const ADDED_TO_STAGE:String = "addedToStage";
      
      public static const CLICK:String = "click";
      
      public static const MOUSE_OVER:String = "rollOver";
      
      public static const MOUSE_OUT:String = "rollOut";
      
      public static const MOUSE_MOVE:String = "mouseMove";
      
      public static const MOUSE_UP:String = "mouseUp";
      
      public static const MOUSE_DOWN:String = "mouseDown";
      
      public static const FOCUS_OUT:String = "focusOut";
       
      
      private var mType:String;
      
      private var mTarget:Object;
      
      public var stageX:Number;
      
      public var stageY:Number;
      
      public var localX:Number;
      
      public var localY:Number;
      
      public var buttonDown:Boolean;
      
      public function EEvent(target:Object, type:String)
      {
         super();
         this.mType = type;
         this.mTarget = target;
      }
      
      public function getType() : String
      {
         return this.mType;
      }
      
      public function getTarget() : Object
      {
         return this.mTarget;
      }
   }
}
