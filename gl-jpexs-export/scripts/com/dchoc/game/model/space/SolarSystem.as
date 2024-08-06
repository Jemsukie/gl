package com.dchoc.game.model.space
{
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class SolarSystem extends DCComponent
   {
       
      
      private var mName:String;
      
      private var mCoordX:Number;
      
      private var mCoordY:Number;
      
      private var mPlanetsAmount:int;
      
      private var mFreePlanetsAmount:int;
      
      private var mOccupiedPlanetsAmount:int;
      
      private var mPlanets:Vector.<Planet>;
      
      private var mType:int;
      
      private var mId:Number;
      
      public function SolarSystem()
      {
         super();
      }
      
      override protected function unloadDo() : void
      {
         this.mName = null;
         this.mPlanets = null;
      }
      
      public function getName() : String
      {
         return this.mName;
      }
      
      public function getCoordX() : Number
      {
         return this.mCoordX;
      }
      
      public function getCoordY() : Number
      {
         return this.mCoordY;
      }
      
      public function getCoords() : DCCoordinate
      {
         var coord:DCCoordinate = new DCCoordinate();
         coord.x = this.mCoordX;
         coord.y = this.mCoordY;
         return coord;
      }
      
      public function getPlanetsAmount() : int
      {
         return this.mPlanetsAmount;
      }
      
      public function getFreePlanetsAmount() : int
      {
         return this.mFreePlanetsAmount;
      }
      
      public function getOccupiedPlanetsAmount() : int
      {
         return this.mOccupiedPlanetsAmount;
      }
      
      public function getPlanets() : Vector.<Planet>
      {
         return this.mPlanets;
      }
      
      public function getType() : int
      {
         return this.mType;
      }
      
      public function getCoordsForIndexing() : String
      {
         return this.mCoordX + "," + this.mCoordY;
      }
      
      public function getId() : Number
      {
         return this.mId;
      }
      
      public function setName(value:String) : void
      {
         this.mName = value;
      }
      
      public function setCoordX(value:Number) : void
      {
         this.mCoordX = value;
      }
      
      public function setCoordY(value:Number) : void
      {
         this.mCoordY = value;
      }
      
      public function setPlanetsAmount(value:Number) : void
      {
         this.mPlanetsAmount = value;
      }
      
      public function setFreePlanetsAmount(value:Number) : void
      {
         this.mFreePlanetsAmount = value;
      }
      
      public function setOccupiedPlanetsAmount(value:Number) : void
      {
         this.mOccupiedPlanetsAmount = value;
      }
      
      public function setPlanets(value:Vector.<Planet>) : void
      {
         this.mPlanets = value;
      }
      
      public function setType(value:int) : void
      {
         this.mType = value;
      }
      
      public function setId(id:Number) : void
      {
         this.mId = id;
      }
      
      public function notifyPlanetBought() : void
      {
         this.mFreePlanetsAmount--;
         this.mOccupiedPlanetsAmount++;
      }
      
      public function notifyPlanetGone() : void
      {
         this.mFreePlanetsAmount++;
         this.mOccupiedPlanetsAmount--;
      }
   }
}
