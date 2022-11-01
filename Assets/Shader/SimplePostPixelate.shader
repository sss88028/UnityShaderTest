Shader "Custom/SimplePostPixelate"
{
    Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Slider("Slider",Range(0, 1)) = 0
		_PixelateAmt("Amount", Range(0,500)) = 1
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
            float _PixelateAmt;

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
				float2 uv = i.uv;
                uv.x *= _PixelateAmt;
                uv.y *= _PixelateAmt;
                uv.x = round(uv.x);
                uv.y = round(uv.y);
                uv.x /= _PixelateAmt;
                uv.y /= _PixelateAmt;

				float lerp = step(i.uv.x, _Slider);
				float4 finalColor = tex2D(_MainTex, uv) * lerp + 
					color * (1 - lerp);
					
				return finalColor;
			}
			ENDCG
		}
	}
}
