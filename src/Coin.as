package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	
	public class Coin
	{		
		public var graf:MC_Emerald;
		public var vel:Number = 1.5;
		
		public var stage:Stage;
		
		public function Coin(mainStage:Stage)
		{
			stage = mainStage;
		}
		
		public function reset(x:int , y:int):void
		{
			if (graf == null)
			{
				graf = new MC_Emerald();
				stage.addChild(graf);
				graf.x = x;
				graf.y = y;
			}
			else
			{
				graf.x = x;
				graf.y = y;
			}
		}
		
		public function move():void
		{			
			graf.x -= vel;
		}
	}
}