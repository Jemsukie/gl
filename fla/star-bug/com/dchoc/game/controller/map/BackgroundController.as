package com.dchoc.game.controller.map
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.rule.BackgroundDef;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.unit.BattleReplay;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.toolkit.core.component.DCComponent;
   import flash.utils.Dictionary;
   
   public class BackgroundController extends DCComponent
   {
       
      
      private const DEFAULT_SOLAR_SYSTEM_TYPE:String = "-1";
      
      private var mObstaclesDefs:Vector.<WorldItemDef> = null;
      
      private var mObstaclesCatalog:Dictionary = null;
      
      public function BackgroundController()
      {
         super();
      }
      
      public function getBackgroundDefForCurrentSituation() : BackgroundDef
      {
         var replay:BattleReplay = null;
         var uInfo:UserInfo = null;
         var bgDef:BackgroundDef = null;
         var planet:Planet = null;
         var solarSystemType:String = "-1";
         var currProfile:Profile = InstanceMng.getUserInfoMng().getCurrentProfileLoaded();
         var planetIdLoaded:String;
         var isCapital:* = (planetIdLoaded = InstanceMng.getApplication().goToGetCurrentPlanetId()) == "1";
         var roleId:int;
         if((roleId = InstanceMng.getRole().mId) == 7)
         {
            if((replay = InstanceMng.getUnitScene().getReplay()) != null)
            {
               isCapital = (planetIdLoaded = replay.getPlanetId() != "" ? replay.getPlanetId() : planetIdLoaded) == "1";
            }
         }
         if(planetIdLoaded == null || isCapital)
         {
            uInfo = currProfile != null ? currProfile.getUserInfoObj() : null;
            if(uInfo != null && uInfo.mIsNPC.value)
            {
               solarSystemType = currProfile.getUserInfoObj().mBackgroundType;
            }
            else
            {
               solarSystemType = "-1";
            }
         }
         else if(currProfile != null)
         {
            if((planet = currProfile.getUserInfoObj().getPlanetById(planetIdLoaded)) != null)
            {
               solarSystemType = String(planet.getParentStarType());
            }
         }
         return InstanceMng.getBackgroundDefMng().getDefBySolarSystemType(solarSystemType) as BackgroundDef;
      }
      
      public function getBackgroundAssetForCurrentSituation() : String
      {
         var returnValue:String = "";
         var bgDef:BackgroundDef = this.getBackgroundDefForCurrentSituation();
         if(bgDef != null)
         {
            returnValue = bgDef.getBackgroundAsset();
         }
         if(returnValue == "")
         {
            returnValue = "background_animated.swf";
         }
         return returnValue;
      }
      
      public function getAllianceAnimationAssetForCurrentSituation() : String
      {
         var returnValue:* = "";
         var bgDef:BackgroundDef = this.getBackgroundDefForCurrentSituation();
         if(bgDef != null)
         {
            returnValue = bgDef.getAllianceAnimation();
         }
         if(returnValue == "")
         {
            returnValue = "alliance_council";
         }
         return "assets/flash/background/animations/alliance_council/" + returnValue + ".swf";
      }
      
      public function getInvestsAnimPath(isAnimation:Boolean = false) : String
      {
         var assetName:String = null;
         var investsLocked:Boolean = false;
         if(isAnimation == false)
         {
            assetName = (investsLocked = InstanceMng.getInvestMng().areInvestsLocked()) || InstanceMng.getMapViewPlanet().getIsInvestAnimRunning() ? "wio_invest_building" : "wio_invest_ready";
         }
         else
         {
            assetName = "wio_invest_unlocking_anim";
         }
         var roleId:int = InstanceMng.getFlowState().getCurrentRoleId();
         if(roleId == 7 || roleId == 3 || roleId == 2 || roleId == 1)
         {
            assetName = "wio_invest_ready";
         }
         return assetName;
      }
      
      public function geInvestsBubbleSpeechPath() : String
      {
         return InstanceMng.getResourceMng().getCommonResourceFullPath("invest_bubble_speech");
      }
      
      public function getObstaclesForCurrentBackground() : Vector.<WorldItemDef>
      {
         var obstacleDef:WorldItemDef = null;
         var backgroundsSkusAllowed:Vector.<String> = null;
         var bgSku:String = null;
         var obstacleSku:String = null;
         var tokens:Array = null;
         var token:String = null;
         var list:Vector.<WorldItemDef> = null;
         var i:int = 0;
         var returnValue:Vector.<WorldItemDef> = null;
         if(this.mObstaclesDefs == null)
         {
            this.mObstaclesDefs = InstanceMng.getMapModel().getRebornObstaclesAvailable();
            if(this.mObstaclesCatalog == null)
            {
               this.mObstaclesCatalog = new Dictionary();
            }
            bgSku = "";
            for each(obstacleDef in this.mObstaclesDefs)
            {
               backgroundsSkusAllowed = obstacleDef.getBackgroundSkusAllowed();
               for each(bgSku in backgroundsSkusAllowed)
               {
                  if(this.mObstaclesCatalog[bgSku] == null)
                  {
                     this.mObstaclesCatalog[bgSku] = new Vector.<WorldItemDef>(0);
                  }
                  Vector.<WorldItemDef>(this.mObstaclesCatalog[bgSku]).push(obstacleDef);
               }
            }
         }
         var bgDef:BackgroundDef = this.getBackgroundDefForCurrentSituation();
         if(bgDef != null)
         {
            obstacleSku = bgDef.getObstaclesSku();
            if(obstacleSku != null)
            {
               if(this.mObstaclesCatalog[obstacleSku] == null)
               {
                  returnValue = new Vector.<WorldItemDef>(0);
                  tokens = obstacleSku.split(",");
                  for each(token in tokens)
                  {
                     if((list = this.mObstaclesCatalog[token]) != null)
                     {
                        for(i = list.length - 1; i > -1; )
                        {
                           returnValue.push(list[i]);
                           i--;
                        }
                     }
                  }
                  this.mObstaclesCatalog[obstacleSku] = returnValue;
               }
               else
               {
                  returnValue = this.mObstaclesCatalog[obstacleSku];
               }
            }
         }
         return returnValue;
      }
      
      public function getSpaceBgSkuByMapView(view:String) : String
      {
         var returnValue:String = "";
         if(view != null)
         {
            switch(view)
            {
               case "background_galaxy":
                  returnValue = "assets/flash/space_maps/backgrounds/background_galaxy.swf";
                  break;
               case "background_space_star_v2":
                  returnValue = "assets/flash/space_maps/backgrounds/solar_system_2_5.swf";
            }
         }
         return returnValue;
      }
   }
}
