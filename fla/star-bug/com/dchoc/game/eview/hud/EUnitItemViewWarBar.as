package com.dchoc.game.eview.hud
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.hangar.EUnitItemView;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import esparragon.events.EEvent;
   import flash.utils.Dictionary;
   
   public class EUnitItemViewWarBar extends EUnitItemView
   {
       
      
      private var mIsToggled:Boolean;
      
      public function EUnitItemViewWarBar()
      {
         super();
         this.mIsToggled = false;
      }
      
      override protected function setupButtons() : void
      {
         this.mouseChildren = false;
         this.eAddEventListener("click",this.onClick);
         this.eAddEventBehavior("Disable",InstanceMng.getBehaviorsMng().getMouseBehavior("Disable"));
         this.eAddEventBehavior("Enable",InstanceMng.getBehaviorsMng().getMouseBehavior("Enable"));
      }
      
      override protected function setupMouseEvents() : void
      {
         this.eAddEventListener("rollOver",this.onMouseOver);
         this.eAddEventListener("rollOut",onMouseOut);
         this.eAddEventBehavior("Disable",InstanceMng.getBehaviorsMng().getMouseBehavior("MouseOutSimulated"));
      }
      
      public function unSelect() : void
      {
         this.setToggled(false);
      }
      
      public function setToggled(value:Boolean) : void
      {
         if(this.mIsToggled == value)
         {
            return;
         }
         this.mIsToggled = value;
         if(this.mIsToggled)
         {
            this.applySkinProp(null,"active");
         }
         else
         {
            this.unapplySkinProp(null,"active");
         }
      }
      
      private function onClick(evt:EEvent) : void
      {
         this.setToggled(!this.mIsToggled);
         this.sendClickedEvent();
      }
      
      public function sendClickedEvent() : void
      {
         var params:Dictionary = new Dictionary();
         params["unitSku"] = this.mBaseItemSku;
         params["name"] = this.name;
         params["selected"] = this.mIsToggled;
         MessageCenter.getInstance().sendMessage("warBarUnitClicked",params);
      }
      
      override protected function onMouseOver(evt:EEvent) : void
      {
         ETooltipMng.getInstance().createTooltipInfoFromShipDef(mItemDef,this);
      }
   }
}
