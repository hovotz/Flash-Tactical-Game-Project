package worlds
{
	import com.hovotz.utilities.TerrainGenerator;
	import flash.display.InteractiveObject;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	import entities.units.Unit;
	import entities.units.Swordman;
	import entities.units.Dragon;
	import entities.units.Archer;
	import entities.units.Ninja;
	import entities.units.Sorceror;
	import entities.units.Witch;
	
	import utilities.cameras.Camera;
	import utilities.builders.Terrain;
	import utilities.builders.TerrainBuilder;
	import utilities.builders.TilemapTerrainBuilderStrategy;
	
	/**
	 * ...
	 * @author Jerome Vergara Rosario
	 */
	public class CombatWorld extends World 
	{
		private var _units:Array;
		private var _inFocus:Unit;
		private var _terrain:Terrain;
		private var _camera:Camera;
		
		public function CombatWorld() 
		{
			_units = new Array();
			
			var terrainBuilder:TerrainBuilder = new TerrainBuilder(new TilemapTerrainBuilderStrategy());
			var terrainGenerator:TerrainGenerator = new TerrainGenerator();
			_terrain = terrainBuilder.build(terrainGenerator.generate(100, 100), 30);
			addTerrain(_terrain);
			
			//_terrain = new Terrain(100, 100, 30);
			//add(_terrain);
			

			createUnits();

			_inFocus = _units[0];
			_camera = new Camera(this, new Rectangle(0, 0, _terrain.width, _terrain.height), _inFocus);
			_camera.focusTarget();
		}
		
		private function addTerrain(terrain:Terrain):void
		{
			var entities:Array = terrain.entities;
			
			for (var i:int = 0; i < entities.length; i++)
			{
				add(entities[i]);
			}
		}
		
		override public function update():void
		{
			if (Input.pressed(Key.TAB))
			{
				switchUnit();
				_camera.target = _inFocus;
				_camera.focusTarget();
			}
			
			if (Input.mousePressed)
			{
				var startCol:int = _inFocus.x / _terrain.cellSize;
				var startRow:int = _inFocus.y / _terrain.cellSize;
				var endCol:int = (this.camera.x + Input.mouseX) / _terrain.cellSize;
				var endRow:int = (this.camera.y + Input.mouseY) / _terrain.cellSize;
				
				if (_terrain.isOccupied(endCol, endRow))
				{
					_terrain.setOccupied(endCol, endRow, false);
					if (_terrain.findPath(startCol, startRow, endCol, endRow))
					{
						_inFocus.path = _terrain.path;
						_inFocus.path.pop();
						_terrain.setOccupied(endCol, endRow, true);
						_inFocus.startWalkByPath();
					}
					else
					{
						trace("Unreachable cell!");
					}
				}
				else if (_terrain.isWalkable(endCol, endRow))
				{
					if (_terrain.findPath(startCol, startRow, endCol, endRow))
					{
						_inFocus.path = _terrain.path;
						_inFocus.startWalkByPath();
					}
					else
					{
						trace("Unreachable cell!");
					}
				}
				else
				{
					trace("tile is unwalkable");
				}
			}

			//_inFocus.inFocusUpdate();
			_camera.followTarget();
			super.update();
		}
		
		private function switchUnit():void
		{
			var currentIndex:int = _units.indexOf(_inFocus);
			currentIndex++;
			currentIndex %= _units.length;
			_inFocus = _units[currentIndex];
		}
		
		private function createUnits():void
		{

			var unit:Unit = new Swordman(generateValidPosition());
			unit.terrain = _terrain;
			add(unit);
			_units.push(unit);
			
			unit = new Dragon(generateValidPosition());
			unit.terrain = _terrain;
			add(unit);
			_units.push(unit);
			
			unit = new Archer(generateValidPosition());
			unit.terrain = _terrain;
			add(unit);
			_units.push(unit);
			
			unit = new Ninja(generateValidPosition());
			unit.terrain = _terrain;
			add(unit);
			_units.push(unit);
			
			unit = new Sorceror(generateValidPosition());
			unit.terrain = _terrain;
			add(unit);
			_units.push(unit);
			
			unit = new Witch(generateValidPosition());
			unit.terrain = _terrain;
			add(unit);
			_units.push(unit);
		}
		
		private function generateValidPosition():Point
		{
			var valid:Boolean = false;
			while (!valid)
			{
				var pCol:int = Math.random() * _terrain.cols;
				var pRow:int = Math.random() * _terrain.rows;
				valid = _terrain.isWalkable(pCol, pRow);
			}
			_terrain.setOccupied(pCol, pRow, true);
			return new Point(pCol * _terrain.cellSize, pRow * _terrain.cellSize);
		}
	}
}