// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/BlendModes/Darken"
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

			fixed4 blendDarken(fixed4 base, fixed4 blend)
			{
				return fixed4(
					min(base.r, blend.r),
					min(base.g, blend.g),
					min(base.b, blend.b),
					base.a
				);
			}

			fixed4 blendDarken(fixed4 base, fixed4 blend, fixed opacity)
			{
				return (blendDarken(base, blend) * opacity + base * (1.0 - opacity));
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float4 texColor = tex2D(_MainTex, i.uv) * _Color;
				float4 baseColor = tex2Dproj(_GrabTexture, i.screen);

				return blendDarken(baseColor, texColor, texColor.a);
			}
			ENDCG
		}
	}
}