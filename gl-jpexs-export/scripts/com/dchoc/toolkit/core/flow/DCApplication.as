package com.dchoc.toolkit.core.flow
{
   import com.adobe.images.JPGEncoder;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   import com.dchoc.toolkit.core.notify.DCNotifyMng;
   import com.dchoc.toolkit.core.profiler.DCProfiler;
   import com.dchoc.toolkit.core.resource.DCResourceDef;
   import com.dchoc.toolkit.core.resource.DCResourceMng;
   import com.dchoc.toolkit.core.rule.DCRuleMng;
   import com.dchoc.toolkit.core.view.display.DCStage;
   import com.dchoc.toolkit.core.view.mng.DCViewMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.hurlant.util.Base64;
   import flash.display.BitmapData;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.BlurFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.Security;
   import flash.utils.ByteArray;
   
   public class DCApplication extends DCComponent
   {
      
      private static var smStage:Stage;
      
      public static const EVENT_ABORT_APPLICATION:String = "eventAbortApplication";
      
      public static const FSM_OUTING_STATE_UNLOAD:int = 0;
      
      public static const FSM_OUTING_STATE_UNBUILD:int = 1;
      
      public static const FSM_OUTING_STATE_END:int = 2;
      
      private static const MAX_TIMER_MINUTES:int = 1;
      
      private static const MAX_TIMER_MS:int = DCTimerUtil.minToMs(1);
      
      private static const MAX_DELTA_TIME_MS:int = Config.DEBUG_MODE ? 200 : 500;
       
      
      private var mContext:InteractiveObject;
      
      private var mKeyboardInputEnabled:Boolean;
      
      protected var mStage:DCStage;
      
      protected var mFsmStates:Vector.<DCFlowState>;
      
      protected var mFsmCurrentStateId:int;
      
      protected var mFsmCurrentState:DCFlowState;
      
      protected var mFsmStatesCount:int;
      
      private var mMngInstanceMng:DCInstanceMng;
      
      protected var mMngNotifyMng:DCNotifyMng;
      
      private var mMngResourceMng:DCResourceMng;
      
      private var mMngRuleMng:DCRuleMng;
      
      private var mTotalTime:Number = 0;
      
      protected var mGameTime:Number;
      
      private var mTimeOffset:Number = 0;
      
      protected var mLastClickLabel:String = null;
      
      private var mBgShape:Sprite;
      
      private var mBgColor:uint;
      
      public function DCApplication(stage:Stage, context:InteractiveObject, bgColor:uint)
      {
         smStage = stage;
         super();
         this.mContext = context;
         this.stageSetStage(stage);
         this.mKeyboardInputEnabled = true;
         Security.allowDomain("*");
         this.mGameTime = DCTimerUtil.currentTimeMillis();
         this.bgInit(bgColor);
      }
      
      public static function stageGetParameters() : Object
      {
         return smStage.root.loaderInfo.parameters;
      }
      
      override protected function childrenCreate() : void
      {
         this.mMngResourceMng = this.mngCreateResourceMng();
         DCResourceDef.setResourceMng(this.mMngResourceMng);
         childrenAddChild(this.mMngResourceMng);
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            DCMath.init();
            this.fsmLoad();
            this.mngLoad();
         }
         this.loadDoDoStep(step);
      }
      
      override protected function unloadDo() : void
      {
         this.fsmUnload();
         this.unloadDoDo();
         this.mngUnload();
         this.mLastClickLabel = null;
      }
      
      protected function loadDoDoStep(step:int) : void
      {
      }
      
      protected function unloadDoDo() : void
      {
      }
      
      override protected function unbuildDo() : void
      {
         this.fsmUnbuild();
      }
      
      override protected function beginDo() : void
      {
         this.fsmChangeState(0);
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         if(mIsEnabled && !DCDebug.isApplicationHalted())
         {
            if(this.mFsmCurrentState != null)
            {
               this.mFsmCurrentState.logicUpdate(dt);
            }
            this.logicUpdateDoDo(dt);
            this.mMngNotifyMng.logicUpdate(dt);
            this.mMngRuleMng.logicUpdate(dt);
         }
      }
      
      protected function logicUpdateDoDo(dt:int) : void
      {
      }
      
      override public function notify(e:Object) : Boolean
      {
         var returnValue:Boolean = true;
         var _loc3_:* = e.cmd;
         if("eventAbortApplication" !== _loc3_)
         {
            returnValue = false;
         }
         else
         {
            if(Config.DEBUG_MODE)
            {
               DCDebug.traceCh("TOOLKIT","Application aborted: " + e.msg,3);
            }
            pause();
         }
         return returnValue;
      }
      
      public function stageGetStage() : DCStage
      {
         return this.mStage;
      }
      
      private function stageSetStage(stage:Stage) : void
      {
         if(this.mStage != null)
         {
            this.stageEnd();
         }
         this.mStage = new DCStage(stage);
         if(this.mStage != null)
         {
            smStage = stage;
            this.stageDoSetStage(this.mStage);
            this.stageBegin();
         }
      }
      
      protected function stageDoSetStage(stage:DCStage) : void
      {
         if(false)
         {
            stage.getImplementation().fullScreenSourceRect = new Rectangle(0,0,760,594);
            stage.setAlign("TL");
            stage.setScaleMode("noScale");
            stage.addEventListener("click",this._handleClickRealSize);
         }
         else
         {
            stage.setAlign("TL");
            stage.setScaleMode("noScale");
         }
      }
      
      private function _goFullScreenRealSize() : void
      {
         if(this.mStage.getImplementation().displayState == "normal")
         {
            this.mStage.getImplementation().displayState = "fullScreenInteractive";
            this.mStage.setScaleMode("noScale");
         }
         else
         {
            this.mStage.getImplementation().displayState = "normal";
         }
      }
      
      private function _handleClickRealSize(event:MouseEvent) : void
      {
         this._goFullScreenRealSize();
         this.mStage.removeEventListener("click",this._handleClickRealSize);
      }
      
      protected function stageBegin() : void
      {
         DCDebug.startConsole(this.mStage);
         DCProfiler.startProfiling(this.mStage.getImplementation(),this.mContext);
         DCDebug.startDebug(this.mStage,this.mContext);
         this.mStage.addEventListener("enterFrame",this.onEnterFrame);
         this.mStage.addEventListener("resize",this.onResize);
         this.mStage.addEventListener("keyUp",this.onKeyUp);
         this.mStage.addEventListener("keyDown",this.onKeyDown);
         this.mStage.addEventListener("mouseDown",this.onMouseDown);
         this.mStage.addEventListener("mouseUp",this.onMouseUp);
         this.mStage.addEventListener("mouseMove",this.onMouseMove);
         this.mStage.addEventListener("mouseOver",this.onMouseOver);
         this.mStage.addEventListener("mouseOut",this.onMouseOut);
         this.mStage.addEventListener("click",this.onMouseClick);
         this.mStage.addEventListener("mouseWheel",this.onMouseWheel);
         this.mStage.addEventListener("mouseLeave",this.onMouseLeave);
      }
      
      protected function stageEnd() : void
      {
         this.mStage.removeEventListener("enterFrame",this.onEnterFrame);
         this.mStage.removeEventListener("resize",this.onResize);
         this.mStage.removeEventListener("keyUp",this.onKeyUp);
         this.mStage.removeEventListener("keyDown",this.onKeyDown);
         this.mStage.removeEventListener("mouseDown",this.onMouseDown);
         this.mStage.removeEventListener("mouseUp",this.onMouseUp);
         this.mStage.removeEventListener("mouseMove",this.onMouseMove);
         this.mStage.removeEventListener("mouseOver",this.onMouseOver);
         this.mStage.removeEventListener("mouseOut",this.onMouseOut);
         this.mStage.removeEventListener("click",this.onMouseClick);
         this.mStage.removeEventListener("mouseWheel",this.onMouseWheel);
         this.mStage.removeEventListener("mouseLeave",this.onMouseLeave);
      }
      
      public function stageGetParameters() : Object
      {
         return this.mStage.getImplementation().root.loaderInfo.parameters;
      }
      
      public function stageGetWidth() : int
      {
         return this.mStage.getStageWidth();
      }
      
      public function stageGetHeight() : int
      {
         return this.mStage.getStageHeight();
      }
      
      public function stageExportScreenshot(scale:Number) : String
      {
         var layerId:int = 0;
         var bData:BitmapData = null;
         var blurFilter:BlurFilter = null;
         var jpegEncoder:JPGEncoder = null;
         var jpgBytes:ByteArray = null;
         var screenshotBase64:String = null;
         var result:* = null;
         var viewMng:DCViewMng = DCInstanceMng.getInstance().getViewMng();
         if(this.mStage != null && viewMng != null)
         {
            layerId = viewMng.getTopLayerId();
            bData = viewMng.takeScreenShot(layerId,scale);
            blurFilter = new BlurFilter(3,3,3);
            bData.applyFilter(bData,bData.rect,new Point(0,0),blurFilter);
            jpegEncoder = new JPGEncoder(80);
            if(jpgBytes = jpegEncoder.encode(bData))
            {
               if(screenshotBase64 = Base64.encodeByteArray(jpgBytes))
               {
                  result = screenshotBase64;
               }
            }
         }
         return result;
      }
      
      private function fsmLoad() : void
      {
         this.fsmDoLoad();
         this.mFsmStates = new Vector.<DCFlowState>(this.mFsmStatesCount,true);
      }
      
      protected function fsmDoLoad() : void
      {
         this.mFsmStatesCount = 1;
      }
      
      private function fsmUnload() : void
      {
         if(this.mFsmStates != null)
         {
            this.mFsmStates.splice(0,this.mFsmStates.length);
         }
         this.mFsmStates = null;
      }
      
      protected function fsmBuild() : void
      {
      }
      
      private function fsmUnbuild() : void
      {
         var i:int = 0;
         for(i = 0; i < this.mFsmStatesCount; )
         {
            (this.mFsmStates[i] as DCFlowState).unload();
            this.mFsmStates[i] = null;
            i++;
         }
      }
      
      public function fsmChangeState(id:int, howToEndOutingState:int = 1, changeViewMng:Boolean = true) : void
      {
         var value:DCViewMng = null;
         if(id > -1 && id < this.mFsmStatesCount)
         {
            if(this.mFsmCurrentState != null)
            {
               switch(howToEndOutingState)
               {
                  case 0:
                     this.mFsmCurrentState.unload();
                     break;
                  case 1:
                     this.mFsmCurrentState.unbuild();
                     break;
                  case 2:
                     this.mFsmCurrentState.end();
               }
            }
            if(this.mFsmCurrentState != null && changeViewMng)
            {
               (value = this.mFsmCurrentState.viewMngGet()).end();
            }
            this.mFsmCurrentStateId = id;
            this.mFsmCurrentState = this.mFsmStates[id];
            if(changeViewMng)
            {
               (value = this.mFsmCurrentState.viewMngGet()).addToStage(this.mStage);
               this.mngGetInstanceMng().registerViewMng(value);
            }
         }
      }
      
      public function fsmGetCurrentState() : DCFlowState
      {
         return this.mFsmCurrentState;
      }
      
      public function setViewMng(value:DCViewMng) : void
      {
         value = this.mFsmCurrentState.viewMngGet();
         value.addToStage(this.mStage);
         this.mngGetInstanceMng().registerViewMng(value);
      }
      
      private function mngLoad() : void
      {
         this.mMngNotifyMng = this.mngCreateNotifyMng();
         this.mngGetInstanceMng();
         this.mMngRuleMng = this.mngCreateRuleMng();
         this.mMngInstanceMng.registerApplication(this);
         this.mMngInstanceMng.registerResourceMng(this.mMngResourceMng);
         this.mMngInstanceMng.registerNotifyMng(this.mMngNotifyMng);
         this.mMngInstanceMng.registerRuleMng(this.mMngRuleMng);
      }
      
      private function mngUnload() : void
      {
         if(this.mMngRuleMng != null)
         {
            this.mMngRuleMng.unload();
            this.mMngRuleMng = null;
         }
         if(this.mMngResourceMng != null)
         {
            this.mMngResourceMng.unload();
            this.mMngResourceMng = null;
         }
         if(this.mMngInstanceMng != null)
         {
            this.mMngInstanceMng.unload();
            this.mMngInstanceMng = null;
         }
         if(this.mMngNotifyMng != null)
         {
            this.mMngNotifyMng.unload();
            this.mMngNotifyMng = null;
         }
      }
      
      public function mngGetInstanceMng() : DCInstanceMng
      {
         if(this.mMngInstanceMng == null)
         {
            this.mMngInstanceMng = this.mngCreateInstanceMng();
         }
         return this.mMngInstanceMng;
      }
      
      protected function mngCreateInstanceMng() : DCInstanceMng
      {
         return null;
      }
      
      protected function mngCreateNotifyMng() : DCNotifyMng
      {
         return new DCNotifyMng();
      }
      
      protected function mngCreateResourceMng() : DCResourceMng
      {
         return null;
      }
      
      protected function mngCreateRuleMng() : DCRuleMng
      {
         return new DCRuleMng(null,null);
      }
      
      public function setTimeOffset(deltaTime:Number) : void
      {
         this.mTimeOffset = deltaTime;
      }
      
      public function getTimeOffset() : Number
      {
         return this.mTimeOffset;
      }
      
      public function getTotalTime() : Number
      {
         return this.mTotalTime;
      }
      
      public function lastClickSetLabel(value:String) : void
      {
         this.mLastClickLabel = value;
      }
      
      protected function lastClickProcess() : void
      {
      }
      
      private function onEnterFrame(event:Event) : void
      {
         var goAhead:Boolean = false;
         var timeMillis:Number;
         var dt:int = (timeMillis = DCTimerUtil.currentTimeMillis()) - this.mGameTime;
         this.mGameTime = timeMillis;
         if(dt > MAX_DELTA_TIME_MS)
         {
            dt = MAX_DELTA_TIME_MS;
         }
         if(dt < 1)
         {
            dt = 1;
         }
         if(this.mTimeOffset >= 1)
         {
            dt = MAX_TIMER_MS;
            this.mTimeOffset -= 1;
            this.mTotalTime += dt;
         }
         else if(this.mTimeOffset > 0)
         {
            dt += DCTimerUtil.minToMs(this.mTimeOffset);
            this.mTimeOffset = 0;
            this.mTotalTime += dt;
         }
         if(Config.DEBUG_MODE && Config.DEBUG_CATCH_EXCEPTIONS || Config.NOTIFY_EXCEPTIONS_TO_SERVER)
         {
            try
            {
               logicUpdate(dt);
            }
            catch(e:Error)
            {
               if(Config.NOTIFY_EXCEPTIONS_TO_SERVER)
               {
                  if(InstanceMng.getUserDataMng() != null)
                  {
                     try
                     {
                        InstanceMng.getUserDataMng().notifyException(e.name,e.message,e.getStackTrace());
                     }
                     catch(err:Error)
                     {
                     }
                  }
               }
               else
               {
                  goAhead = Config.DEBUG_MODE || UserDataMng.mUserIsVIP;
                  if(goAhead)
                  {
                     DCDebug.debugPopupArray(["*** Guru Meditation ***","Name: " + e.name,"Message: " + e.message,"Stacktrace:",e.getStackTrace()],true);
                  }
               }
            }
         }
         else
         {
            logicUpdate(dt);
         }
      }
      
      private function onResize(event:Event) : void
      {
         if(this.mFsmCurrentState != null)
         {
            this.mFsmCurrentState.onResize(this.mStage.getStageWidth(),this.mStage.getStageHeight());
         }
         this.mStage.setScaleMode("noScale");
         this.bgResize(this.mStage.getStageWidth(),this.mStage.getStageHeight());
      }
      
      protected function onKeyUp(e:KeyboardEvent) : void
      {
         if(this.mFsmCurrentState != null)
         {
            this.mFsmCurrentState.onKeyUp(e);
         }
      }
      
      protected function onKeyDown(e:KeyboardEvent) : void
      {
         switch(e.keyCode)
         {
            case 80:
               if(Config.DEBUG_MODE)
               {
                  if(isPaused())
                  {
                     resume();
                  }
                  else
                  {
                     pause();
                  }
               }
               break;
            case 86:
               if(Config.DEBUG_MODE)
               {
                  if(isPaused())
                  {
                     resume();
                     logicUpdate(25);
                     pause();
                  }
               }
               break;
            case 66:
               if(Config.DEBUG_MODE)
               {
                  if(isPaused())
                  {
                     resume();
                     logicUpdate(300);
                     pause();
                  }
               }
               break;
            case 219:
               InstanceMng.getGUIController().lockGUI();
               break;
            case 220:
               InstanceMng.getGUIController().unlockGUI();
               break;
            case 16:
            case 96:
               if(Config.DEBUG_MODE || UserDataMng.mUserIsVIP)
               {
                  DCDebug.setVisible(!DCDebug.getVisible());
                  DCProfiler.setVisible(DCProfiler.getVisible());
               }
               break;
            case 97:
               if(Config.DEBUG_MODE || UserDataMng.mUserIsVIP)
               {
                  DCDebug.setFullWindow(!DCDebug.getFullWindow());
               }
         }
         if((this.mKeyboardInputEnabled || Config.DEBUG_MODE || UserDataMng.mUserIsVIP) && this.mFsmCurrentState != null)
         {
            this.mFsmCurrentState.onKeyDown(e);
         }
      }
      
      public function toggleFullScreen() : String
      {
         var state:String = this.mStage.getDisplayState();
         var str:String = " currentState = " + state;
         var newState:String = state == "fullScreenInteractive" ? "normal" : "fullScreenInteractive";
         str += " newState = " + newState;
         this.mStage.setDisplayState(newState);
         this.mStage.setScaleMode("noScale");
         DCDebug.trace("Toggling fullscreen " + str);
         return this.mStage.getDisplayState();
      }
      
      protected function onMouseDown(e:MouseEvent) : void
      {
         if(this.mFsmCurrentState != null)
         {
            this.mFsmCurrentState.onMouseDown(e);
         }
      }
      
      protected function onMouseUp(e:MouseEvent) : void
      {
         if(this.mFsmCurrentState != null)
         {
            this.mFsmCurrentState.onMouseUp(e);
         }
      }
      
      protected function onMouseMove(e:MouseEvent) : void
      {
         if(this.mFsmCurrentState != null)
         {
            this.mFsmCurrentState.onMouseMove(e);
         }
      }
      
      protected function onMouseOut(e:MouseEvent) : void
      {
         if(this.mFsmCurrentState != null)
         {
            this.mFsmCurrentState.onMouseOut(e);
         }
      }
      
      protected function onMouseLeave(e:Event) : void
      {
         if(this.mFsmCurrentState != null)
         {
            this.mFsmCurrentState.onMouseLeave(e);
         }
      }
      
      public function onMouseClick(e:MouseEvent) : void
      {
         if(this.mFsmCurrentState != null)
         {
            this.mFsmCurrentState.onMouseClick(e);
         }
         this.lastClickProcess();
      }
      
      public function onMouseOver(e:MouseEvent) : void
      {
         if(this.mFsmCurrentState != null)
         {
            this.mFsmCurrentState.onMouseOver(e);
         }
      }
      
      public function onMouseWheel(e:MouseEvent) : void
      {
         if(this.mFsmCurrentState != null)
         {
            this.mFsmCurrentState.onMouseWheel(e);
         }
      }
      
      public function getPlatformId() : int
      {
         return 0;
      }
      
      public function getPlatformPaidCurrency() : String
      {
         return Config.PLATFORM_PAID_CURRENCY_KEYS[this.getPlatformId()];
      }
      
      public function fsmGetState(id:int) : DCFlowState
      {
         return this.mFsmStates[id];
      }
      
      public function setKeyboardInputEnabled(value:Boolean) : void
      {
         this.mKeyboardInputEnabled = value;
      }
      
      public function getKeyboardInputEnabled() : Boolean
      {
         return this.mKeyboardInputEnabled;
      }
      
      public function getCurrentServerTimeMillis() : Number
      {
         return 0;
      }
      
      public function startResetTargetEvents(targetId:String) : void
      {
      }
      
      public function updateTargetProgressOnServer(info:Object) : void
      {
      }
      
      public function isTutorialCompleted() : Boolean
      {
         return false;
      }
      
      private function bgInit(bgColor:uint) : void
      {
         this.mBgColor = bgColor;
         this.mBgShape = new Sprite();
         this.mBgShape.graphics.beginFill(this.mBgColor);
         this.mBgShape.graphics.drawRect(0,0,smStage.stageWidth,smStage.stageHeight);
         smStage.addChildAt(this.mBgShape,0);
         if(smStage != null)
         {
            smStage.align = "TL";
            smStage.scaleMode = "noScale";
         }
      }
      
      private function bgResize(width:int, height:int) : void
      {
         if(this.mBgShape != null)
         {
            this.mBgShape.width = width;
            this.mBgShape.height = height;
         }
      }
   }
}
