package com.dchoc.game.eview.popups.investments
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.invests.Invest;
   import com.dchoc.game.model.userdata.UserInfo;
   import esparragon.display.EImage;
   import esparragon.display.EScrollArea;
   import esparragon.display.ESpriteContainer;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   
   public class EInvestTrainees extends ESpriteContainer
   {
       
      
      private var mViewFactory:ViewFactory;
      
      private var mInvestmentsArea:ELayoutArea;
      
      private var mInvestList:Array;
      
      public function EInvestTrainees()
      {
         super();
         this.mViewFactory = InstanceMng.getViewFactory();
      }
      
      public function setup() : void
      {
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("LayoutInvestTrainees");
         this.mInvestmentsArea = layoutFactory.getArea("stripes");
         this.getInvestsBoxes();
      }
      
      public function getInvestsBoxes() : void
      {
         var imgArea:ELayoutArea = null;
         var img:EImage = null;
         var scrollArea:EScrollArea = null;
         this.mInvestList = InstanceMng.getInvestMng().getInvestsUI();
         var count:int = int(this.mInvestList.length);
         if(count == 0)
         {
            (imgArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(this.mInvestmentsArea)).addBehavior(this.mViewFactory.getColorBehavior(16711680));
            img = this.mViewFactory.getEImage("embassy",null,true,imgArea);
            eAddChild(img);
            setContent("advisor",img);
         }
         else
         {
            scrollArea = new EScrollArea();
            scrollArea.build(this.mInvestmentsArea,count,ESpriteContainer,this.locateStripes);
            this.mViewFactory.getEScrollBar(scrollArea);
            setContent("scrollArea",scrollArea);
            eAddChild(scrollArea);
         }
      }
      
      private function locateStripes(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var stripe:EInvestStripe = null;
         var userInfo:UserInfo = null;
         if(rebuild)
         {
            stripe = new EInvestStripe(this);
            spriteReference.eAddChild(stripe);
            spriteReference.setContent("stripe",stripe);
         }
         var accId:String;
         var invest:Invest;
         if((accId = (invest = this.mInvestList[rowOffset]).getAccountId()) != "-1")
         {
            userInfo = InstanceMng.getUserInfoMng().getUserInfoObj(accId,0);
         }
         if(userInfo == null)
         {
            userInfo = InstanceMng.getUserInfoMng().getUserInfoObj(invest.getExtId(),1);
         }
         (stripe = spriteReference.getChildAt(0) as EInvestStripe).setup(userInfo,invest);
      }
   }
}
