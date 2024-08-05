package com.dchoc.game.view.dc.facade
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.view.facade.CursorFacade;
   import com.dchoc.toolkit.core.component.DCComponentUI;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutAreaFactory;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.system.Capabilities;
   import flash.text.TextField;
   import flash.ui.Mouse;
   
   public class DCCursorFacade extends DCComponentUI implements CursorFacade
   {
       
      
      private var mAnimDOs:Vector.<Sprite>;
      
      private var mRunningOnMac:Boolean;
      
      private var mNamesIds:Object;
      
      private var mCurrentId:int = -1;
      
      private var mCursorSprite:Sprite;
      
      public function DCCursorFacade()
      {
         super();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 1;
         this.mRunningOnMac = false;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         this.mAnimDOs = new Vector.<Sprite>(25);
         this.mCursorSprite = new Sprite();
      }
      
      override protected function unloadDo() : void
      {
         this.mAnimDOs = null;
         this.mCursorSprite = null;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var versionNumber:String = null;
         var versionArray:Array = null;
         var length:Number = NaN;
         var platformAndVersion:Array = null;
         var majorVersion:Number = NaN;
         var minorVersion:Number = NaN;
         var buildNumber:Number = NaN;
         var sprite:Sprite = null;
         var resourceMng:ResourceMng = null;
         var colorTransform:ColorTransform = null;
         if(step == 0)
         {
            length = (versionArray = (versionNumber = Capabilities.version).split(",")).length;
            platformAndVersion = versionArray[0].split(" ");
            majorVersion = parseInt(platformAndVersion[1]);
            minorVersion = parseInt(versionArray[1]);
            buildNumber = parseInt(versionArray[2]);
            if(platformAndVersion[0] == "MAC")
            {
               this.mRunningOnMac = true;
            }
            if(InstanceMng.getResourceMng().isResourceLoaded("assets/flash/_esparragon/gui/layouts/gui_old.swf"))
            {
               this.mNamesIds = {};
               resourceMng = InstanceMng.getResourceMng();
               this.mAnimDOs[0] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_recycle"))();
               this.mAnimDOs[1] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_instant_build"))();
               this.mAnimDOs[2] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_collect_money"))();
               this.mAnimDOs[3] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_collect_resource"))();
               this.mAnimDOs[4] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_hand_close"))();
               this.mAnimDOs[5] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_shipyard_open"))();
               this.mAnimDOs[6] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_shipyard_close"))();
               this.mAnimDOs[8] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_upgrade"))();
               this.mAnimDOs[9] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_move"))();
               this.mAnimDOs[10] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_flip"))();
               this.mAnimDOs[11] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_hangar"))();
               this.mAnimDOs[12] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_bunker"))();
               this.mAnimDOs[13] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_laboratory"))();
               this.mAnimDOs[14] = this.createVisitFriendCursor() as Sprite;
               this.mAnimDOs[15] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_special_attack"))();
               this.mAnimDOs[23] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_special_attack_fbomb"))();
               this.mAnimDOs[24] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_movewall"))();
               this.mNamesIds["cursor_special_attack"] = 15;
               this.mNamesIds["cursor_special_attack_fbomb"] = 23;
               sprite = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_special_attack"))();
               if(sprite != null)
               {
                  (colorTransform = new ColorTransform()).color = 16711680;
                  sprite.transform.colorTransform = colorTransform;
               }
               this.mAnimDOs[16] = sprite;
               this.mAnimDOs[17] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_repair"))();
               this.mAnimDOs[18] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_deploy"))();
               this.mAnimDOs[19] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","loading_time"))();
               this.mAnimDOs[20] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_observatory"))();
               this.mAnimDOs[21] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_attack_target"))();
               this.mAnimDOs[22] = new (resourceMng.getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_spy"))();
               buildAdvanceSyncStep();
            }
            this.mCursorSprite.mouseEnabled = false;
            this.mCursorSprite.mouseChildren = false;
         }
      }
      
      private function createVisitFriendCursor() : DisplayObjectContainer
      {
         var doc:DisplayObjectContainer = new (InstanceMng.getResourceMng().getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf","cursor_visit_friend"))();
         var layoutFactory:ELayoutAreaFactory = new ELayoutAreaFactory(doc,null);
         var etf:ETextField = InstanceMng.getViewFactory().getETextField(null,layoutFactory.getTextArea("text_actions"),"text_header");
         doc.addChild(etf);
         var tf:TextField = doc.getChildByName("text_actions") as TextField;
         doc.removeChild(tf);
         etf.name = "text_actions";
         return doc;
      }
      
      override protected function beginDo() : void
      {
         InstanceMng.getViewMngGame().cursorAddToStage(this.mCursorSprite);
         this.mCurrentId = -2;
         this.setCursorId(-1);
      }
      
      override protected function endDo() : void
      {
         InstanceMng.getViewMngGame().cursorRemoveFromStage(this.mCursorSprite);
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         this.mCursorSprite.x = InstanceMng.getApplication().stageGetStage().getMouseX();
         this.mCursorSprite.y = InstanceMng.getApplication().stageGetStage().getMouseY();
      }
      
      public function getCursorX() : Number
      {
         return InstanceMng.getApplication().stageGetStage().getMouseX();
      }
      
      public function getCursorY() : Number
      {
         return InstanceMng.getApplication().stageGetStage().getMouseY();
      }
      
      public function setCursorId(cursorId:int) : void
      {
         var sprite:Sprite = null;
         if(this.mCurrentId != cursorId)
         {
            if(cursorId == -1)
            {
               Mouse.show();
            }
            else if(!this.mRunningOnMac)
            {
               Mouse.hide();
            }
            if(this.mCurrentId > -1)
            {
               if(this.mAnimDOs[this.mCurrentId] != null && this.mCursorSprite.contains(this.mAnimDOs[this.mCurrentId]))
               {
                  this.mCursorSprite.removeChild(this.mAnimDOs[this.mCurrentId]);
               }
            }
            this.mCurrentId = cursorId;
            if(this.mCurrentId > -1)
            {
               sprite = this.mAnimDOs[this.mCurrentId];
               if(sprite != null)
               {
                  this.mCursorSprite.addChildAt(sprite,0);
               }
            }
         }
      }
      
      public function getCursorId() : int
      {
         return this.mCurrentId;
      }
      
      public function getCursorSprite(cursorId:int) : Sprite
      {
         if(cursorId >= 0)
         {
            return this.mAnimDOs[cursorId];
         }
         return null;
      }
      
      public function addDisplayObject(dc:DisplayObject) : void
      {
         this.mCursorSprite.addChild(dc);
      }
      
      public function removeDisplayObject(dc:DisplayObject) : void
      {
         if(this.mCursorSprite.contains(dc))
         {
            this.mCursorSprite.removeChild(dc);
         }
      }
      
      public function setTextInCursor(cursorId:int, text:String) : void
      {
         var textDO:ETextField = null;
         var doc:DisplayObjectContainer = this.getCursorSprite(cursorId) as DisplayObjectContainer;
         var done:Boolean = false;
         if(doc != null)
         {
            textDO = doc.getChildByName("text_actions") as ETextField;
            if(textDO != null)
            {
               textDO.setText(text);
               done = true;
            }
         }
         if(!done)
         {
            DCDebug.trace("[ERROR] this shouldn\'t have happened, current cursor doesn\'t have text_actions field!",3);
         }
      }
      
      public function nameToId(cursorName:String, defaultValue:int = -1) : int
      {
         if(this.mNamesIds == null)
         {
            return defaultValue;
         }
         if(!(cursorName in this.mNamesIds))
         {
            return defaultValue;
         }
         return this.mNamesIds[cursorName] as int;
      }
   }
}
