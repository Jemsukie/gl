package com.dchoc.game.model.space
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class Planet extends DCComponent
   {
       
      
      private var mName:SecureString;
      
      private var mOwnerAccId:SecureString;
      
      private var mFree:SecureBoolean;
      
      private var mParentGalaxySku:SecureString;
      
      private var mParentSolarSystemSku:SecureString;
      
      private var mParentSolarSystemName:SecureString;
      
      private var mParentSolarSystemType:SecureInt;
      
      private var mParentSolarSystemId:SecureNumber;
      
      private var mSku:SecureString;
      
      private var mIsNPC:SecureBoolean;
      
      private var mHQLevel:SecureInt;
      
      private var mIsCapital:SecureBoolean;
      
      private var mDamageProtection:SecureNumber;
      
      private var mURLImg:SecureString;
      
      private var mType:SecureString;
      
      private var mPlanetId:SecureString;
      
      private var mColonyIdx:SecureInt;
      
      private var mReserved:SecureBoolean;
      
      private var mNotBuilt:SecureBoolean;
      
      public function Planet()
      {
         mName = new SecureString("Planet.mName");
         mOwnerAccId = new SecureString("Planet.mOwnerAccId");
         mFree = new SecureBoolean("Planet.mFree",true);
         mParentGalaxySku = new SecureString("Planet.mParentGalaxySku");
         mParentSolarSystemSku = new SecureString("Planet.mParentSolarSystemSku");
         mParentSolarSystemName = new SecureString("Planet.mParentSolarSystemName");
         mParentSolarSystemType = new SecureInt("Planet.mParentSolarSystemType");
         mParentSolarSystemId = new SecureNumber("Planet.mParentSolarSystemId");
         mSku = new SecureString("Planet.mSku");
         mIsNPC = new SecureBoolean("Planet.mIsNPC");
         mHQLevel = new SecureInt("Planet.mHQLevel");
         mIsCapital = new SecureBoolean("Planet.mIsCapital");
         mDamageProtection = new SecureNumber("Planet.mDamageProtection");
         mURLImg = new SecureString("Planet.mURLImg");
         mType = new SecureString("Planet.mType");
         mPlanetId = new SecureString("Planet.mPlanetId");
         mColonyIdx = new SecureInt("Planet.mColonyIdx");
         mReserved = new SecureBoolean("Planet.mReserved");
         mNotBuilt = new SecureBoolean("Planet.mNotBuilt");
         super();
      }
      
      public function destroy() : void
      {
         this.mName.value = null;
         this.mOwnerAccId.value = null;
         this.mParentGalaxySku.value = null;
         this.mParentSolarSystemSku.value = null;
         this.mParentSolarSystemName.value = null;
         this.mSku.value = null;
         this.mURLImg.value = null;
         this.mType.value = null;
         this.mPlanetId.value = null;
      }
      
      public function setName(name:String) : void
      {
         this.mName.value = name;
      }
      
      public function setAccIdOwner(value:String) : void
      {
         this.mOwnerAccId.value = value;
         var uInfoOther:UserInfo = InstanceMng.getUserInfoMng().getUserInfoObj(this.mOwnerAccId.value,0,3);
         if(uInfoOther != null)
         {
            this.mIsNPC.value = true;
         }
      }
      
      public function setIsFree(value:Boolean) : void
      {
         this.mFree.value = value;
      }
      
      public function setHQLevel(value:int) : void
      {
         this.mHQLevel.value = value;
      }
      
      public function setIsCapital(value:Boolean) : void
      {
         this.mIsCapital.value = value;
      }
      
      public function setDamageProtection(value:Number) : void
      {
         this.mDamageProtection.value = value;
      }
      
      public function setSku(sku:String) : void
      {
         var coords:Array = null;
         this.mSku.value = sku;
         if(this.mSku.value != null)
         {
            coords = this.mSku.value.split(":");
            this.mParentSolarSystemSku.value = coords[0] + ":" + coords[1];
         }
      }
      
      public function setParentStarName(name:String) : void
      {
         this.mParentSolarSystemName.value = name;
      }
      
      public function getParentStarName() : String
      {
         return this.mParentSolarSystemName.value;
      }
      
      public function setParentStarType(type:int) : void
      {
         this.mParentSolarSystemType.value = type;
      }
      
      public function getParentStarType() : int
      {
         return this.mParentSolarSystemType.value;
      }
      
      public function setParentStarId(id:Number) : void
      {
         this.mParentSolarSystemId.value = id;
      }
      
      public function getParentStarId() : Number
      {
         return this.mParentSolarSystemId.value;
      }
      
      public function getIsAttackable() : Boolean
      {
         var attackObject:Object = InstanceMng.getApplication().createIsAttackableObject(this.mOwnerAccId.value,this);
         return attackObject.lockType.length == 0 && !InstanceMng.getFlowStatePlanet().isTutorialRunning();
      }
      
      public function getFilter(mouseOver:Boolean = false) : Array
      {
         var filter:Array = null;
         var friendly:Boolean = false;
         if(this.mIsNPC.value)
         {
            friendly = InstanceMng.getUserInfoMng().getIsNPCFriendlyByAccId(this.mOwnerAccId.value);
            if(friendly == true)
            {
               filter = mouseOver == true ? [GameConstants.FILTER_GLOW_RED_HIGH] : [GameConstants.FILTER_GLOW_RED_LOW];
            }
            else
            {
               filter = null;
               if(InstanceMng.getFlowStatePlanet().isTutorialRunning())
               {
                  filter = mouseOver == true ? [GameConstants.FILTER_GLOW_GREEN_HIGH] : [GameConstants.FILTER_GLOW_GREEN_LOW];
               }
            }
         }
         if(filter == null)
         {
            if(this.getIsAttackable())
            {
               filter = mouseOver == true ? [GameConstants.FILTER_GLOW_GREEN_HIGH] : [GameConstants.FILTER_GLOW_GREEN_LOW];
            }
            else
            {
               filter = mouseOver == true ? [GameConstants.FILTER_GLOW_RED_HIGH] : [GameConstants.FILTER_GLOW_RED_LOW];
            }
         }
         return filter;
      }
      
      public function setURL(url:String) : void
      {
         this.mURLImg.value = url;
      }
      
      public function setType(type:String) : void
      {
         this.mType.value = type;
      }
      
      public function setPlanetId(id:String) : void
      {
         this.mPlanetId.value = id;
      }
      
      public function setColonyIdx(idx:int) : void
      {
         this.mColonyIdx.value = idx;
      }
      
      public function setReserved(value:Boolean) : void
      {
         this.mReserved.value = value;
      }
      
      public function setNotBuilt(value:Boolean) : void
      {
         this.mNotBuilt.value = value;
      }
      
      public function setInfoFromVars(accId:String, id:String, sku:String, hqlevel:int) : void
      {
         this.setAccIdOwner(accId);
         var user:UserInfo;
         if((user = InstanceMng.getUserInfoMng().getUserInfoObj(accId,0)) != null)
         {
            this.setURL(user.mThumbnailURL);
         }
         this.setPlanetId(id);
         this.setSku(sku);
         this.setHQLevel(hqlevel);
         var colonyIdx:int;
         if((colonyIdx = parseInt(id) - 1) < 0)
         {
            colonyIdx = 0;
         }
         this.setColonyIdx(colonyIdx);
         this.setIsCapital(colonyIdx == 0);
         this.setName(this.getStringId());
      }
      
      public function getSku() : String
      {
         return this.mSku.value;
      }
      
      public function getName() : String
      {
         return this.mName.value;
      }
      
      public function isFree() : Boolean
      {
         return this.mFree.value;
      }
      
      public function getParentGalaxySku() : String
      {
         return this.mParentGalaxySku.value;
      }
      
      public function getParentStarSku() : String
      {
         return this.mParentSolarSystemSku.value;
      }
      
      public function isNPC() : Boolean
      {
         return this.mIsNPC.value;
      }
      
      public function getHQLevel() : int
      {
         return this.mHQLevel.value;
      }
      
      public function isCapital() : Boolean
      {
         return this.mIsCapital.value;
      }
      
      public function getDamageProtection() : Number
      {
         return this.mDamageProtection.value;
      }
      
      public function getOwnerAccId() : String
      {
         return this.mOwnerAccId.value;
      }
      
      public function getURL() : String
      {
         return this.mURLImg.value;
      }
      
      public function getType() : String
      {
         return this.mType.value;
      }
      
      public function getPlanetId() : String
      {
         return this.mPlanetId.value;
      }
      
      public function getStringId() : String
      {
         if(this.isCapital())
         {
            return DCTextMng.getText(2746);
         }
         return DCTextMng.replaceParameters(2747,[DCTextMng.getText(TextIDs["TID_GEN_NUMERICAL_ORDER_" + this.getColonyIdx()])]);
      }
      
      public function getPlanetPosId() : String
      {
         var pos:Array = this.mSku.value.split(":");
         return pos[2];
      }
      
      public function getParentStarCoords() : DCCoordinate
      {
         var coordsArr:Array = null;
         var coord:DCCoordinate = null;
         if(this.mSku.value != "" && this.mSku.value != null)
         {
            coordsArr = this.mSku.value.split(":");
            coord = new DCCoordinate();
            coord.x = coordsArr[0];
            coord.y = coordsArr[1];
         }
         return coord;
      }
      
      public function getParentStartCoordsAsString() : String
      {
         var returnValue:* = "";
         var coor:DCCoordinate = this.getParentStarCoords();
         if(coor != null)
         {
            returnValue = "(" + coor.x + "," + coor.y + ")";
         }
         return returnValue;
      }
      
      public function getColonyIdx() : int
      {
         return this.mColonyIdx.value;
      }
      
      public function isReserved() : Boolean
      {
         return this.mReserved.value;
      }
      
      public function isNotBuilt() : Boolean
      {
         return this.mNotBuilt.value;
      }
      
      public function hasToBeGrayedOut() : Boolean
      {
         return this.mNotBuilt.value && this.getOwnerAccId() != InstanceMng.getUserInfoMng().getProfileLogin().getAccountId();
      }
   }
}
