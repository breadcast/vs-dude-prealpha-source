package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

class YesState extends MusicBeatState
{
	public static var firstStart:Bool = true;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('brothatwasmadfunny'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		var txt:FlxText;
		txt = new FlxText(0, 0, FlxG.width,
			"DISCLAIMER:\n" +
			'This mod is pre-alpha\n\n' +
			'meaning this is unfinished and may contain alot of bugs\n' +
			'Also there are no easy or normal charts xdxd\n\n' +
			'chart errors because i dont know how to do very long notes',
		32);
		
		
		txt.setFormat("Comic Sans MS Bold", 32, FlxColor.fromRGB(200, 200, 200), CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}
		
		super.update(elapsed);
	}
}