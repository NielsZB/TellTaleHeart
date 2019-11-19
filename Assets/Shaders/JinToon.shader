// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASECE/JinToon"
{
	Properties
	{
		_ASEOutlineColor( "Outline Color", Color ) = (0,0,0,0)
		_ASEOutlineWidth( "Outline Width", Float ) = 0.02
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Ramp("Ramp", 2D) = "white" {}
		_AlbedoColor("AlbedoColor", Color) = (0,0,0,0)
		_RimPower("Rim Power", Range( 0 , 1)) = 0.5
		_RimOffset("Rim Offset", Float) = 0.24
		_Color0("Color 0", Color) = (0,0,0,0)
		_Spec_Smooth("Spec_Smooth", Float) = 0
		_Spec_Intensity("Spec_Intensity", Range( 0 , 1)) = 0
		_Spec_Color("Spec_Color", Color) = (0,0,0,0)
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Erosion("Erosion", Range( 0 , 1)) = 0
		_AlbedoTex("AlbedoTex", 2D) = "white" {}
		_Rotate_Tex("Rotate_Tex", Range( 0 , 5)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		uniform half4 _ASEOutlineColor;
		uniform half _ASEOutlineWidth;
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += ( v.normal * _ASEOutlineWidth );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			o.Emission = _ASEOutlineColor.rgb;
			o.Alpha = 1;
		}
		ENDCG
		

		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			float3 worldPos;
			float3 viewDir;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float _Rotate_Tex;
		uniform float _Erosion;
		uniform sampler2D _Ramp;
		uniform float4 _AlbedoColor;
		uniform sampler2D _AlbedoTex;
		uniform float4 _AlbedoTex_ST;
		uniform float _RimOffset;
		uniform float _RimPower;
		uniform float4 _Color0;
		uniform float _Spec_Smooth;
		uniform float4 _Spec_Color;
		uniform float _Spec_Intensity;
		uniform float _Cutoff = 0.5;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv0_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float cos127 = cos( _Rotate_Tex );
			float sin127 = sin( _Rotate_Tex );
			float2 rotator127 = mul( uv0_TextureSample1 - float2( 0.5,0.5 ) , float2x2( cos127 , -sin127 , sin127 , cos127 )) + float2( 0.5,0.5 );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult22 = dot( ase_normWorldNormal , ase_worldlightDir );
			float Norm42 = dotResult22;
			float2 appendResult102 = (float2(Norm42 , Norm42));
			float2 uv_AlbedoTex = i.uv_texcoord * _AlbedoTex_ST.xy + _AlbedoTex_ST.zw;
			float4 temp_output_35_0 = ( ase_lightColor * tex2D( _Ramp, appendResult102 ) * ( _AlbedoColor * tex2D( _AlbedoTex, uv_AlbedoTex ) ) * ase_lightAtten );
			float dotResult39 = dot( ase_normWorldNormal , i.viewDir );
			float View45 = dotResult39;
			float4 Rim56 = ( ( saturate( pow( ( 1.0 - saturate( ( _RimOffset + View45 ) ) ) , _RimPower ) ) * ( Norm42 * ase_lightAtten ) ) * ( ase_lightColor * _Color0 ) );
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult71 = dot( ( ase_worldViewDir + ase_worldlightDir ) , ase_worldNormal );
			float smoothstepResult76 = smoothstep( _Spec_Smooth , _Spec_Smooth , dotResult71);
			float4 Spec83 = ( ase_lightAtten * ( ( smoothstepResult76 * _Spec_Color ) * _Spec_Intensity ) );
			c.rgb = ( ( temp_output_35_0 + Rim56 ) + Spec83 ).rgb;
			c.a = 1;
			clip( ( tex2D( _TextureSample1, rotator127 ).r + (-1.0 + (_Erosion - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) - _Cutoff );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16900
2260;345;1280;907;707.7173;1345.555;1.6;True;False
Node;AmplifyShaderEditor.CommentaryNode;46;-2409.393,-223.6162;Float;False;768.5922;397.2871;Comment;4;38;39;40;45;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;40;-2347.552,-10.32903;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;38;-2359.393,-173.6162;Float;False;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;39;-2055.394,-93.61617;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-1883.801,-91.73537;Float;False;View;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-852.3955,250.7402;Float;False;45;View;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1015.396,191.7402;Float;False;Property;_RimOffset;Rim Offset;5;0;Create;True;0;0;False;0;0.24;0.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;44;-2428.106,-1005.897;Float;False;885.6554;458;Comment;4;23;21;22;42;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;23;-2378.106,-726.8973;Float;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-653.3955,84.7402;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;21;-2341.142,-955.8973;Float;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;22;-2064.335,-826.1624;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;95;-430.3739,91.82375;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;69;-849.3748,1125.258;Float;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;68;-782.3748,921.2576;Float;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;53;-256.6955,26.34023;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-1852.743,-807.7915;Float;False;Norm;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-494.9068,464.8534;Float;False;Property;_RimPower;Rim Power;3;0;Create;True;0;0;False;0;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;70;-519.3748,1320.258;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;72;-407.3748,1083.258;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightAttenuation;62;-165.2996,627.6618;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;71;-216.3748,1191.258;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-133.3748,1474.258;Float;False;Property;_Spec_Smooth;Spec_Smooth;7;0;Create;True;0;0;False;0;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;54;-128.6736,234.1322;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-144.2996,465.6618;Float;False;42;Norm;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;96;147.8183,218.7168;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;65;255.3054,658.5779;Float;False;Property;_Color0;Color 0;6;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;125.4135,529.0819;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;59;307.458,500.8903;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;87;144.6178,1739.957;Float;False;Property;_Spec_Color;Spec_Color;12;0;Create;True;0;0;False;0;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;76;260.6252,1171.258;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;549.1054,454.4781;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;628.5849,1564.017;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;80;259.7503,1408.57;Float;False;Property;_Spec_Intensity;Spec_Intensity;10;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-1239.057,-712.598;Float;False;42;Norm;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;273.428,297.6476;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;637.7412,342.6712;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;550.6252,1252.258;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;36;-452.3825,-1396.179;Float;False;Property;_AlbedoColor;AlbedoColor;2;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;116;-643.7255,-1222.298;Float;True;Property;_AlbedoTex;AlbedoTex;16;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightAttenuation;82;657.6252,1163.258;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-873.8209,-1029.643;Float;True;Property;_Ramp;Ramp;1;0;Create;True;0;0;False;0;4a1a20e176d86f64695ccaa972459e52;edab72fa991539b49896d99adb9d277a;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DynamicAppendNode;102;-600.3433,-672.4729;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;17;-493.8708,-909.1542;Float;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightColorNode;33;-547.8104,-451.4092;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;130;357.5668,-897.8813;Float;False;Property;_Rotate_Tex;Rotate_Tex;17;0;Create;True;0;0;False;0;0;3.7;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;129;157.3668,-1164.381;Float;False;0;108;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightAttenuation;25;-742.9545,-77.31093;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-34.88757,-1132.296;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;768.8265,264.9216;Float;False;Rim;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;790.6252,1226.258;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RotatorNode;127;412.6974,-1086.399;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;1159.625,1217.258;Float;False;Spec;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;110;443.1167,-788.0646;Float;False;Property;_Erosion;Erosion;15;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;142.8216,-1048.25;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-212.44,-255.2211;Float;False;56;Rim;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;108;626.7167,-1038.265;Float;True;Property;_TextureSample1;Texture Sample 1;14;0;Create;True;0;0;False;0;None;9a7f540b704e7474989ec7ab47a595f6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;111;748.1167,-768.0646;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;104;375.1692,-710.8804;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;84;396.8714,-530.5731;Float;False;83;Spec;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;90;489.3287,2004.065;Float;False;Property;_Spec_Transition;Spec_Transition;13;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;32;-743.0097,-296.4738;Float;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;124;1774.063,-400.8031;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;122;1304.063,-420.8031;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;112.6252,1399.258;Float;False;Property;_Max;Max;8;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-905.6998,-570.3531;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-983.3225,-763.1365;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-188.111,-383.1844;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;88;676.7489,1803.009;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;123;1482.063,-500.8031;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;18;-1142.067,-380.8951;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;121;1344.063,-480.8031;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-355.6098,-278.2739;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;26;-790.1199,-804.5503;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;109;953.1167,-862.0646;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;438.6711,-328.6601;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;66;475.3954,-180.0511;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-231.6159,1383.393;Float;False;Property;_Min;Min;9;0;Create;True;0;0;False;0;0;-1.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;611.3978,-627.2861;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;119;944.0626,-407.8031;Float;False;Property;_Float1;Float 1;11;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;120;1083.063,-564.8031;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;99.79778,-442.8576;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1120.661,-1124.261;Float;False;Property;_ToonIntensity;Toon Intensity;4;0;Create;True;0;0;False;0;0.13;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;89;448.3297,1643.092;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;114;1603.16,-912.8903;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;ASECE/JinToon;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;True;0.02;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;39;0;38;0
WireConnection;39;1;40;0
WireConnection;45;0;39;0
WireConnection;49;0;50;0
WireConnection;49;1;48;0
WireConnection;22;0;21;0
WireConnection;22;1;23;0
WireConnection;95;0;49;0
WireConnection;53;0;95;0
WireConnection;42;0;22;0
WireConnection;72;0;68;0
WireConnection;72;1;69;0
WireConnection;71;0;72;0
WireConnection;71;1;70;0
WireConnection;54;0;53;0
WireConnection;54;1;55;0
WireConnection;96;0;54;0
WireConnection;61;0;63;0
WireConnection;61;1;62;0
WireConnection;76;0;71;0
WireConnection;76;1;74;0
WireConnection;76;2;74;0
WireConnection;64;0;59;0
WireConnection;64;1;65;0
WireConnection;86;0;76;0
WireConnection;86;1;87;0
WireConnection;60;0;96;0
WireConnection;60;1;61;0
WireConnection;58;0;60;0
WireConnection;58;1;64;0
WireConnection;79;0;86;0
WireConnection;79;1;80;0
WireConnection;102;0;47;0
WireConnection;102;1;47;0
WireConnection;17;0;4;0
WireConnection;17;1;102;0
WireConnection;115;0;36;0
WireConnection;115;1;116;0
WireConnection;56;0;58;0
WireConnection;81;0;82;0
WireConnection;81;1;79;0
WireConnection;127;0;129;0
WireConnection;127;2;130;0
WireConnection;83;0;81;0
WireConnection;35;0;33;0
WireConnection;35;1;17;0
WireConnection;35;2;115;0
WireConnection;35;3;25;0
WireConnection;108;1;127;0
WireConnection;111;0;110;0
WireConnection;104;0;35;0
WireConnection;104;1;57;0
WireConnection;124;0;123;0
WireConnection;122;0;119;0
WireConnection;103;0;47;0
WireConnection;103;1;25;0
WireConnection;107;0;103;0
WireConnection;107;1;5;0
WireConnection;30;0;33;0
WireConnection;30;1;31;0
WireConnection;88;0;89;0
WireConnection;88;2;90;0
WireConnection;123;0;121;0
WireConnection;123;1;122;0
WireConnection;18;0;47;0
WireConnection;18;1;5;0
WireConnection;18;2;5;0
WireConnection;121;0;120;1
WireConnection;31;0;32;0
WireConnection;31;1;25;0
WireConnection;26;0;47;0
WireConnection;109;0;108;1
WireConnection;109;1;111;0
WireConnection;101;0;34;0
WireConnection;101;1;57;0
WireConnection;66;0;34;0
WireConnection;66;1;57;0
WireConnection;85;0;104;0
WireConnection;85;1;84;0
WireConnection;34;0;35;0
WireConnection;34;1;30;0
WireConnection;114;10;109;0
WireConnection;114;13;85;0
ASEEND*/
//CHKSM=54A2D7CEED5187BA2DC43FAFA81BF7E2CD2B6EC0