// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VFX/FoamFlow"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 1
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Color0("Color 0", Color) = (0.1241545,0.5849056,0.560351,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Speed("Speed", Vector) = (0,0,0,0)
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_RefractionTex("RefractionTex", 2D) = "white" {}
		_Refraction_Strength("Refraction_Strength", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
		};

		uniform float4 _Color0;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform sampler2D _RefractionTex;
		uniform float4 _RefractionTex_ST;
		uniform float _Refraction_Strength;
		uniform sampler2D _TextureSample2;
		uniform float4 _Speed;
		uniform float4 _TextureSample2_ST;
		uniform float _Cutoff = 0.5;
		uniform float _TessValue;

		float4 tessFunction( )
		{
			return _TessValue;
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Emission = ( _Color0 * i.vertexColor ).rgb;
			o.Alpha = 1;
			float2 uv0_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float2 uv0_RefractionTex = i.uv_texcoord * _RefractionTex_ST.xy + _RefractionTex_ST.zw;
			float2 panner47 = ( 1.0 * _Time.y * float2( 0.12,0.03 ) + uv0_RefractionTex);
			float2 panner52 = ( -1.0 * _Time.y * float2( 0.12,0.03 ) + uv0_RefractionTex);
			float2 appendResult48 = (float2(tex2D( _RefractionTex, panner47 ).r , tex2D( _RefractionTex, panner52 ).g));
			float4 tex2DNode1 = tex2D( _TextureSample0, ( uv0_TextureSample0 + ( (float2( -1,-1 ) + (appendResult48 - float2( 0,0 )) * (float2( 1,1 ) - float2( -1,-1 )) / (float2( 1,1 ) - float2( 0,0 ))) * _Refraction_Strength ) ) );
			float2 appendResult27 = (float2(_Speed.z , _Speed.w));
			float2 uv0_TextureSample2 = i.uv_texcoord * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
			float2 panner25 = ( 1.0 * _Time.y * appendResult27 + uv0_TextureSample2);
			float4 tex2DNode24 = tex2D( _TextureSample2, panner25 );
			clip( ( tex2DNode1.r * saturate( ( tex2DNode24.r + (-1.0 + (i.vertexColor.a - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) ) ) - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16900
2113;231;1701;780;1571.176;93.34967;1.477061;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-2923.852,-831.2227;Float;False;0;46;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;47;-2575.909,-841.0554;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.12,0.03;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;52;-2645.141,-637.7579;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.12,0.03;False;1;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;46;-2450.615,-747.4648;Float;True;Property;_RefractionTex;RefractionTex;13;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;51;-2519.041,-468.7579;Float;True;Property;_TextureSample3;Texture Sample 3;13;0;Create;True;0;0;False;0;None;7d7776e70407cb1459db08421ee81f2c;True;0;False;white;Auto;False;Instance;46;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;21;-2001.675,188.0155;Float;False;Property;_Speed;Speed;10;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;48;-2085.852,-624.2991;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;27;-1721.888,-190.2764;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-1350.759,-104.7863;Float;False;0;24;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;25;-1128.495,78.23456;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.3;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;45;-1843.794,-611.1838;Float;True;5;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;1,1;False;3;FLOAT2;-1,-1;False;4;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;10;-785.0578,692.114;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;44;-2031.062,-326.1801;Float;False;Property;_Refraction_Strength;Refraction_Strength;14;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;56;-480.2892,466.4667;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;-1453.333,-678.0438;Float;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-1352.588,-388.5923;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;24;-901.5211,109.3878;Float;True;Property;_TextureSample2;Texture Sample 2;11;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-248.7302,399.1802;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-1074.574,-562.3637;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;8;205.0926,-563.1953;Float;False;Property;_Color0;Color 0;7;0;Create;True;0;0;False;0;0.1241545,0.5849056,0.560351,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;54;82.44473,18.31108;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-777.4035,-311.7062;Float;True;Property;_TextureSample0;Texture Sample 0;9;0;Create;True;0;0;False;0;None;18d4756c27f3bfc419b66ae2ab7f231c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;57;-76.07184,423.9071;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-406.6649,688.0157;Float;False;Constant;_Float1;Float 1;11;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;166.0749,77.31972;Float;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;18;-1356.812,175.9387;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.3;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;3;-880.3921,395.737;Float;True;Property;_TextureSample1;Texture Sample 1;12;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-538.6691,339.4492;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;22;-1566.682,446.9601;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-324.0041,98.14861;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;699.5792,-293.0706;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;40;78.3864,-214.2947;Float;False;Property;_Color1;Color 1;8;0;Create;True;0;0;False;0;0.1241545,0.5849056,0.560351,0;0.09985758,0.4082922,0.4150943,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;20;-1678.757,213.1487;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;38;319.9371,-51.63247;Float;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-98.62413,-463.4938;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;32;583.7977,-181.5093;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;30;307.032,267.205;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;-323.2131,611.4068;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;96.49017,213.8791;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;12;282.2841,547.5172;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1609.234,603.4774;Float;False;Property;_V_Time;V_Time;5;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-1678.061,75.85487;Float;False;0;3;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;39;265.337,-269.5324;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;872.9545,-55.15346;Float;False;True;6;Float;ASEMaterialInspector;0;0;Unlit;VFX/FoamFlow;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;False;0;False;TransparentCutout;;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;1;1;10;25;False;0.5;False;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;6;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;47;0;50;0
WireConnection;52;0;50;0
WireConnection;46;1;47;0
WireConnection;51;1;52;0
WireConnection;48;0;46;1
WireConnection;48;1;51;2
WireConnection;27;0;21;3
WireConnection;27;1;21;4
WireConnection;25;0;26;0
WireConnection;25;2;27;0
WireConnection;45;0;48;0
WireConnection;56;0;10;4
WireConnection;43;0;45;0
WireConnection;43;1;44;0
WireConnection;24;1;25;0
WireConnection;55;0;24;1
WireConnection;55;1;56;0
WireConnection;42;0;49;0
WireConnection;42;1;43;0
WireConnection;1;1;42;0
WireConnection;57;0;55;0
WireConnection;18;0;19;0
WireConnection;18;2;20;0
WireConnection;18;1;22;0
WireConnection;3;1;18;0
WireConnection;28;0;24;1
WireConnection;28;1;3;1
WireConnection;22;0;23;0
WireConnection;17;0;1;1
WireConnection;17;1;28;0
WireConnection;53;0;8;0
WireConnection;53;1;54;0
WireConnection;20;0;21;1
WireConnection;20;1;21;2
WireConnection;38;0;35;0
WireConnection;38;2;1;1
WireConnection;32;0;40;0
WireConnection;32;1;8;0
WireConnection;32;2;38;0
WireConnection;30;0;12;0
WireConnection;14;0;10;4
WireConnection;58;0;1;1
WireConnection;58;1;57;0
WireConnection;12;0;17;0
WireConnection;12;1;10;4
WireConnection;39;0;37;2
WireConnection;0;2;53;0
WireConnection;0;10;58;0
ASEEND*/
//CHKSM=729F56EB5D05D4EE51B6F8E6D55105267DB2FD17