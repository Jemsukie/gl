package com.dchoc.game.eview.widgets.hud
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutAreaFactory;
   import flash.filters.GlowFilter;
   import flash.utils.Dictionary;
   
   public class EHudMissionIcon extends ESprite
   {
      
      private static const PROGRESS_TIME_MS:int = 6000;
       
      
      private var mIcon:EImage;
      
      private var mCircle:EImage;
      
      private var mText:ETextField;
      
      private var mMissionSku:String;
      
      private var mLayoutAreaFactory:ELayoutAreaFactory;
      
      private var mLastKnownState:int;
      
      private var mProgressEffectTTL:int;
      
      private var mProgressFilter:GlowFilter;
      
      public function EHudMissionIcon()
      {
         super();
         this.mLayoutAreaFactory = InstanceMng.getViewFactory().getLayoutAreaFactory("IconMissionHud");
         setLayoutArea(this.mLayoutAreaFactory.getAreaWrapper());
         eAddEventListener("click",this.onClick);
         eAddEventListener("rollOver",this.onMouseOver);
         eAddEventListener("rollOut",this.onMouseOut);
         this.mProgressEffectTTL = -1;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var serverTimeMs:Number = NaN;
         var endTime:Number = NaN;
         var timeLeft:Number = NaN;
         var timeText:String = null;
         var filter:Object = null;
         super.logicUpdate(dt);
         var target:DCTarget;
         if((target = InstanceMng.getTargetMng().getTargetById(this.mMissionSku)) == null)
         {
            return;
         }
         this.mCircle.visible = true;
         switch(target.State - 1)
         {
            case 0:
               if(target.State != this.mLastKnownState)
               {
                  this.mText.visible = false;
                  this.applySkinProp(null,"mouse_over_button");
               }
               break;
            case 1:
               if(target.State != this.mLastKnownState)
               {
                  this.unapplySkinProp(null,"mouse_over_button");
               }
               if(target.getEndTime() > -1)
               {
                  serverTimeMs = InstanceMng.getUserDataMng().getServerCurrentTimemillis();
                  if((timeLeft = (endTime = target.getEndTime()) - serverTimeMs) < 0)
                  {
                     timeLeft = 0;
                  }
                  timeText = DCTextMng.convertTimeToStringColon(timeLeft);
                  this.mText.setText(timeText);
                  this.mText.visible = true;
               }
               else
               {
                  this.mText.visible = false;
               }
               break;
            case 2:
            case 3:
               this.removeProgressEffect();
               this.destroy();
         }
         if(this.mProgressEffectTTL >= 0)
         {
            this.mProgressEffectTTL -= dt;
            for each(filter in this.mFilters)
            {
               if(filter is GlowFilter)
               {
                  this.removeFilter(this.mProgressFilter);
                  GlowFilter(filter).alpha = 0.5 - Math.cos(this.mProgressEffectTTL / 250) / 2;
                  this.addFilter(this.mProgressFilter);
               }
            }
            if(this.mProgressEffectTTL < 0)
            {
               this.removeProgressEffect();
            }
         }
         this.mLastKnownState = target.State;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this.mIcon)
         {
            this.mIcon.destroy();
            this.mIcon = null;
         }
         if(this.mText)
         {
            this.mText.destroy();
            this.mText = null;
         }
         this.mMissionSku = null;
      }
      
      public function setMissionSku(sku:String) : void
      {
         var target:DCTarget = InstanceMng.getTargetMng().getTargetById(sku);
         if(target)
         {
            this.mMissionSku = sku;
            this.reloadIcon();
         }
      }
      
      public function getMissionSku() : String
      {
         return this.mMissionSku;
      }
      
      public function addProgressEffect() : void
      {
         if(this.mFilters == null)
         {
            this.mFilters = [];
         }
         if(this.mFilters.indexOf(this.mProgressFilter) == -1)
         {
            this.mProgressFilter = new GlowFilter(16777215,1,8,8,2,2);
            this.addFilter(this.mProgressFilter);
         }
         this.mProgressEffectTTL = 6000;
      }
      
      public function removeProgressEffect() : void
      {
         this.removeFilter(this.mProgressFilter);
         this.mProgressEffectTTL = -1;
      }
      
      private function onClick(evt:EEvent) : void
      {
         var params:Dictionary = null;
         if(this.mMissionSku != null)
         {
            params = new Dictionary();
            params["sku"] = this.mMissionSku;
            MessageCenter.getInstance().sendMessage("hudMissionClicked",params);
            this.reloadIcon();
         }
      }
      
      private function onMouseOver(evt:EEvent) : void
      {
         var target:DCTarget = null;
         if(this.mMissionSku != null)
         {
            target = InstanceMng.getTargetMng().getTargetById(this.getMissionSku());
            if(target.State == 1)
            {
               ETooltipMng.getInstance().createTooltipInfoFromText(DCTextMng.getText(TextIDs[target.getDef().getTargetTitle()]).toUpperCase(),this);
            }
            else
            {
               ETooltipMng.getInstance().createTooltipForMissionProgress(target,this);
            }
         }
      }
      
      private function onMouseOut(evt:EEvent) : void
      {
         ETooltipMng.getInstance().removeCurrentTooltip();
      }
      
      private function reloadIcon() : void
      {
         var target:DCTarget = InstanceMng.getTargetMng().getTargetById(this.mMissionSku);
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var iconSku:String = target.getDef().getAdvisorPresentation();
         if(this.mIcon)
         {
            viewFactory.setTextureToImage(iconSku,"mission_icons",this.mIcon);
         }
         else
         {
            this.mCircle = viewFactory.getEImage("circle",InstanceMng.getSkinsMng().getCurrentSkinSku(),false,this.mLayoutAreaFactory.getArea("icon"));
            this.mIcon = viewFactory.getEImage(iconSku,"mission_icons",false,this.mLayoutAreaFactory.getArea("icon"));
            this.mText = viewFactory.getETextField(InstanceMng.getSkinsMng().getCurrentSkinSku(),this.mLayoutAreaFactory.getTextArea("text"),"text_body");
            this.mText.setText("hola");
            eAddChild(this.mCircle);
            eAddChild(this.mIcon);
            eAddChild(this.mText);
         }
      }
   }
}
