package com.dchoc.game.eview.widgets.hud
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.gskinner.motion.GTween;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   
   public class EHudMissionDropDownSprite extends EArrowDropDownSprite
   {
      
      private static const AREA_MISSIONS:String = "area_missions";
      
      private static const AREA_MISSIONS_CONTENT:String = "area_missions_BKG";
      
      private static const AREA_TAB:String = "missions_label_arrow";
      
      private static const AREA_ARROW:String = "btn_arrow";
       
      
      public function EHudMissionDropDownSprite()
      {
         super(1);
      }
      
      override public function build() : void
      {
         var skinSku:String = null;
         var viewFactory:ViewFactory = null;
         skinSku = InstanceMng.getSkinsMng().getCurrentSkinSku();
         viewFactory = InstanceMng.getViewFactory();
         var layout:ELayoutAreaFactory = viewFactory.getLayoutAreaFactory("MissionDropDownHud");
         var iconsBkgLayout:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layout.getArea("area_missions"),2);
         mIconsContentArea = viewFactory.getESpriteContainer();
         mIconsContentArea.setLayoutArea(layout.getArea("area_missions"),true);
         mIconsArea = viewFactory.getEImage("mission_label",skinSku,false,iconsBkgLayout,null);
         mTabLayoutArea = layout.getArea("missions_label_arrow");
         mTabArea = viewFactory.getEImage("skin_ui_label_corner_bottom",skinSku,false,mTabLayoutArea,null);
         mTabArea.name = "tabArea";
         var area:ELayoutArea = layout.getArea("btn_arrow");
         mArrowLayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(area);
         mArrowLayoutArea.x = mTabLayoutArea.x + mTabLayoutArea.width / 2;
         mArrowLayoutArea.y = mTabLayoutArea.y + mTabLayoutArea.height / 2;
         mArrow = viewFactory.getEImage("skin_icon_arrow",skinSku,false,mArrowLayoutArea,null);
         mArrow.setPivotLogicXY(0.5,0.5);
         mArrow.eAddEventListener("click",onArrowClick);
         mArrowCloseRotation = mArrowLayoutArea.rotation;
         mArrowOpenRotation = mArrowCloseRotation + 180;
         mArrow.eAddEventBehavior("rollOver",InstanceMng.getBehaviorsMng().getMouseBehavior("MouseOverButton"));
         mArrow.eAddEventBehavior("rollOut",InstanceMng.getBehaviorsMng().getMouseBehavior("MouseOutButton"));
         this.eAddChild(mIconsArea);
         this.eAddChild(mIconsContentArea);
         this.eAddChild(mTabArea);
         this.eAddChild(mArrow);
         setContent("area_missions",mIconsArea);
         setContent("area_missions_BKG",mIconsContentArea);
         setContent("missions_label_arrow",mTabArea);
         setContent("btn_arrow",mArrow);
         setContentArea(mIconsContentArea.getLayoutArea());
      }
      
      override public function open(animated:Boolean = true) : void
      {
         super.open(animated);
         MessageCenter.getInstance().sendMessage("missionsDropDownOpen",null);
      }
      
      override protected function onUpdateTween(tween:GTween) : void
      {
         mIconsContentArea.scaleLogicX = mIconsArea.scaleLogicX;
         mIconsContentArea.scaleLogicY = mIconsArea.scaleLogicY;
         var lastY:Number = mTabArea.logicTop;
         setTabAreaY(mIconsArea.height + mIconsArea.logicTop);
         setArrowY(mArrow.logicTop + mTabArea.logicTop - lastY);
      }
      
      public function disable() : void
      {
         getContent("btn_arrow").setIsEnabled(false);
         getContent("area_missions").setIsEnabled(false);
         getContent("missions_label_arrow").setIsEnabled(false);
      }
      
      public function enable() : void
      {
         getContent("btn_arrow").setIsEnabled(true);
         getContent("area_missions").setIsEnabled(true);
         getContent("missions_label_arrow").setIsEnabled(true);
      }
   }
}
