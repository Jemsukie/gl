package
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.core.flow.Application;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.reygazu.anticheat.events.CheatManagerEvent;
   import com.reygazu.anticheat.managers.CheatManager;
   import flash.display.Sprite;
   import flash.system.Capabilities;
   import flash.system.Security;
   import flash.ui.ContextMenu;
   
   public class Star extends Sprite
   {
      
      public static var flashVars:Object;
       
      
      public function Star()
      {
         super();
         Security.allowDomain("*");
         Security.allowInsecureDomain("*");
         Config.USE_SOUNDS = Capabilities.hasAudio;
         flashVars = root.loaderInfo.parameters;
         DCDebug.traceChObject("flashVars",flashVars);
         if(Config.OFFLINE_GAMEPLAY_MODE)
         {
            flashVars = {};
         }
         Config.init();
         Entry.init();
         if(flashVars != null && flashVars.hasOwnProperty("data"))
         {
            Config.setRoot(flashVars["data"]);
         }
         this.contextMenu = new ContextMenu();
         this.contextMenu.hideBuiltInItems();
         new Application(stage,this,68115);
         stage.stageFocusRect = false;
         CheatManager.getInstance().init(stage);
         CheatManager.getInstance().enableFocusHop = true;
         CheatManager.getInstance().addEventListener(CheatManagerEvent.CHEAT_DETECTION,this.onCheatDetected);
      }
      
      public static function getFlashVars() : Object
      {
         return flashVars;
      }
      
      public static function getPlatformId() : String
      {
         return Config.OFFLINE_GAMEPLAY_MODE ? "facebook" : flashVars.platform;
      }
      
      private function onCheatDetected(cEvent:CheatManagerEvent) : void
      {
         DCDebug.trace("cheat detected!!!!!!  " + cEvent.target);
         InstanceMng.getUserDataMng().updateProfile_cheater("cheatClientMemory",cEvent.data);
      }
      
      private function onInputDetected(cEvent:CheatManagerEvent) : void
      {
         if(cEvent.data.type == "mouseMove")
         {
            InstanceMng.getUserDataMng().updateTelemetry_mouseMove(cEvent.data.x,cEvent.data.y,cEvent.data.w,cEvent.data.h,cEvent.data.time);
         }
         else if(cEvent.data.type == "mouseClick")
         {
            InstanceMng.getUserDataMng().updateTelemetry_mouseClick(cEvent.data.x,cEvent.data.y,cEvent.data.w,cEvent.data.h,cEvent.data.time);
         }
      }
   }
}
