package;



import hxlpers.colors.ColorComponent;
import hxlpers.colors.RndColor;
import hxlpers.effects.ScreenPixelEffect;
import hxlpers.effects.ScreenWhiteNoiseEffect;
import hxlpers.game.Game;
import hxlpers.game.Place;
import hxlpers.Rnd;
import hxlpers.shapes.BoxShape;
import hxlpers.shapes.DiskShape;
import hxlpers.shapes.ShortcutShape;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;

using hxlpers.display.DisplayObjectSF;
using hxlpers.display.BitmapDataSF;
using hxlpers.effects.BitmapDataPixelEffectSF;
/**
 * ...
 * @author damrem
 */
class Main extends Sprite 
{
	static inline var NOISE_ALPHA:Float = 0.05;
	static inline var RATIO:UInt = 3;

	
	
	var noiseEffect:ScreenWhiteNoiseEffect;
	var place:Place;
	
	
	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, onStage);
	}
	
	
	private function onStage(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onStage);
		
		//var w = stage.stageWidth / RATIO;
		//var h = stage.stageHeight / RATIO;
		
		var game = new Game(stage.stageWidth, stage.stageHeight, RATIO);
		addChild(game);
		
		
		//game.addPlace("other", new OtherPlace(stage.stageWidth, stage.stageHeight, RATIO));
		//game.addPlace("one", new OnePlace(stage.stageWidth, stage.stageHeight, RATIO));
		//game.addPlace("walking", new WalkingPlace(stage.stageWidth, stage.stageHeight, RATIO));
		game.addPlace("tilesheet", new TileSheetPlace(stage.stageWidth, stage.stageHeight, 3));
		
		
		noiseEffect = new ScreenWhiteNoiseEffect(stage.stageWidth, stage.stageHeight, 1);
		noiseEffect.scale(RATIO);
		noiseEffect.alpha = NOISE_ALPHA;
		
		
		
		addChild(noiseEffect);
		
		
		var pxFx = new ScreenPixelEffect(stage.stageWidth, stage.stageHeight, Assets.getBitmapData("img/px3-3.png"));
		pxFx.alpha = 0.125;
		addChild(pxFx);
		
		
		
		addChild(new FPS(10, 10, 0xffffff));
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
		
		
	

}

