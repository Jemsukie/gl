package com.dchoc.game.model.unit
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.items.SpecialAttacksDef;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import esparragon.utils.EUtils;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class BattleReplay
   {
       
      
      private var mBattleMaxDuration:Number;
      
      public var mPlanetId:String;
      
      private var xml:XML;
      
      private var deploys:Vector.<Deploy>;
      
      private var units:Dictionary;
      
      private var currentDeploy:int;
      
      private var mTimer:Number;
      
      private var mEnabled:Boolean;
      
      public function BattleReplay()
      {
         this.deploys = new Vector.<Deploy>(0);
         this.units = new Dictionary();
         super();
      }
      
      public function startReplay(xml:XML) : void
      {
         var planetId:String = null;
         var d:Deploy = null;
         var deployXML:XML = null;
         var attackerAccountId:String = null;
         var deployGroupXML:XML = null;
         var lastDeploy:Deploy = null;
         if(xml.children().length() == 0)
         {
            return;
         }
         this.xml = xml;
         var planetXML:XML = EUtils.xmlGetChildrenListAsXML(EUtils.xmlGetChildrenListAsXML(EUtils.xmlGetChildrenListAsXML(EUtils.xmlGetChildrenListAsXML(xml,"Universe"),"Profile"),"Planets"),"Planet");
         for each(var attr in EUtils.xmlGetAttributesAsXMLList(planetXML))
         {
            if(attr.name() == "planetId")
            {
               planetId = EUtils.xmlReadString(planetXML,attr.name());
            }
         }
         if(planetId != null)
         {
            this.mPlanetId = planetId;
         }
         this.deploys.length = 0;
         var deploysXML:XML = EUtils.xmlGetChildrenListAsXML(xml,"Deploys");
         var attribute:String = "battleTime";
         if(EUtils.xmlIsAttribute(deploysXML,attribute))
         {
            this.mBattleMaxDuration = EUtils.xmlReadNumber(deploysXML,attribute);
         }
         else
         {
            this.mBattleMaxDuration = DCTimerUtil.minToMs(7);
         }
         for each(deployXML in EUtils.xmlGetChildrenList(deploysXML,"deploy"))
         {
            d = new Deploy();
            d.time = EUtils.xmlReadNumber(deployXML,"time");
            d.unit = this.getUnit(EUtils.xmlReadString(deployXML,"sku"));
            d.coord = new Point(EUtils.xmlReadNumber(deployXML,"x"),EUtils.xmlReadNumber(deployXML,"y"));
            this.deploys.push(d);
         }
         if(this.deploys.length > 0)
         {
            this.deploys.sort(this.deploySort);
            lastDeploy = this.deploys[this.deploys.length - 1];
            this.nextDeploy();
            this.mEnabled = true;
         }
         for each(deployGroupXML in deploysXML)
         {
            attackerAccountId = EUtils.xmlReadString(deployGroupXML,"accountId");
         }
         InstanceMng.getUserInfoMng().setAttacker(attackerAccountId);
      }
      
      public function getBattleMaxDuration() : Number
      {
         return this.mBattleMaxDuration;
      }
      
      public function getPlanetId() : String
      {
         return this.mPlanetId;
      }
      
      private function nextDeploy() : void
      {
         if(this.currentDeploy >= this.deploys.length)
         {
            return;
         }
         var previousDeployTime:int = int(this.currentDeploy == 0 ? 0 : this.deploys[this.currentDeploy - 1].time);
         var interval:int = this.deploys[this.currentDeploy].time - previousDeployTime;
         if(interval == 0)
         {
            this.deploy();
         }
         else
         {
            this.mTimer = interval;
         }
      }
      
      private function deploy() : void
      {
         var sku:String = null;
         var unitScene:UnitScene = null;
         var moveCamera:Boolean = false;
         var skuSpecialAttack:String = null;
         if(InstanceMng.getRole().mId != 7 || this.currentDeploy >= this.deploys.length)
         {
            return;
         }
         var d:Deploy = this.deploys[this.currentDeploy];
         if(this.deployIsAllowed(d))
         {
            sku = d.unit.sku;
            unitScene = InstanceMng.getUnitScene();
            if(sku.indexOf("specialAttack") > -1)
            {
               unitScene.battleEventsNotifyDeploySpecialAttack(convertSpecialAttackSku(d.unit.sku),d.coord.x,d.coord.y);
            }
            else if(sku != "finished")
            {
               unitScene.battleEventsNotifyDeployWave("1:" + sku + ":" + d.unit.upgradeId,d.coord.x,d.coord.y,1);
            }
            if(this.currentDeploy == 0)
            {
               moveCamera = true;
               if(sku.indexOf("specialAttack") > -1)
               {
                  skuSpecialAttack = String(convertSpecialAttackSku(sku).split("_")[1]);
                  if((InstanceMng.getSpecialAttacksDefMng().getDefBySku(skuSpecialAttack) as SpecialAttacksDef).getType() == "battle_time")
                  {
                     moveCamera = false;
                  }
               }
               if(moveCamera)
               {
                  InstanceMng.getMapControllerPlanet().moveCameraTo(d.coord.x,d.coord.y,0.5);
               }
            }
            this.currentDeploy++;
            this.nextDeploy();
         }
      }
      
      private function deployIsAllowed(d:Deploy) : Boolean
      {
         var returnValue:Boolean = true;
         if(d.unit.sku == "finished")
         {
            returnValue = InstanceMng.getUnitScene().battleFinishIsAllowed();
         }
         return returnValue;
      }
      
      private function battleFinish() : void
      {
         InstanceMng.getUnitScene().battleFinish();
         this.cancel();
      }
      
      public function cancel() : void
      {
         this.mEnabled = false;
         this.mPlanetId = "";
      }
      
      private function deploySort(a:Deploy, b:Deploy) : Number
      {
         if(a.time > b.time)
         {
            return 1;
         }
         if(a.time < b.time)
         {
            return -1;
         }
         return 0;
      }
      
      private function getUnit(sku:String) : GameUnitInternal
      {
         var unitXML:XML = null;
         var unit:GameUnitInternal = null;
         if(this.units[sku] != null)
         {
            return this.units[sku];
         }
         var gameUnits:XMLList = EUtils.xmlGetChildrenList(EUtils.xmlGetChildrenListAsXML(this.xml,"AttackerGameUnits"),"GameUnit");
         for each(unitXML in gameUnits)
         {
            if(EUtils.xmlReadString(unitXML,"sku") == sku)
            {
               unit = new GameUnitInternal();
               unit.sku = sku;
               unit.upgradeId = EUtils.xmlReadInt(unitXML,"upgradeId");
               unit.unlocked = EUtils.xmlReadBoolean(unitXML,"unlocked");
               unit.timeLeft = EUtils.xmlReadNumber(unitXML,"timeLeft");
               this.units[sku] = unit;
               return unit;
            }
         }
         unit = new GameUnitInternal();
         unit.sku = sku;
         this.units[sku] = unit;
         return unit;
      }
      
      private function convertSpecialAttackSku(sku:String) : String
      {
         var returnValue:String = "specialAttack_";
         var realSku:String = String(sku.split("_")[1]);
         switch(realSku)
         {
            case "7000":
               returnValue += "1";
               break;
            case "7001":
               returnValue += "2";
               break;
            case "7002":
               returnValue += "3";
               break;
            case "7003":
               returnValue += "4";
               break;
            case "7200":
               returnValue += "10";
               break;
            default:
               returnValue += realSku;
         }
         return returnValue;
      }
      
      public function isEnabled() : Boolean
      {
         return this.mEnabled;
      }
      
      public function logicUpdate(dt:int) : void
      {
         if(this.mEnabled)
         {
            this.mTimer -= dt;
            if(this.mTimer <= 0)
            {
               this.deploy();
            }
         }
      }
      
      public function areDeploysLeft() : Boolean
      {
         return this.currentDeploy < this.deploys.length;
      }
      
      public function getXML() : XML
      {
         return this.xml;
      }
   }
}

import flash.geom.Point;

class Deploy
{
    
   
   public var time:int;
   
   public var coord:Point;
   
   public var unit:GameUnitInternal;
   
   public function Deploy()
   {
      super();
   }
   
   public function toString() : String
   {
      return this.unit + " " + this.coord.toString() + " " + this.time.toString();
   }
}

class GameUnitInternal
{
    
   
   public var sku:String;
   
   public var upgradeId:int;
   
   public var unlocked:Boolean;
   
   public var timeLeft:int;
   
   public function GameUnitInternal()
   {
      super();
   }
   
   public function toString() : String
   {
      return this.sku + " " + this.upgradeId.toString() + " " + this.unlocked.toString() + " " + this.timeLeft.toString();
   }
}
