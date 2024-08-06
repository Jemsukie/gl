package com.dchoc.game.eview.hud
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.hud.EWarBarSpecialBox;
   import com.dchoc.game.model.items.RewardObject;
   import com.dchoc.game.model.items.SpecialAttacksDef;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EWarBarMercenariesBox extends EWarBarSpecialBox
   {
      
      private static const AREA_BG:String = "area_mercenaries";
      
      private static const CONTAINER_MERCENARIES:String = "item_btn_l";
      
      private static const BUTTON:String = "ibtn_xs";
      
      private static const ICON_DAMAGE:String = "icon_damage";
      
      private static const TEXT_DAMAGE:String = "text_damage";
      
      private static const TEXT_DAMAGE_VALUE:String = "text_damage_value";
      
      private static const ICON_HEALTH:String = "icon_health";
      
      private static const TEXT_HEALTH:String = "text_health";
      
      private static const TEXT_HEALTH_VALUE:String = "text_health_value";
       
      
      private var mUseBtn:EButton;
      
      private var mPayBtn:EButton;
      
      public function EWarBarMercenariesBox(rewardObjectRef:RewardObject)
      {
         super(rewardObjectRef);
         mIconSize = "large";
         this.buildLayout(InstanceMng.getViewFactory().getLayoutAreaFactory("LayoutHudBottomMercenaries"));
      }
      
      protected function buildLayout(layoutAreaFactory:ELayoutAreaFactory) : void
      {
         var totalDamage:int = 0;
         var totalHealth:int = 0;
         var unit:UnitDef = null;
         var s:ESprite;
         var viewFactory:ViewFactory;
         (s = (viewFactory = InstanceMng.getViewFactory()).getEImage("units_box",null,false,layoutAreaFactory.getArea("area_mercenaries"))).name = "area_mercenaries";
         eAddChildAt(s,0);
         setContent(s.name,s);
         super.build(layoutAreaFactory.getArea("item_btn_l"));
         (s = viewFactory.getEImage("icon_damage",null,false,layoutAreaFactory.getArea("icon_damage"))).name = "icon_damage";
         eAddChild(s);
         setContent(s.name,s);
         var txt:ETextField = viewFactory.getETextField(null,layoutAreaFactory.getTextArea("text_damage"),"text_title");
         txt.setText(DCTextMng.getText(539));
         txt.name = "text_damage";
         eAddChild(txt);
         setContent(txt.name,txt);
         txt = viewFactory.getETextField(null,layoutAreaFactory.getTextArea("text_damage_value"),"text_title_3");
         txt.setText(DCTextMng.getText("..."));
         txt.name = "text_damage_value";
         eAddChild(txt);
         setContent(txt.name,txt);
         (s = viewFactory.getEImage("icon_health",null,false,layoutAreaFactory.getArea("icon_health"))).name = "icon_health";
         eAddChild(s);
         setContent(s.name,s);
         txt = viewFactory.getETextField(null,layoutAreaFactory.getTextArea("text_health"),"text_title");
         txt.setText(DCTextMng.getText(543));
         txt.name = "text_health";
         eAddChild(txt);
         setContent(txt.name,txt);
         txt = viewFactory.getETextField(null,layoutAreaFactory.getTextArea("text_health_value"),"text_title_3");
         txt.setText(DCTextMng.getText("..."));
         txt.name = "text_health_value";
         eAddChild(txt);
         setContent(txt.name,txt);
         var mercenaryUnits:Vector.<UnitDef> = new Vector.<UnitDef>(0);
         var specialAttackDefs:Vector.<DCDef> = InstanceMng.getSpecialAttacksDefMng().getDefsShowInMercenariesBar();
         if(specialAttackDefs == null || specialAttackDefs.length == 0)
         {
            return;
         }
         InstanceMng.getUnitScene().wavesGetUnitDefsFromString((specialAttackDefs[0] as SpecialAttacksDef).getWave(),true,mercenaryUnits);
         totalDamage = 0;
         totalHealth = 0;
         for each(unit in mercenaryUnits)
         {
            totalDamage += unit.getShotDamage();
            totalHealth += unit.getMaxEnergy();
         }
         getContentAsETextField("text_damage_value").setText(totalDamage.toString());
         getContentAsETextField("text_health_value").setText(totalHealth.toString());
      }
   }
}
