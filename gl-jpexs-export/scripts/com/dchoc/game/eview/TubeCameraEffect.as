package com.dchoc.game.eview
{
   import com.dchoc.game.core.instance.InstanceMng;
   import esparragon.display.ESprite;
   import esparragon.resources.EResourcesMng;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class TubeCameraEffect extends ESprite
   {
      
      private static const RENDER_ASSET_IDS:Vector.<String> = new <String>["gui_replay_texture_anim","gui_replay_texture"];
       
      
      private var stageWidth:int;
      
      private var stageHeight:int;
      
      private var bmp:BitmapData;
      
      private var anim:Sprite;
      
      private var animY:Number = 0;
      
      private var totalTime:int;
      
      private var renderIsReady:Boolean;
      
      public function TubeCameraEffect()
      {
         super();
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.anim = new Sprite();
         addChild(this.anim);
      }
      
      public function load() : void
      {
         this.totalTime = 5000;
         visible = true;
         alpha = 1;
         this.renderIsReady = this.areAllAssetsLoaded(true);
      }
      
      private function areAllAssetsLoaded(doRequest:Boolean) : Boolean
      {
         var assetId:String = null;
         var i:int = 0;
         var returnValue:Boolean = true;
         var eResourcesMng:EResourcesMng = InstanceMng.getEResourcesMng();
         var groupId:String = "legacy";
         var length:int = int(RENDER_ASSET_IDS.length);
         for(i = 0; i < length; )
         {
            assetId = RENDER_ASSET_IDS[i];
            if(!eResourcesMng.isAssetLoaded(assetId,groupId))
            {
               returnValue = false;
               if(doRequest)
               {
                  eResourcesMng.loadAsset(assetId,groupId,-1,this.onAssetLoadedSuccess);
               }
            }
            i++;
         }
         return returnValue;
      }
      
      private function onAssetLoadedSuccess(assetId:String, groupId:String) : void
      {
         var _loc3_:* = assetId;
         if("gui_replay_texture_anim" === _loc3_)
         {
            this.bmp = InstanceMng.getEResourcesMng().getAssetBitmapData(assetId,groupId);
         }
         this.renderIsReady = this.areAllAssetsLoaded(false);
      }
      
      private function redraw() : void
      {
         graphics.clear();
         graphics.beginBitmapFill(InstanceMng.getEResourcesMng().getAssetBitmapData("gui_replay_texture","legacy"));
         graphics.drawRect(0,0,this.stageWidth,this.stageHeight);
         graphics.endFill();
      }
      
      public function update(dt:Number) : void
      {
         if(!this.renderIsReady)
         {
            return;
         }
         this.totalTime -= dt;
         if(this.totalTime <= 0)
         {
            visible = false;
            return;
         }
         if(this.totalTime < 1500)
         {
            alpha = this.totalTime / 1500;
         }
         var nwidth:int = InstanceMng.getApplication().stageGetWidth();
         var nheight:int = InstanceMng.getApplication().stageGetHeight();
         if(nwidth != this.stageWidth || nheight != this.stageHeight)
         {
            this.stageWidth = nwidth;
            this.stageHeight = nheight;
            this.redraw();
         }
         var matrix:Matrix;
         (matrix = new Matrix()).translate(0,this.animY);
         this.animY += dt / 25;
         this.anim.graphics.clear();
         this.anim.graphics.beginBitmapFill(this.bmp,matrix);
         this.anim.graphics.drawRect(0,0,this.stageWidth,this.stageHeight);
         this.anim.graphics.endFill();
      }
   }
}
