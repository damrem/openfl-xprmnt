package halo;
import halo.Halo;
import hxlpers.colors.ColorComponent;
import hxlpers.colors.RGBColor;
import hxlpers.colors.RndColor;
import hxlpers.game.Place;
import hxlpers.Rnd;
import hxlpers.shapes.BoxShape;
import hxlpers.shapes.DiskShape;
import hxlpers.shapes.ShortcutShape;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
using hxlpers.display.ShapeSF;
using hxlpers.display.SpriteSF;
using hxlpers.display.BitmapDataSF;

/**
 * ...
 * @author damrem
 */
class HaloPlace extends Place
{
	var entities:Array<Sprite>;
	var nbShapes:UInt = 100;

	var halo:Halo;
	var halo2:Halo;
	
	var maskLayer:Sprite;
	var maskRendering:BitmapData;
	var maskBuffer:ByteArray;
	
	var maskedLayer:Sprite;
	var maskedRendering:BitmapData;
	var maskedBuffer:ByteArray;
	
	var finalBuffer:ByteArray;
	var finalRendering:BitmapData;
	
	
	public function new(fullWidth:Float, fullHeight:Float, ratio:UInt) 
	{
		trace("new", fullWidth, fullHeight, ratio);
		super(fullWidth, fullHeight, ratio);
		trace(w, h);
		
		
		
		//	the scene
		maskedLayer = createMaskedLayer();
		maskedRendering = new BitmapData(Math.ceil(w), Math.ceil(h), true, 0xFFFFFFFF);
		
		//	the halos
		maskLayer = createMaskLayer();
		maskRendering = new BitmapData(Math.ceil(w), Math.ceil(h), true, 0xFFFFFFFF);
		//addChild(maskLayer);

		addChild(new Bitmap(maskRendering));
		
		finalBuffer = new ByteArray();
		finalRendering = new BitmapData(Math.ceil(w), Math.ceil(h), true, 0x00FFFFFF);
		
		addChild(new Bitmap(finalRendering));
		
		
		var fg = new Sprite();
		fg.rect(w, h);
		fg.alpha = 0;
		fg.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addChild(fg);
		
	}
	
	function createMaskLayer():Sprite
	{
		maskLayer = new Sprite();

		halo = new Halo();
		
		halo2 = new Halo();
		halo2.x = w / 2;
		halo2.y = h / 2;
		
		maskLayer.addChild(halo);
		maskLayer.addChild(halo2);
		
		return maskLayer;
	}
	
	function createMaskedLayer():Sprite
	{
		var maskedLayer = new Sprite();
		
		var bg = new Sprite();
		bg.rect(w, h, RndColor.rgb());
		maskedLayer.addChild(bg);
		
		entities = new Array<Sprite>();
		for (i in 0...nbShapes)
		{
			var size = Math.random() * 25;
			var color = RndColor.rgb(0.25, 0.5);
			var shape:ShortcutShape;
			var sprite = new Sprite();
			
			if (Rnd.chance())
			{
				shape = new DiskShape(size, color);
			}
			else
			{
				shape = new BoxShape(size, size, color);
				shape.rotation = Math.random() * 360;
			}
			sprite.addChild(shape);
			sprite.x = Rnd.float(w);
			sprite.y = Rnd.float(h);
			sprite.buttonMode = true;
			sprite.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			maskedLayer.addChild(sprite);
			entities.push(sprite);
		}
		
		return maskedLayer;
	}
	
	
	private function onMouseMove(e:MouseEvent):Void 
	{
		halo.x = Math.round(e.stageX / ratio);
		halo.y = Math.round(e.stageY / ratio);
	}
	
	function onRollOver(e:MouseEvent):Void 
	{
		cast(e.currentTarget, Sprite).alpha = 0.5;
	}
	
	override public function update()
	{
		for (shape in entities)
		{
			if (Rnd.chance(0.01))
			{
				shape.x += Rnd.float( -1, 1);
				shape.y += Rnd.float( -1, 1);
				//shape.alpha += Rnd.float( -0.1, 0.1);
				shape.rotation += Rnd.float( -5, 5);
			}
		}
		
		//halo2.x += Rnd.float( -1, 1);
		//halo2.y += Rnd.float( -1, 1);
	}
	
	
	override public function render()
	{
		
		maskedRendering.fillRect(maskedRendering.rect, 0xFFFFFFFF);
		maskedRendering.draw(maskedLayer);
		maskedBuffer = maskedRendering.getPixels(maskedRendering.rect);
		maskedBuffer.position = 0;
		
		maskRendering.fillRect(maskRendering.rect, 0x00FFFFFF);// .clear(0);
		maskRendering.draw(maskLayer);
		maskBuffer = maskRendering.getPixels(maskRendering.rect);
		maskBuffer.position = 0;
		
		finalBuffer.clear();
		
		while (finalBuffer.position < maskBuffer.length)
		{
			var a = maskBuffer.readUnsignedInt() & ColorComponent.ALPHA_MASK;
			var rgb = maskedBuffer.readUnsignedInt() & ColorComponent.ALPHA_NEGATIVE;
			finalBuffer.writeUnsignedInt(a | rgb);
		}
		
		finalBuffer.position = 0;
		
		finalRendering.setPixels(finalRendering.rect, finalBuffer);
		super.render();

	}
	
}