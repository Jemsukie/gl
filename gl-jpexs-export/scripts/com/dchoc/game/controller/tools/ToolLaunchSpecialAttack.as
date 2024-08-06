package com.dchoc.game.controller.tools
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.items.SpecialAttacksDef;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.view.facade.CursorFacade;
   
   public class ToolLaunchSpecialAttack extends Tool
   {
       
      
      private var mFrameWidth:int = 0;
      
      private var mFrameHeight:int = 0;
      
      private var mDef:SpecialAttacksDef = null;
      
      public function ToolLaunchSpecialAttack(id:int, cursorId:int = -1, actionId:int = -1)
      {
         super(id,true,cursorId,actionId,false);
      }
      
      public function setDef(def:SpecialAttacksDef) : void
      {
         if(def == null)
         {
            this.mFrameWidth = 0;
            this.mFrameHeight = 0;
         }
         else
         {
            this.mFrameWidth = def.getCursorMapFrameTilesWidth();
            this.mFrameHeight = def.getCursorMapFrameTilesHeight();
         }
         this.mDef = def;
      }
      
      override protected function onMouseDoUpCoors(tileX:int, tileY:int) : Boolean
      {
         var tile:TileData = smMapController.getTileDataFromTileXY(tileX,tileY);
         applyRequest(tile);
         return false;
      }
      
      override protected function cursorIsEnabled() : Boolean
      {
         return true;
      }
      
      override protected function applyDo() : void
      {
         if(mApplyOnTile != null && mWhatToDrop != null)
         {
            mWhatToDrop.drop(mApplyOnTile.getCol(),mApplyOnTile.getRow());
         }
      }
      
      override protected function cursorDoIsApplicable(tile:TileData) : Boolean
      {
         return smMapController.isTileXYInMapWithFrame(tile.mCol,tile.mRow,this.mFrameWidth,this.mFrameHeight);
      }
      
      override public function getCursorId() : int
      {
         var cursor:CursorFacade = InstanceMng.getUIFacade().getCursorFacade();
         if(cursor != null && this.mDef != null)
         {
            return cursor.nameToId(this.mDef.getTargetCursor(),mCursorId);
         }
         return mCursorId;
      }
      
      override protected function cursorMove(x:int, y:int, tileX:int, tileY:int) : void
      {
         var cursor:CursorFacade = null;
         var cursorId:int = 0;
         if(mCursorIsBegun)
         {
            if((cursor = InstanceMng.getUIFacade().getCursorFacade()) != null)
            {
               cursorId = smMapController.isTileXYInMapWithFrame(tileX,tileY,this.mFrameWidth,this.mFrameHeight) ? this.getCursorId() : 16;
               cursor.setCursorId(cursorId);
            }
         }
      }
   }
}
