package com.dchoc.game.utils
{
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import esparragon.utils.EDebug;
   
   public class Debug extends EDebug
   {
       
      
      public function Debug()
      {
         super(false,Config.THROW_EXCEPTION_IF_ERROR_IN_ASSETS_OR_SKINS);
      }
      
      override public function isDebugModeEnabled() : Boolean
      {
         return Config.DEBUG_MODE || UserDataMng.mUserIsVIP;
      }
      
      override public function traceMsg(msg:String, channel:String = null, throwException:Boolean = false, priority:int = 2) : void
      {
         DCDebug.traceCh(channel,msg,0,throwException && isThrowExceptionAllowed());
      }
   }
}
