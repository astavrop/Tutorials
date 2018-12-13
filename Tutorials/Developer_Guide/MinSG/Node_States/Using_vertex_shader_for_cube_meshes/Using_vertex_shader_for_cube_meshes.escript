var rootNode=new MinSG.ListNode();
var listNode=new MinSG.ListNode();
var cube1=Rendering.loadMesh("./data/mesh/color_cube.mmf");
var geometryNode1=new MinSG.GeometryNode(cube1);
listNode+=geometryNode1;
geometryNode1.moveLocal(new Geometry.Vec3(1, 0, 0));
var cube2=Rendering.loadMesh("./data/mesh/color_cube.mmf");
var geometryNode2=new MinSG.GeometryNode(cube2);
geometryNode2.moveLocal(new Geometry.Vec3(2, 0, 0));
var cube3=Rendering.loadMesh("./data/mesh/color_cube.mmf");
var geometryNode3=new MinSG.GeometryNode(cube3);
geometryNode3.moveLocal(new Geometry.Vec3(3, 0, 0));
listNode+=geometryNode2;
listNode+=geometryNode3;
rootNode+=listNode;

var vertexShaderCode="
varying vec4 vetxColor;

void main()
{
    //coordinate of the vertex in projection space
    vec4 pos = ftransform();
    gl_Position = pos;
    vetxColor = pos;

}
";


var fragmentShaderCode="
varying vec4 vetxColor;

void main()
{
    gl_FragColor = vetxColor;
} ";


var shader = Rendering.Shader.createShader(vertexShaderCode, fragmentShaderCode);
var changeColor = new MinSG.ShaderState(shader);
geometryNode2+=changeColor;



var vertexShaderCodeTranslate="
varying vec4 vetxColor;

void main()
{

    mat4 translateMatrix=mat4(1,0,0,0,
      0,1,0,0.5,
      0,0,1,0,
      0,0,0,1);
    //fransform represents
    //coordinate of the vertex in projection space
    vec4 pos = ftransform()*translateMatrix;
    gl_Position = pos;
    vetxColor = vec4(0.4,0.4,0,0);

}
";

var shader2 = Rendering.Shader.createShader(vertexShaderCodeTranslate, fragmentShaderCode);
var moveUpandDown = new MinSG.ShaderState(shader2);
geometryNode3+=moveUpandDown;



PADrend.registerScene(rootNode);
PADrend.selectScene(rootNode);
