package com.dchoc.game.model.alliances
{
   public class AlliancesAPINewsEvent extends AlliancesAPIEvent
   {
       
      
      private var mAlliancesNews:Vector.<AlliancesNew>;
      
      public function AlliancesAPINewsEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      public function setup(news:Vector.<AlliancesNew>, totalNews:uint) : void
      {
         count = totalNews;
         this.mAlliancesNews = news;
      }
      
      public function getAlliancesNews() : Vector.<AlliancesNew>
      {
         return this.mAlliancesNews;
      }
   }
}
