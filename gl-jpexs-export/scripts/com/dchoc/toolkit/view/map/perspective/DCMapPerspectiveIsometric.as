package com.dchoc.toolkit.view.map.perspective
{
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class DCMapPerspectiveIsometric implements DCMapPerspective
   {
       
      
      private var mTheta:Number;
      
      private var mAlpha:Number;
      
      private var mSinTheta:Number;
      
      private var mCosTheta:Number;
      
      private var mSinAlpha:Number;
      
      private var mCosAlpha:Number;
      
      public function DCMapPerspectiveIsometric(declination:Number = 30)
      {
         super();
         this.setDeclination(declination);
      }
      
      private function setDeclination(declination:Number = 30) : void
      {
         this.mTheta = declination;
         this.mAlpha = 45;
         this.mTheta *= 3.141592653589793 / 180;
         this.mAlpha *= 3.141592653589793 / 180;
         this.mSinTheta = Math.sin(this.mTheta);
         this.mCosTheta = Math.cos(this.mTheta);
         this.mSinAlpha = Math.sin(this.mAlpha);
         this.mCosAlpha = Math.cos(this.mAlpha);
      }
      
      public function mapToScreen(coor:DCCoordinate) : DCCoordinate
      {
         var yp:Number = coor.y;
         var xp:Number = coor.x * this.mCosAlpha + coor.z * this.mSinAlpha;
         var zp:Number = coor.z * this.mCosAlpha - coor.x * this.mSinAlpha;
         coor.x = xp;
         coor.y = yp * this.mCosTheta - zp * this.mSinTheta;
         coor.z = 0;
         return coor;
      }
      
      public function screenToMap(coor:DCCoordinate) : DCCoordinate
      {
         coor.z = (coor.x / this.mCosAlpha - coor.y / (this.mSinAlpha * this.mSinTheta)) * (1 / (this.mCosAlpha / this.mSinAlpha + this.mSinAlpha / this.mCosAlpha));
         coor.x = 1 / this.mCosAlpha * (coor.x - coor.z * this.mSinAlpha);
         coor.y = 0;
         return coor;
      }
      
      public function getMapAnchorX(mapViewWidth:int) : int
      {
         return -(mapViewWidth >> 1);
      }
      
      public function getTileAnchorX(tileViewWidth:int) : int
      {
         return -(tileViewWidth >> 1);
      }
      
      public function getTopLeftOfCenterScreen(mapViewWidth:int, mapViewHeight:int, stageWidth:int, stageHeight:int, coor:DCCoordinate = null) : DCCoordinate
      {
         if(coor == null)
         {
            coor = new DCCoordinate();
         }
         coor.x = stageWidth >> 1;
         coor.y = stageHeight - mapViewHeight >> 1;
         return coor;
      }
   }
}
