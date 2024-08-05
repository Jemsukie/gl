package esparragon.core
{
   import esparragon.behaviors.EBehaviorsMng;
   import esparragon.display.EDisplayFactory;
   import esparragon.display.EImage;
   import esparragon.display.EMovieClip;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.events.EEventFactory;
   import esparragon.resources.EPool;
   import esparragon.resources.EResourcesMng;
   import esparragon.skins.ESkinsMng;
   import esparragon.utils.EDebug;
   import esparragon.widgets.EButton;
   
   public class Esparragon
   {
      
      public static const NO_TEXTURE_ID:String = "no_texture";
      
      public static const CHANNEL_ERROR:String = "E_ERROR";
      
      public static const CHANNEL_LOADER:String = "E_LOADER";
      
      public static const CHANNEL_LOADER_ERROR:String = "E_LOADER_ERROR";
      
      private static var smDisplayFactory:EDisplayFactory;
      
      private static var smEventFactory:EEventFactory;
      
      private static var smResourcesMng:EResourcesMng;
      
      private static var smSkinsMng:ESkinsMng;
      
      private static var smDebug:EDebug;
      
      private static var smPool:EPool;
      
      private static var smBehaviorsMng:EBehaviorsMng;
       
      
      public function Esparragon(displayFactory:EDisplayFactory, eventFactory:EEventFactory, behaviorsMng:EBehaviorsMng, resourcesMng:EResourcesMng, skinsMng:ESkinsMng, debug:EDebug = null, pool:EPool = null)
      {
         super();
         smDisplayFactory = displayFactory;
         smEventFactory = eventFactory;
         smResourcesMng = resourcesMng;
         smSkinsMng = skinsMng;
         smDebug = debug;
         smPool = pool;
         smBehaviorsMng = behaviorsMng;
      }
      
      public static function getDisplayFactory() : EDisplayFactory
      {
         return smDisplayFactory;
      }
      
      public static function getEventFactory() : EEventFactory
      {
         return smEventFactory;
      }
      
      public static function getBehaviorsMng() : EBehaviorsMng
      {
         return smBehaviorsMng;
      }
      
      public static function getResourcesMng() : EResourcesMng
      {
         return smResourcesMng;
      }
      
      public static function getSkinsMng() : ESkinsMng
      {
         return smSkinsMng;
      }
      
      public static function isDebugModeEnabled() : Boolean
      {
         return smDebug != null && smDebug.isDebugModeEnabled();
      }
      
      public static function needsDebugToStoreLogs() : Boolean
      {
         return smDebug != null && smDebug.needsDebugToStoreLogs();
      }
      
      public static function poolReturnESprite(value:ESprite) : void
      {
         if(smPool != null)
         {
            smPool.returnESprite(value);
         }
      }
      
      public static function poolReturnETextField(value:ETextField) : void
      {
         if(smPool != null)
         {
            smPool.returnETextField(value);
         }
      }
      
      public static function poolReturnEImage(value:EImage) : void
      {
         if(smPool != null)
         {
            smPool.returnEImage(value);
         }
      }
      
      public static function poolReturnEMovieClip(value:EMovieClip) : void
      {
         if(smPool != null)
         {
            smPool.returnEMovieClip(value);
         }
      }
      
      public static function poolReturnEButton(value:EButton) : void
      {
         if(smPool != null)
         {
            smPool.returnButton(value);
         }
      }
      
      public static function traceMsg(msg:String, channel:String = null, launchException:Boolean = false, priority:int = 2) : void
      {
         var fullMsg:String = (fullMsg = channel == null ? "" : "[" + channel + "] ") + msg;
         if(smDebug != null)
         {
            smDebug.traceMsg(msg,channel,launchException,priority);
         }
      }
      
      public static function throwError(msg:String, channel:String = null) : void
      {
         traceMsg(msg,channel,true,10);
      }
   }
}
