package esparragon.resources.textureBuilders.renderStrategy
{
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class ERenderStrategy
   {
       
      
      protected var mSkinSku:String;
      
      private var mOnSuccess:Function;
      
      private var mOnError:Function;
      
      protected var mTilesToLoadAmount:int;
      
      protected var mTilesSuccess:int;
      
      protected var mTilesError:int;
      
      private var mCheckAllTilesLoadedEnabled:Boolean;
      
      public function ERenderStrategy(skinSku:String)
      {
         super();
         this.mSkinSku = skinSku;
      }
      
      public function destroy() : void
      {
         this.mOnSuccess = null;
         this.mOnError = null;
         this.extendedDestroy();
      }
      
      protected function extendedDestroy() : void
      {
      }
      
      public function requestTiles(onSuccess:Function, onError:Function) : void
      {
         this.mOnSuccess = onSuccess;
         this.mOnError = onError;
         this.mTilesToLoadAmount = 0;
         this.mTilesSuccess = 0;
         this.mTilesError = 0;
         this.mCheckAllTilesLoadedEnabled = false;
         this.extendedRequestTiles();
         this.mCheckAllTilesLoadedEnabled = true;
         this.checkAllTilesLoaded();
      }
      
      protected function extendedRequestTiles() : void
      {
      }
      
      public function tilesIsDefined(index:int, ignoreNoTexture:Boolean = false) : Boolean
      {
         return true;
      }
      
      public function tilesGetToLoadAmount() : int
      {
         return this.mTilesToLoadAmount;
      }
      
      public function tilesGetDefinedAmount() : int
      {
         return this.tilesGetToLoadAmount();
      }
      
      protected function onTileLoaded() : void
      {
         this.mTilesSuccess++;
         if(this.mCheckAllTilesLoadedEnabled)
         {
            this.checkAllTilesLoaded();
         }
      }
      
      protected function onTileError() : void
      {
         this.mTilesError++;
         if(this.mCheckAllTilesLoadedEnabled)
         {
            this.checkAllTilesLoaded();
         }
      }
      
      private function areAllTilesLoaded() : Boolean
      {
         return this.mTilesSuccess == this.mTilesToLoadAmount;
      }
      
      private function checkAllTilesLoaded() : void
      {
         var total:int = this.mTilesSuccess + this.mTilesError;
         if(total == this.mTilesToLoadAmount)
         {
            if(this.areAllTilesLoaded())
            {
               this.onAllTilesLoaded();
            }
            else
            {
               this.onNotAllTilesLoaded();
            }
         }
      }
      
      private function onAllTilesLoaded() : void
      {
         if(this.mOnSuccess != null)
         {
            this.mOnSuccess();
         }
      }
      
      private function onNotAllTilesLoaded() : void
      {
         if(this.mOnError != null)
         {
            this.mOnError();
         }
      }
      
      protected function tilesGetBitmapData(index:int) : BitmapData
      {
         return null;
      }
      
      public function tilesGetWidth(index:int) : int
      {
         return 0;
      }
      
      public function tilesGetHeight(index:int) : int
      {
         return 0;
      }
      
      public function tilesDrawTile(bmp:BitmapData, index:int, matrix:Matrix, smooth:Boolean = true) : void
      {
      }
      
      public function tilesExistTile(index:int) : Boolean
      {
         var bitmapData:BitmapData = this.tilesGetBitmapData(index);
         return bitmapData != null;
      }
   }
}
