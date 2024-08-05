package com.dchoc.toolkit.view.screens
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.resources.ResourcesMng;
   import com.dchoc.toolkit.core.component.DCComponentUI;
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.mng.DCViewMng;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.view.gui.components.DCFillBar;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.resources.EResourcesMng;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class DCScreenLoadingBar extends DCComponentUI
   {
      
      protected static const LAYER_LOADING:String = "layer1";
      
      protected static const START_GAME_AT_99_PERCENT_TIMEOUT:int = 10000;
       
      
      private var mIsDone:Boolean;
      
      protected var mLoadingSku:String;
      
      protected var mDOLoadingMain:DCDisplayObject;
      
      protected var mDOLoadingFillBar:DCFillBar;
      
      private var mViewMng:DCViewMng;
      
      private var mProgressSpeed:int = 10;
      
      private var mLoadingClassName:String;
      
      private var mStartGameAt99PercentTimer:int = 0;
      
      private var mPercentTarget:int;
      
      private var mPercentCurrentValue:int;
      
      public function DCScreenLoadingBar(progressSpeed:int = 10, className:String = "")
      {
         super();
         this.mProgressSpeed = progressSpeed;
         this.mDOLoadingMain = null;
         this.mDOLoadingFillBar = null;
         this.mLoadingClassName = className;
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 1;
         this.mStartGameAt99PercentTimer = 0;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         var assetId:String = null;
         var eResourcesMng:EResourcesMng = null;
         if(step == 0)
         {
            assetId = this.getLoadingAssetId();
            eResourcesMng = InstanceMng.getEResourcesMng();
            if(!eResourcesMng.isAssetLoaded(assetId,"legacy"))
            {
               eResourcesMng.loadAsset(assetId,"legacy");
            }
         }
      }
      
      override protected function unloadDo() : void
      {
         this.mViewMng = null;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var eResourcesMng:ResourcesMng = null;
         var assetId:String = null;
         var container:DisplayObjectContainer = null;
         var viewFactory:ViewFactory = null;
         var layoutFactory:ELayoutAreaFactory = null;
         var field:ETextField = null;
         var tf:TextField = null;
         if(step == 0)
         {
            eResourcesMng = InstanceMng.getEResourcesMng();
            assetId = this.getLoadingAssetId();
            if(eResourcesMng.isAssetLoaded(assetId,"legacy"))
            {
               this.mDOLoadingMain = eResourcesMng.getDCDisplayObject(assetId,"legacy",this.mLoadingClassName,0);
               if(this.mDOLoadingMain != null)
               {
                  container = this.mDOLoadingMain.getDisplayObject() as DisplayObjectContainer;
                  this.mDOLoadingFillBar = new DCFillBar(container.getChildByName("Fill_Bar") as MovieClip,0,100);
                  if((viewFactory = InstanceMng.getViewFactory()) != null)
                  {
                     layoutFactory = viewFactory.getLayoutAreaFactoryFromDisplayObjectContainer(container);
                     (field = viewFactory.getETextField(null,layoutFactory.getTextArea("Text_Title"),"text_title_1")).setText(DCTextMng.langListGetLoadingStr());
                     container.addChild(field);
                     tf = container.getChildByName("Text_Title") as TextField;
                     if(tf != null)
                     {
                        tf.visible = false;
                     }
                     (field = viewFactory.getETextField(null,layoutFactory.getTextArea("tip"),"text_title_1")).name = "Etip";
                     container.addChild(field);
                     tf = container.getChildByName("tip") as TextField;
                     if(tf != null)
                     {
                        tf.visible = false;
                        field.setTextColor(tf.textColor);
                     }
                  }
                  buildAdvanceSyncStep();
               }
            }
         }
      }
      
      private function getLoadingAssetId() : String
      {
         return InstanceMng.getLoadingMng().getLoadingAssetId(this.mLoadingSku);
      }
      
      public function getTipTextfield() : ETextField
      {
         var container:DisplayObjectContainer = null;
         var returnValue:ETextField = null;
         if(this.mDOLoadingMain != null)
         {
            container = this.mDOLoadingMain.getDisplayObject() as DisplayObjectContainer;
            if(container != null)
            {
               returnValue = container.getChildByName("Etip") as ETextField;
            }
         }
         return returnValue;
      }
      
      public function showTips(index:int = 0) : void
      {
         var tipTextfield:ETextField = this.getTipTextfield();
         if(tipTextfield != null)
         {
            tipTextfield.setText(InstanceMng.getLoadingMng().getTipForCurrentLoadingBar(this.mLoadingSku,index));
         }
      }
      
      override protected function unbuildDo() : void
      {
         this.mDOLoadingMain = null;
         this.mDOLoadingFillBar = null;
      }
      
      override protected function beginDo() : void
      {
         this.percentBegin();
         this.mIsDone = false;
         this.logicUpdateDo(0);
         this.mViewMng.addChildToLayer(this.mDOLoadingMain,"layer1");
      }
      
      override protected function endDo() : void
      {
         this.mViewMng.removeChildFromLayer(this.mDOLoadingMain,"layer1");
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var barPercentPerResources:int = 0;
         if(!this.mIsDone)
         {
            this.mIsDone = this.mPercentCurrentValue == 100;
            barPercentPerResources = DCMath.ruleOf3(DCInstanceMng.getInstance().getResourceMng().progressGetImmediateCompletePercent(),100,50);
            if(this.mPercentCurrentValue == 99 && barPercentPerResources == 49)
            {
               this.mStartGameAt99PercentTimer += dt;
               if(this.mStartGameAt99PercentTimer >= 10000)
               {
                  this.mIsDone = true;
               }
            }
            if(this.mIsDone)
            {
               this.hideLoadingElements();
            }
            if(this.mPercentCurrentValue < this.mPercentTarget)
            {
               this.mPercentCurrentValue += this.mProgressSpeed;
               if(this.mPercentCurrentValue > this.mPercentTarget)
               {
                  this.mPercentCurrentValue = this.mPercentTarget;
               }
               this.mDOLoadingFillBar.setValueWithoutBarAnimation(this.mPercentCurrentValue);
            }
         }
      }
      
      private function hideLoadingElements() : void
      {
         var container:DisplayObjectContainer = this.mDOLoadingMain.getDisplayObject() as DisplayObjectContainer;
         var dO:DisplayObject = container.getChildByName("Text_Title");
         if(dO != null)
         {
            dO.visible = false;
         }
         dO = container.getChildByName("anim_loading");
         if(dO != null)
         {
            dO.visible = false;
         }
      }
      
      public function setViewMng(value:DCViewMng) : void
      {
         this.mViewMng = value;
      }
      
      public function setLoadingSku(sku:String) : void
      {
         if(this.mLoadingSku != null)
         {
            unload();
         }
         this.mLoadingSku = sku;
      }
      
      public function getIsDone() : Boolean
      {
         return this.mIsDone;
      }
      
      private function percentBegin() : void
      {
         this.mPercentCurrentValue = -1;
         this.mPercentTarget = 0;
      }
      
      public function percentSetTarget(percent:int) : void
      {
         if(percent > this.mPercentTarget)
         {
            this.mPercentTarget = percent;
         }
      }
      
      public function percentGetCurrentValue() : int
      {
         return this.mPercentCurrentValue;
      }
      
      public function percentSetCurrentValue(percent:int) : void
      {
         this.mPercentCurrentValue = percent;
         if(this.mDOLoadingFillBar != null)
         {
            this.mDOLoadingFillBar.setValueWithoutBarAnimation(this.mPercentCurrentValue);
         }
      }
      
      override public function onResize(stageWidth:int, stageHeight:int) : void
      {
         if(this.mDOLoadingMain != null)
         {
            this.mDOLoadingMain.x = stageWidth >> 1;
            this.mDOLoadingMain.y = stageHeight >> 1;
         }
      }
   }
}
