package com.dchoc.game.eview.widgets
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweenTimeline;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   
   public class EGamePopup extends ESpriteContainer implements DCIPopup
   {
      
      protected static const BACKGROUND_SKU:String = "background";
      
      protected static const TITLE_SKU:String = "title";
      
      protected static const CLOSE_BUTTON_SKU:String = "closeButton";
      
      protected static const CONTENT_BODY:String = "contentBody";
       
      
      protected var mIsBeingShown:Boolean = false;
      
      protected var mIsStackable:Boolean = false;
      
      protected var mTimeline:GTweenTimeline;
      
      protected var mOpening:Boolean;
      
      protected var mClosing:Boolean;
      
      protected var mShowEffect:int;
      
      protected var mCloseEffect:int;
      
      protected var mVerticalOffset:int = 0;
      
      protected var mSoundAttached:String;
      
      private var mEvent:Object;
      
      private var mShowAnim:Boolean;
      
      private var mShowDarkBackground:Boolean;
      
      private var mLayoutStructureName:String;
      
      private var mBackgroundResourceId:String;
      
      protected var mId:String;
      
      protected var mViewFactory:ViewFactory;
      
      protected var mSkinSku:String;
      
      private var mBodyArea:ELayoutArea;
      
      protected var mFooterArea:ELayoutArea;
      
      protected var mButtonsDic:Dictionary;
      
      private var mButtonsArr:Array;
      
      public function EGamePopup()
      {
         super();
         this.mShowEffect = 0;
         this.mCloseEffect = 0;
         this.mOpening = false;
         this.mClosing = false;
      }
      
      public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         this.mId = popupId;
         this.mViewFactory = viewFactory;
         this.mSkinSku = skinId;
      }
      
      override protected function extendedDestroy() : void
      {
         var key:* = null;
         var i:int = 0;
         this.mViewFactory = null;
         this.mSkinSku = null;
         if(this.mButtonsDic != null)
         {
            for(key in this.mButtonsDic)
            {
               delete this.mButtonsDic[key];
            }
            this.mButtonsDic = null;
         }
         if(this.mButtonsArr != null)
         {
            for(i = 0; i < this.mButtonsArr.length; )
            {
               this.mButtonsArr[i] = null;
               i++;
            }
            this.mButtonsArr = null;
         }
         if(this.mTimeline != null)
         {
            this.mTimeline.end();
            this.mTimeline = null;
         }
         this.mSoundAttached = null;
         this.mEvent = null;
         this.mLayoutStructureName = null;
         this.mBackgroundResourceId = null;
         super.extendedDestroy();
      }
      
      public function setupStructure(layoutStructureName:String, backgroundResourceId:String, title:String, body:ESprite) : void
      {
         this.mLayoutStructureName = layoutStructureName;
         this.mBackgroundResourceId = backgroundResourceId;
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory(this.mLayoutStructureName);
         this.setFooterArea(layoutFactory.getArea("footer"));
         var area:ELayoutArea = layoutFactory.getArea("bg");
         var bkg:ESprite = this.mViewFactory.getEImage(this.mBackgroundResourceId,this.mSkinSku,false,area);
         setLayoutArea(area,true);
         this.setBackground(bkg);
         eAddChild(bkg);
         area = layoutFactory.getArea("body");
         body.layoutApplyTransformations(area);
         bkg.eAddChild(body);
         setContent("contentBody",body);
         var eTitle:ETextField;
         (eTitle = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_title"),"text_title_0")).setText(title);
         bkg.eAddChild(eTitle);
         this.setTitle(eTitle);
         var closeButton:EButton = this.mViewFactory.getButtonClose(this.mSkinSku,layoutFactory.getArea("btn_close"));
         bkg.eAddChild(closeButton);
         this.setCloseButton(closeButton);
         this.setCloseButtonVisible(false);
      }
      
      protected function showStructureLayout() : void
      {
         var layoutFactory:ELayoutAreaFactory = null;
         var doc:DisplayObjectContainer = null;
         if(this.mLayoutStructureName != null)
         {
            layoutFactory = this.mViewFactory.getLayoutAreaFactory(this.mLayoutStructureName);
            doc = layoutFactory.getDisplayObjectContainer();
            addChild(doc);
         }
      }
      
      public function lockPopup(componentId:String = null) : void
      {
         var buttonException:EButton = getContentAsEButton(componentId);
         var button:EButton = this.getCloseButton();
         if(button != null && button != buttonException)
         {
            button.mouseEnabled = false;
         }
         for each(button in this.mButtonsDic)
         {
            if(button != buttonException)
            {
               button.mouseEnabled = false;
            }
         }
      }
      
      public function unlockPopup() : void
      {
         var button:EButton = this.getCloseButton();
         if(button != null)
         {
            button.mouseEnabled = true;
         }
         for each(button in this.mButtonsDic)
         {
            button.mouseEnabled = true;
         }
      }
      
      public function getPopupType() : String
      {
         return this.mId;
      }
      
      public function setPopupType(value:String) : void
      {
         this.mId = value;
      }
      
      public function isPopupBeingShown() : Boolean
      {
         return this.mIsBeingShown;
      }
      
      public function setIsBeingShown(value:Boolean) : void
      {
         this.mIsBeingShown = value;
      }
      
      public function setShowAnim(value:Boolean) : void
      {
         this.mShowAnim = value;
      }
      
      public function getShowAnim() : Boolean
      {
         return this.mShowAnim;
      }
      
      public function setShowDarkBackground(value:Boolean) : void
      {
         this.mShowDarkBackground = value;
      }
      
      public function getShowDarkBackground() : Boolean
      {
         return this.mShowDarkBackground;
      }
      
      public function show(showAnim:Boolean = true) : void
      {
         if(showAnim)
         {
            this.startShowAnim();
         }
         this.setIsBeingShown(true);
      }
      
      public function setSoundAttached(sound:String) : void
      {
         this.mSoundAttached = sound;
      }
      
      public function buttonClicked(e:EEvent) : void
      {
         var buttonsDic:Dictionary = null;
         var sku:String = null;
         var button:EButton = null;
         var o:* = null;
         var buttonPressedSku:* = null;
         var target:ESprite = e != null ? e.getTarget() as ESprite : null;
         if(this.mEvent != null && target != null)
         {
            buttonsDic = this.getButtonsDictionary();
            buttonPressedSku = null;
            for(o in buttonsDic)
            {
               sku = o;
               button = buttonsDic[o] as EButton;
               if(button != null && button == target)
               {
                  buttonPressedSku = sku;
                  break;
               }
            }
            if(buttonPressedSku != null)
            {
               this.sendEventBack(buttonPressedSku);
            }
         }
      }
      
      public function sendEventBack(buttonSku:String) : void
      {
         if(this.mEvent != null)
         {
            this.mEvent.button = buttonSku;
            this.sendEventBackToGUIController();
         }
      }
      
      public function notifyAccept(e:Object) : void
      {
         this.sendEventBack("EventYesButtonPressed");
      }
      
      public function notifyPopupMngClose(e:Object) : void
      {
         if(this.mEvent != null)
         {
            this.mEvent.button = "EventCloseButtonPressed";
            this.sendEventBackToGUIController();
         }
         else
         {
            InstanceMng.getUIFacade().closePopup(this);
         }
      }
      
      protected function sendEventBackToGUIController() : void
      {
         this.mEvent.popup = this;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),this.mEvent,true);
      }
      
      public function close() : void
      {
         this.mShowEffect = -1;
         this.mCloseEffect = -1;
         this.setIsBeingShown(false);
      }
      
      public function notify(e:Object) : Boolean
      {
         if(e.cmd == "NOTIFY_EFFECT_END")
         {
            if(this.mClosing)
            {
               this.mClosing = false;
               InstanceMng.getPopupMng().closePopupDo(this);
               scaleX = 1;
               scaleY = 1;
               alpha = 1;
            }
            else if(this.mOpening)
            {
               this.unlockPopup();
               this.mOpening = false;
               if(Config.USE_SOUNDS && this.mSoundAttached != "")
               {
                  SoundManager.getInstance().playSound(this.mSoundAttached);
               }
            }
         }
         return true;
      }
      
      public function onResize(width:int, height:int) : void
      {
         this.resize();
      }
      
      public function resize() : void
      {
         var stageW:int = InstanceMng.getApplication().stageGetWidth();
         var stageH:int = InstanceMng.getApplication().stageGetHeight();
         x = (stageW - getLogicWidth()) / 2;
         y = (stageH - getLogicHeight()) / 2;
      }
      
      public function getForm() : DisplayObjectContainer
      {
         return this as Sprite;
      }
      
      public function setX(x:Number) : void
      {
         this.x = x;
      }
      
      public function setY(y:Number) : void
      {
         this.y = y;
      }
      
      public function setVerticalOffset(value:int) : void
      {
         this.mVerticalOffset = value;
      }
      
      public function configureEffects(show:int, close:int) : void
      {
         this.mShowEffect = show;
         this.mCloseEffect = close;
      }
      
      public function isStackable() : Boolean
      {
         return this.mIsStackable;
      }
      
      public function setIsStackable(value:Boolean) : void
      {
         this.mIsStackable = value;
      }
      
      protected function startShowAnim() : void
      {
         this.lockPopup();
         this.setTimeline();
         this.showEffect();
         if(this.mTimeline != null)
         {
            this.mTimeline.calculateDuration();
         }
      }
      
      public function startCloseEffect() : void
      {
         this.setTimeline();
         this.closeEffect();
         if(this.mTimeline != null)
         {
            this.mTimeline.calculateDuration();
         }
      }
      
      private function setTimeline() : void
      {
         if(this.mTimeline != null)
         {
            this.mTimeline.end();
         }
         this.mTimeline = new GTweenTimeline(null,0,null,{
            "repeatCount":1,
            "reflect":false
         });
         this.mTimeline.onChange = this.refreshPopupPosition;
      }
      
      protected function showEffect() : void
      {
         this.mOpening = true;
         if(this.mShowEffect < 0)
         {
            this.mShowEffect = 0;
         }
         var tween:GTween = InstanceMng.getPopupEffects().addTween(this.mShowEffect,0,this);
         if(this.mTimeline != null)
         {
            this.mTimeline.addTween(0,tween);
         }
      }
      
      protected function closeEffect() : void
      {
         this.mClosing = true;
         if(this.mCloseEffect < 0)
         {
            this.mCloseEffect = 0;
         }
         var tween:GTween = InstanceMng.getPopupEffects().addTween(this.mCloseEffect,1,this);
         if(this.mTimeline != null)
         {
            this.mTimeline.addTween(0,tween);
         }
      }
      
      private function refreshPopupPosition(tween:GTween) : void
      {
         this.resize();
      }
      
      public function setEvent(e:Object) : void
      {
         e.popup = this;
         this.mEvent = e;
      }
      
      public function getEvent() : Object
      {
         return this.mEvent;
      }
      
      public function refresh() : void
      {
      }
      
      public function getSkinSku() : String
      {
         return this.mSkinSku;
      }
      
      protected function setBackground(value:ESprite) : void
      {
         setContent("background",value);
      }
      
      public function getBackground() : ESprite
      {
         return getContent("background");
      }
      
      protected function setTitle(value:ETextField) : void
      {
         setContent("title",value);
      }
      
      protected function getTitle() : ETextField
      {
         return getContent("title") as ETextField;
      }
      
      public function setTitleText(text:String) : void
      {
         var title:ETextField = this.getTitle();
         if(title != null)
         {
            title.setText(text);
         }
      }
      
      protected function setCloseButton(value:EButton) : void
      {
         setContent("closeButton",value);
      }
      
      public function getCloseButton() : EButton
      {
         return getContent("closeButton") as EButton;
      }
      
      public function setCloseButtonVisible(value:Boolean) : void
      {
         this.getCloseButton().visible = value;
      }
      
      protected function setFooterArea(area:ELayoutArea) : void
      {
         this.mFooterArea = area;
      }
      
      protected function getFooterArea() : ELayoutArea
      {
         return this.mFooterArea;
      }
      
      protected function setBodyArea(area:ELayoutArea) : void
      {
         this.mBodyArea = area;
      }
      
      protected function getBodyArea() : ELayoutArea
      {
         return this.mBodyArea;
      }
      
      public function addButton(sku:String, button:EButton) : void
      {
         var bkg:ESprite = null;
         if(this.mButtonsDic == null)
         {
            this.mButtonsDic = new Dictionary(true);
            this.mButtonsArr = [];
         }
         if(this.mButtonsDic[sku] == null)
         {
            this.mButtonsDic[sku] = button;
            this.mButtonsArr.push(button);
            setContent(sku,button);
            bkg = this.getBackground();
            if(bkg != null)
            {
               bkg.eAddChild(button);
            }
            else
            {
               eAddChild(button);
            }
         }
         this.locateButtons();
      }
      
      public function getButton(sku:String) : EButton
      {
         if(this.mButtonsDic != null)
         {
            return this.mButtonsDic[sku];
         }
         throw new Error("Button " + sku + "doesn\'t exist in popup " + this.mId);
      }
      
      public function removeButton(sku:String) : void
      {
         var button:EButton = null;
         if(this.mButtonsDic != null)
         {
            button = this.mButtonsDic[sku];
            if(button != null)
            {
               this.mButtonsArr.splice(this.mButtonsArr.indexOf(button),1);
               delete this.mButtonsDic[sku];
               button.destroy();
               button = null;
               if(this.mButtonsArr.length > 0)
               {
                  this.locateButtons();
               }
            }
         }
      }
      
      public function removeAllButtons() : void
      {
         var key:* = null;
         if(this.mButtonsDic != null)
         {
            for(key in this.mButtonsDic)
            {
               this.removeButton(key);
            }
         }
      }
      
      public function locateButtons() : void
      {
         var buttonsCount:int = 0;
         var buttonsVector:Vector.<EButton> = null;
         var i:int = 0;
         if(this.mFooterArea != null && this.mButtonsArr != null && this.mViewFactory != null)
         {
            buttonsCount = int(this.mButtonsArr.length);
            buttonsVector = new Vector.<EButton>(buttonsCount,true);
            for(i = 0; i < buttonsCount; )
            {
               buttonsVector[i] = this.mButtonsArr[i];
               i++;
            }
            this.mViewFactory.distributeButtons(buttonsVector,this.mFooterArea,false);
         }
      }
      
      protected function getButtonsDictionary() : Dictionary
      {
         return this.mButtonsDic;
      }
   }
}
