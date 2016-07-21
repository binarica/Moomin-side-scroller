package
{
	import flash.display.Stage;

	public class Snufkin
	{
		public var graf:MC_Snufkin;
		
		public var vel:Number = 5;
		
		public var stage:Stage;
		
		public function Snufkin(mainStage:Stage)
		{
			stage = mainStage;	
		}
		
		public function reset(x:int , y:int):void
		{
			graf = new MC_Snufkin();
			stage.addChild(graf);
			graf.x = x;
			graf.y = y;
		}
		
		public function move():void
		{			
			graf.x -= vel;
			//graf.y = Math.sin(graf.x);
			if (graf.x < -graf.width)
			{
				graf.x = stage.stageWidth + graf.width;
				graf.y = random(0, stage.stageHeight);
				vel += 0.025;
			}
		}
		
		public function random (min:int, max:int):int
		{
			var num:int = (Math.random() * (max - min)) + min;
			return num;
		}
	}
}