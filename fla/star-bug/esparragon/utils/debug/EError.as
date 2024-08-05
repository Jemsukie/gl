package esparragon.utils.debug
{
   public class EError
   {
      
      public static const GRAVITY_ERROR_FATAL:int = 10;
      
      public static const GRAVITY_ERROR:int = 9;
      
      public static const GRAVITY_WARNING:int = 8;
       
      
      private var mGravity:int;
      
      private var mMsg:String;
      
      public function EError(gravity:int, msg:String)
      {
         super();
         this.mGravity = gravity;
         this.mMsg = msg;
      }
      
      public function destroy() : void
      {
         this.mMsg = null;
      }
      
      public function getGravity() : int
      {
         return this.mGravity;
      }
      
      public function getMsg() : String
      {
         return this.mMsg;
      }
   }
}
