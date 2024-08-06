package esparragon.utils
{
   public class EDebug
   {
       
      
      private var mNeedsToStoreLogs:Boolean;
      
      private var mThrowExceptionIsAllowed:Boolean;
      
      public function EDebug(needsToStoreLogs:Boolean = false, throwExceptionIsAllowed:Boolean = false)
      {
         super();
         this.mNeedsToStoreLogs = needsToStoreLogs;
         this.mThrowExceptionIsAllowed = throwExceptionIsAllowed;
      }
      
      public function isDebugModeEnabled() : Boolean
      {
         return false;
      }
      
      protected function isThrowExceptionAllowed() : Boolean
      {
         return this.mThrowExceptionIsAllowed;
      }
      
      public function needsDebugToStoreLogs() : Boolean
      {
         return this.mNeedsToStoreLogs;
      }
      
      public function traceMsg(msg:String, channel:String = null, throwException:Boolean = false, priority:int = 2) : void
      {
      }
   }
}
