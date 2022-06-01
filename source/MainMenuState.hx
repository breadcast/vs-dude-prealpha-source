package;

import flixel.input.gamepad.FlxGamepad;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

import Discord.DiscordClient;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.4" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var broadcastednews:FlxSprite;
	var sidebar:FlxSprite;
	var magenta:FlxSprite;
	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('menuBGalt'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;

		broadcastednews = new FlxSprite(-80).loadGraphic(Paths.image('NEWS'));
		broadcastednews.scrollFactor.x = 0;
		broadcastednews.scrollFactor.y = 0;
		broadcastednews.updateHitbox();
		broadcastednews.screenCenter();
		broadcastednews.y += 1000;
		broadcastednews.antialiasing = true;
		FlxTween.tween(broadcastednews,{y: broadcastednews.y - 1000}, 1 ,{ease: FlxEase.expoInOut});

		sidebar = new FlxSprite(-80).loadGraphic(Paths.image('menuSide'));
		sidebar.scrollFactor.x = 0;
		sidebar.scrollFactor.y = 0;
		sidebar.setGraphicSize(Std.int(sidebar.width * 1));
		sidebar.updateHitbox();
		sidebar.screenCenter();
		sidebar.x -= 200;
		sidebar.antialiasing = true;
		FlxTween.tween(sidebar, {x: sidebar.x + 200}, 1, {ease: FlxEase.expoInOut});

		if (FlxG.save.data.lol) {
			add(bg);
			add(sidebar);
			add(broadcastednews);
		} else {
			var bg2:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('menuBG'));
			bg2.scrollFactor.x = 0;
			bg2.scrollFactor.y = 0.10;
			bg2.setGraphicSize(Std.int(bg.width * 1.1));
			bg2.updateHitbox();
			bg2.screenCenter();
			bg2.antialiasing = true;
			add(bg2);
			remove(broadcastednews);
			remove(sidebar);
		}


		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			if (FlxG.save.data.lol) {
				var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
				menuItem.frames = tex;
				menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = i;
				menuItem.screenCenter(X);
				menuItems.add(menuItem);
				menuItem.scale.set(0.7, 0.7);
				menuItem.scrollFactor.set(0, 0.15);
				menuItem.antialiasing = FlxG.save.data.antialiasing;
				if (firstStart)
					FlxTween.tween(menuItem,{y: 60 + (i * 160)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
						{ 
							finishedFunnyMove = true; 
							changeItem();
						}});
				else
					menuItem.y = 60 + (i * 160);
			} else {
				var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1.6);
				menuItem.frames = tex;
				menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = i;
				menuItem.screenCenter(X);
				menuItems.add(menuItem);
				menuItem.scrollFactor.set();
				menuItem.antialiasing = true;
				if (firstStart)
					FlxTween.tween(menuItem,{y: 60 + (i * 160)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
						{ 
							finishedFunnyMove = true; 
							changeItem();
						}});
				else
					menuItem.y = 60 + (i * 160);
			}
		}

		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " friday night funkin' - " + kadeEngineVer + " Dude Engine (totally not kade engine wdym bro) (cry about it)" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		#if debug
		remove(versionShit);
		var versionShit2:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " friday night funkin' - " + kadeEngineVer + " Dude Engine Developer Build (totally not kade engine wdym bro) (cry about it)" : ""), 12);
		versionShit2.scrollFactor.set();
		versionShit2.setFormat("VCR OSD Mono", 16, FlxColor.RED, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit2);
		#end
		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		menuItems.forEach(function(spr:FlxSprite){
			spr.alpha = 0;
			FlxTween.tween(spr, {alpha:1}, 0.2);
		});


		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.DPAD_UP)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}
				if (gamepad.justPressed.DPAD_DOWN)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}

				if (gamepad.justPressed.DPAD_LEFT)
				{
					PlayState.SONG = Song.loadFromJson(Highscore.formatSong('An Exotic Thing', 2), 'an-exotic-thing');
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = 2;
					LoadingState.loadAndSwitchState(new PlayState());
				}
				if (gamepad.justPressed.DPAD_RIGHT)
				{
					PlayState.SONG = Song.loadFromJson(Highscore.formatSong('accelerant but yes', 2), 'accelerant-but-yes');
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = 2;
					LoadingState.loadAndSwitchState(new PlayState());
				}
			}

			if (FlxG.keys.justPressed.UP)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (FlxG.keys.justPressed.DOWN)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (FlxG.keys.justPressed.LEFT)
			{
				PlayState.SONG = Song.loadFromJson(Highscore.formatSong('An-Exotic-Thing', 2), 'an-exotic-thing');
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = 2;
				LoadingState.loadAndSwitchState(new PlayState());
			}

			if (FlxG.keys.justPressed.RIGHT)
			{
				PlayState.SONG = Song.loadFromJson(Highscore.formatSong('accelerant-but-yes', 2), 'accelerant-but-yes');
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = 2;
				LoadingState.loadAndSwitchState(new PlayState());
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					fancyOpenURL("https://ninja-muffin24.itch.io/funkin");
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
					if (FlxG.save.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
			if (FlxG.save.data.lol) {
				spr.x -= 300;
			} else {
				spr.x -= 0;
			}
		});
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
