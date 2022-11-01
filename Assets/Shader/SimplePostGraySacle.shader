Shader "Custom/SimplePostGraySacle"
{
    Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Slider("Slider",Range(-1, 1)) = 0
	}

	SubShader
	{
		Tags
		{
			"PreviewType" = "Plane"
		}
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv: TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv: TEXCOORD0;
			};

			sampler2D _MainTex;
			float _Slider;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				float4 color = tex2D(_MainTex, i.uv);
				float average = 0.212 * color.r + 0.7152 * color.g + 0.0722 * color.b;
				float y0 = i.uv.x - _Slider;
				float lerp = step(y0, i.uv.y);
				float4 finalColor = float4(average, average, average, 1) * lerp + 
					color * (1 - lerp);
					
				return finalColor;
			}
			ENDCG
		}
	}
}
