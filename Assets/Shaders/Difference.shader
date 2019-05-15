﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/BlendModes/Difference"
{
	Properties
	{
		_Color("Color", Color) = (0, 0, 0, 0) 
		_MainTex("Texture", 2D) = "white" {}
	}

	SubShader
	{
		Tags { "Queue" = "Transparent" }

		GrabPass
		{
			"_GrabTexture"
		}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			float4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _GrabTexture;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 screen : TEXCOORD1;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.screen = ComputeGrabScreenPos(o.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			inline fixed3 blendDifference(fixed3 base, fixed3 blend, fixed opacity)
			{
				return (abs(base - blend) * opacity + base * (1.0 - opacity));
			}

			fixed3 frag(v2f i) : SV_Target
			{
				float4 baseColor = tex2Dproj(_GrabTexture, i.screen);
				float4 texColor = tex2D(_MainTex, i.uv) * _Color;

				return blendDifference(baseColor, texColor, texColor.a);
			}
			ENDCG
		}
	}
}