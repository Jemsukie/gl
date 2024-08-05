package com.dchoc.game.model.contest
{
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   
   public class ContestConstants
   {
      
      public static const TIME_BETWEEN_PROGRESS_UPDATES_MS:Number = DCTimerUtil.minToMs(5);
      
      public static const TIME_BETWEEN_LEADERBOARD_UPDATES_MS:Number = DCTimerUtil.minToMs(5);
      
      public static const NOTIFICATION_UPDATE_PROGRESS_ENABLED:Boolean = true;
      
      public static const ERROR_CODE_UNDEFINED:int = 0;
      
      public static const ERROR_CODE_TO_TID:Array = [-1];
       
      
      public function ContestConstants()
      {
         super();
      }
      
      private static function getErrorCodeProcessed(errorCode:int) : int
      {
         return errorCode;
      }
      
      public static function getErrorMsg(errorCode:int) : String
      {
         errorCode = getErrorCodeProcessed(errorCode);
         var tid:int = int(errorCode < 0 || errorCode >= ERROR_CODE_TO_TID.length ? -1 : int(ERROR_CODE_TO_TID[errorCode]));
         return tid == -1 ? "error " + errorCode : DCTextMng.getText(tid);
      }
   }
}
