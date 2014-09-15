package DDLS.view
{
	import DDLS.ai.DDLSEntityAI;
	import DDLS.data.DDLSEdge;
	import DDLS.data.DDLSFace;
	import DDLS.data.DDLSMesh;
	import DDLS.data.DDLSVertex;
	import DDLS.iterators.IteratorFromMeshToVertices;
	import DDLS.iterators.IteratorFromVertexToHoldingFaces;
	import DDLS.iterators.IteratorFromVertexToIncomingEdges;
	
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	public class DDLSSimpleView
	{
		
		private var _edges:Shape;
		private var _constraints:Shape;
		private var _vertices:Shape;
		private var _entities:Shape;
		
		private var _surface:Sprite;
		
		public function DDLSSimpleView()
		{
			_edges = new Shape();
			_constraints = new Shape();
			_vertices = new Shape();
			_entities = new Shape();
			
			_surface = new Sprite();
			_surface.addChild(_edges);
			_surface.addChild(_constraints);
			_surface.addChild(_vertices);
			_surface.addChild(_entities);
		}
		
		public function get surface():Sprite
		{
			return _surface;
		}
		
		public function drawMesh(mesh:DDLSMesh):void
		{
			_surface.graphics.clear();
			_edges.graphics.clear();
			_constraints.graphics.clear();
			_vertices.graphics.clear();
			
			_surface.graphics.beginFill(0x00, 0);
			_surface.graphics.lineStyle(1, 0xFF0000, 1, false, LineScaleMode.NONE);
			_surface.graphics.drawRect(0, 0, mesh.width, mesh.height);
			_surface.graphics.endFill();
			
			var vertex:DDLSVertex;
			var incomingEdge:DDLSEdge;
			var holdingFace:DDLSFace;
			
			var iterVertices:IteratorFromMeshToVertices;
			iterVertices = new IteratorFromMeshToVertices();
			iterVertices.fromMesh = mesh;
			//
			var iterEdges:IteratorFromVertexToIncomingEdges;
			iterEdges = new IteratorFromVertexToIncomingEdges();
			var dictVerticesDone:Dictionary;
			dictVerticesDone = new Dictionary();
			//
			while ( vertex = iterVertices.next() )
			{
				//_vertices.graphics.lineStyle(0, 0);
				_vertices.graphics.beginFill(0x0000FF, 1);
				_vertices.graphics.drawCircle(vertex.pos.x, vertex.pos.y, 0.5);
				_vertices.graphics.endFill();
				
				/*var tf:TextField = new TextField();
				tf.mouseEnabled = false;
				tf.text = String(vertex.id);
				tf.x = vertex.pos.x + 5;
				tf.y = vertex.pos.y + 5;
				tf.width = tf.height = 20;
				_vertices.addChild(tf);*/
				
				iterEdges.fromVertex = vertex;
				while ( incomingEdge = iterEdges.next() )
				{
					if (! dictVerticesDone[incomingEdge.originVertex])
					{
						if (incomingEdge.isConstrained)
						{
							_constraints.graphics.lineStyle(2, 0xFF0000, 1, false, LineScaleMode.NONE);
							_constraints.graphics.moveTo(incomingEdge.originVertex.pos.x, incomingEdge.originVertex.pos.y);
							_constraints.graphics.lineTo(incomingEdge.destinationVertex.pos.x, incomingEdge.destinationVertex.pos.y);
						}
						else
						{
							_edges.graphics.lineStyle(1, 0x999999, 1, false, LineScaleMode.NONE);
							_edges.graphics.moveTo(incomingEdge.originVertex.pos.x, incomingEdge.originVertex.pos.y);
							_edges.graphics.lineTo(incomingEdge.destinationVertex.pos.x, incomingEdge.destinationVertex.pos.y);
						}
					}
				}
				
				dictVerticesDone[vertex] = true;
			}
		}
		
		public function drawEntities(vEntities:Vector.<DDLSEntityAI>, cleanBefore:Boolean=true):void	
		{
			if (cleanBefore)
				_entities.graphics.clear();
			
			_entities.graphics.lineStyle(1, 0x0000FF, 1, false, LineScaleMode.NONE);
			for (var i:int=0 ; i<vEntities.length ; i++)
			{
				_entities.graphics.beginFill(0x6666FF, 1);
				_entities.graphics.drawCircle(vEntities[i].x, vEntities[i].y, vEntities[i].radius);
				_entities.graphics.endFill();
			}
		}
		
		
	}
}