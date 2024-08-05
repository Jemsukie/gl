package com.dchoc.game.eview.widgets.hud
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.smallStructures.IconBar;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.world.World;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.layout.ELayoutAreaFactory;
   import flash.utils.Dictionary;
   
   public class EHudLootingInformation extends ESpriteContainer
   {
      
      public static const MODE_LOOTING_BACKWARDS:Boolean = true;
      
      private static const AREA_BKG:String = "container_enemy";
      
      private static const AREA_PROFILE:String = "profile_basic";
      
      private static const AREA_BAR_COINS:String = "container_bars_coins";
      
      private static const AREA_BAR_MINERALS:String = "container_bars_minerals";
      
      private static const AREA_BAR_SCORE:String = "container_bars_score";
      
      public static const MODE_BATTLE:int = 0;
      
      public static const MODE_PREVIEW:int = 1;
       
      
      private var mMode:int = 0;
      
      private var mLoot:Dictionary;
      
      private var mCoinsBar:IconBar;
      
      private var mMineralsBar:IconBar;
      
      private var mScoreBar:IconBar;
      
      public function EHudLootingInformation()
      {
         super();
      }
      
      public function build(viewFactory:ViewFactory, skinSku:String, userInfo:UserInfo, mode:int) : void
      {
         this.mMode = mode;
         var layout:ELayoutAreaFactory = viewFactory.getLayoutAreaFactory("LayoutHudLootingInfo");
         var s:ESprite = viewFactory.getEImage("tooltip_bkg",skinSku,false,layout.getArea("container_enemy"));
         eAddChild(s);
         setContent("container_enemy",s);
         (s = viewFactory.getProfileInfoBasic(userInfo)).setLayoutArea(layout.getArea("profile_basic"),true);
         eAddChild(s);
         setContent("profile_basic",s);
         this.mCoinsBar = viewFactory.getIconBar(layout.getArea("container_bars_coins"),"IconBarHudMNoBtn","color_coins","icon_coin");
         this.mMineralsBar = viewFactory.getIconBar(layout.getArea("container_bars_minerals"),"IconBarHudMNoBtn","color_minerals","icon_mineral");
         this.mScoreBar = viewFactory.getIconBar(layout.getArea("container_bars_score"),"IconBarHudMNoBtn","color_score","icon_score");
         eAddChild(this.mCoinsBar);
         eAddChild(this.mMineralsBar);
         eAddChild(this.mScoreBar);
         setContent("container_bars_coins",this.mCoinsBar);
         setContent("container_bars_minerals",this.mMineralsBar);
         setContent("container_bars_score",this.mScoreBar);
      }
      
      public function setUserInfo(userInfo:UserInfo) : void
      {
         (getContent("profile_basic") as EHudProfileBasicView).setUserInfo(userInfo);
      }
      
      public function setMode(mode:int) : void
      {
         this.mMode = mode;
      }
      
      public function setLootingInfo(world:World) : void
      {
         var value:int = 0;
         this.mLoot = world.getMaxAmountLootable();
         var totalScoreAttack:Number = InstanceMng.getFlowStatePlanet().getTotalScoreAttack();
         if(!this.mLoot)
         {
            return;
         }
         value = int(true || this.mMode == 1 ? int(this.mLoot["damageCoins"]) : 0);
         this.mCoinsBar.updateText(DCTextMng.convertNumberToString(value,-1,-1),"text_coins");
         this.mCoinsBar.setBarMaxValue(this.mLoot["damageCoins"]);
         this.mCoinsBar.setBarCurrentValue(int(this.mLoot["damageCoins"]));
         value = int(true || this.mMode == 1 ? int(this.mLoot["damageMinerals"]) : 0);
         this.mMineralsBar.updateText(DCTextMng.convertNumberToString(value,-1,-1),"text_minerals");
         this.mMineralsBar.setBarMaxValue(this.mLoot["damageMinerals"]);
         this.mMineralsBar.setBarCurrentValue(int(this.mLoot["damageMinerals"]));
         this.mScoreBar.updateText(DCTextMng.convertNumberToString(this.mMode == 1 ? totalScoreAttack : 0,-1,-1),"text_score");
         this.mScoreBar.setBarMaxValue(totalScoreAttack);
         this.mScoreBar.setBarCurrentValue(0);
      }
      
      public function setCoins(coins:Number) : void
      {
         var currentValue:Number = NaN;
         if(this.mCoinsBar)
         {
            currentValue = this.mMode == 0 ? coins : 0;
            if(true)
            {
               currentValue = this.mLoot["damageCoins"] - currentValue;
            }
            this.mCoinsBar.setBarCurrentValue(currentValue);
            this.mCoinsBar.updateText(DCTextMng.convertNumberToString(currentValue,-1,-1),"text_coins");
         }
      }
      
      public function setMinerals(minerals:Number) : void
      {
         var currentValue:Number = NaN;
         if(this.mMineralsBar)
         {
            currentValue = this.mMode == 0 ? minerals : 0;
            if(true)
            {
               currentValue = this.mLoot["damageMinerals"] - currentValue;
            }
            this.mMineralsBar.setBarCurrentValue(currentValue);
            this.mMineralsBar.updateText(DCTextMng.convertNumberToString(currentValue,-1,-1),"text_minerals");
         }
      }
      
      public function setScore(score:Number) : void
      {
         if(this.mScoreBar)
         {
            this.mScoreBar.updateText(DCTextMng.convertNumberToString(score,-1,-1),"text_score");
            this.mScoreBar.setBarCurrentValue(this.mMode == 0 ? int(score) : 0);
         }
      }
   }
}
