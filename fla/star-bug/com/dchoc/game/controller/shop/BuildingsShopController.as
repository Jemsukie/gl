package com.dchoc.game.controller.shop
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemDefMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.def.DCDef;
   
   public class BuildingsShopController extends DCComponent
   {
      
      private static const PATH_BASE:String = "pngs_shop_";
      
      public static const PATH_DECORATIONS:String = "pngs_shop_decorations/";
      
      public static const PATH_DEFENSES:String = "pngs_shop_defenses/";
      
      public static const PATH_DROIDS:String = "pngs_shop_droids/";
      
      public static const PATH_HOUSES:String = "pngs_shop_houses/";
      
      public static const PATH_LABS:String = "pngs_shop_laboratories/";
      
      public static const PATH_RESOURCES:String = "pngs_shop_factories/";
      
      public static const PATH_SHIPYARDS:String = "pngs_shop_shipyards/";
      
      public static const PATH_TERRAFORMER:String = "pngs_shop_expansions/";
      
      private static const TEXTID_HOUSES:int = 522;
      
      private static const TEXTID_DECORATIONS:int = 524;
      
      private static const TEXTID_DEFENSES:int = 527;
      
      private static const TEXTID_SHIPYARDS:int = 530;
      
      private static const TEXTID_LABS:int = 533;
      
      private static const GROUP_HOUSES_ID:String = "0";
      
      private static const GROUP_DEFENSES_ID:String = "1";
      
      private static const GROUP_ATTACK_ID:String = "2";
      
      private static const GROUP_MINES_ID:String = "3";
      
      private static const GROUP_DECORATIONS_ID:String = "4";
      
      private static const GROUP_LABORATORIES_ID:String = "5";
      
      private static const GROUP_BUILDERS_ID:String = "6";
      
      public static const SHOPTAB_HOUSES:String = "houses_button";
      
      public static const SHOPTAB_DEFENSES:String = "defenses_button";
      
      public static const SHOPTAB_ATTACK:String = "shipyard_button";
      
      public static const SHOPTAB_DECORATIONS:String = "decorations_button";
      
      public static const SHOPTAB_LABORATORIES:String = "laboratories_button";
       
      
      private var mWorldItemDefMngRef:WorldItemDefMng;
      
      private var mShopTab:String;
      
      private var mIsShopOpen:Boolean;
      
      public function BuildingsShopController()
      {
         super();
      }
      
      public function getShopTab() : String
      {
         return this.mShopTab;
      }
      
      public function setShopTab(value:String) : void
      {
         this.mShopTab = value;
      }
      
      public function isShopOpen() : Boolean
      {
         return this.mIsShopOpen;
      }
      
      public function setShopOpen(value:Boolean) : void
      {
         this.mIsShopOpen = value;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.mWorldItemDefMngRef = InstanceMng.getWorldItemDefMng();
         }
      }
      
      public function getShopResourcesInfo(types:String = null) : Vector.<DCDef>
      {
         var def:WorldItemDef = null;
         var doPush:Boolean = false;
         var ret:Vector.<DCDef> = null;
         if(types == null)
         {
            if(this.mShopTab == "decorations_button")
            {
               types = "4";
            }
            else if(this.mShopTab == "defenses_button")
            {
               types = "1";
            }
            else if(this.mShopTab == "houses_button")
            {
               types = "0";
            }
            else if(this.mShopTab == "laboratories_button")
            {
               types = "5";
            }
            else if(this.mShopTab == "shipyard_button")
            {
               types = "2";
            }
            if(types == null)
            {
               return null;
            }
         }
         var v:Vector.<DCDef> = this.mWorldItemDefMngRef.getDefsFromTypes(types);
         var arr:Array = [];
         var planet:Planet;
         var isCapital:Boolean = (planet = InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getUserInfoObj().getPlanetById(InstanceMng.getApplication().goToGetCurrentPlanetId())) != null && planet.isCapital();
         for each(def in v)
         {
            if(def.getUpgradeId() == 0)
            {
               doPush = !def.isCapitalOnly() || isCapital;
               def.mSortCriteria = def.getShopOrder();
               if(doPush &&= def.mSortCriteria > -1)
               {
                  arr.push(def);
               }
            }
         }
         arr.sortOn("mSortCriteria",16);
         return DCUtils.array2VectorDCDef(arr);
      }
      
      public function getResourcePath(flaFolder:String) : String
      {
         if(this.mShopTab == "decorations_button")
         {
            return "pngs_shop_decorations/";
         }
         if(this.mShopTab == "defenses_button")
         {
            return "pngs_shop_defenses/";
         }
         if(this.mShopTab == "droids_button")
         {
            return "pngs_shop_droids/";
         }
         if(this.mShopTab == "houses_button")
         {
            if(flaFolder == "houses")
            {
               return "pngs_shop_houses/";
            }
            if(flaFolder == "minerals")
            {
               return "pngs_shop_factories/";
            }
         }
         if(this.mShopTab == "laboratories_button")
         {
            return "pngs_shop_laboratories/";
         }
         if(this.mShopTab == "shipyard_button")
         {
            return "pngs_shop_shipyards/";
         }
         return "";
      }
      
      public function getShopTabTitle(tab:String = null) : String
      {
         if(tab == null)
         {
            tab = this.mShopTab;
         }
         if(tab == "decorations_button")
         {
            return DCTextMng.getText(524);
         }
         if(tab == "defenses_button")
         {
            return DCTextMng.getText(527);
         }
         if(tab == "houses_button")
         {
            return DCTextMng.getText(522);
         }
         if(tab == "laboratories_button")
         {
            return DCTextMng.getText(533);
         }
         if(tab == "shipyard_button")
         {
            return DCTextMng.getText(530);
         }
         return "";
      }
      
      public function toolChangeAfterPlaceItem(wio:WorldItemObject) : Boolean
      {
         return true;
      }
      
      public function notifyChangeShop() : void
      {
         InstanceMng.getTargetMng().updateProgress("changeShop",1);
      }
   }
}
