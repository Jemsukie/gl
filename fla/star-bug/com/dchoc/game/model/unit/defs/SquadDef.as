package com.dchoc.game.model.unit.defs
{
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import esparragon.utils.EUtils;
   
   public class SquadDef extends ShipDef
   {
       
      
      private var mWave:String = null;
      
      private var mCaptainSku:String = null;
      
      public function SquadDef()
      {
         super();
      }
      
      private function setWave(value:String) : void
      {
         this.mWave = value;
      }
      
      public function getWave() : String
      {
         return this.mWave;
      }
      
      private function formatWave() : void
      {
         var types:Array = null;
         var i:int = 0;
         var length:int = 0;
         var type:String = null;
         if(this.mWave != null)
         {
            types = this.mWave.split(",");
            i = 0;
            length = int(types.length);
            for(i = 0; i < length; )
            {
               if((type = String(types[i])).indexOf(this.mCaptainSku) > -1)
               {
                  break;
               }
               i++;
            }
            if(i < length)
            {
               types.splice(i,1);
               this.mWave = type;
               for(i = 0; i < length - 1; )
               {
                  this.mWave += "," + types[i];
                  i++;
               }
            }
            else
            {
               DCDebug.traceCh("ASSERT","field \'captainSku\' not defined in squadsDefinitions.xml for sku " + mSku);
            }
         }
      }
      
      private function setCaptainSku(value:String) : void
      {
         this.mCaptainSku = value;
         this.formatWave();
      }
      
      public function getCaptainSku() : String
      {
         return this.mCaptainSku;
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "wave";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setWave(EUtils.xmlReadString(info,attribute));
         }
         attribute = "captainSku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCaptainSku(EUtils.xmlReadString(info,attribute));
         }
      }
      
      override protected function getSigDo() : String
      {
         return "" + this.getWave() + this.getCaptainSku() + super.getSigDo();
      }
   }
}
