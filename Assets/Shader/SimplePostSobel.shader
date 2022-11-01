Shader "Custom/SimplePostSobel"
{
    Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
        _Threshold("_Threshold",Range(0,1)) = 0.1
        _EdgeColor("_EdgeColor",Color) = (1,1,1,1)
	}
	
	SubShader 
	{
		Tags 
		{ 
			"RenderType"="Opaque" 
		}
		LOD 200
		
		
		Pass 
		{
			CGINCLUDE
			#include "UnityCG.cginc"
		
			sampler2D _MainTex;
            float4 _MainTex_TexelSize;
            float _Threshold;
            float4 _EdgeColor;
		
			float sobel (sampler2D tex, float2 uv, float4 size) 
			{
				float2 delta = float2(size.x, size.y);
			
				float4 hr = float4(0, 0, 0, 0);
				float4 vt = float4(0, 0, 0, 0);
			
				hr += tex2D(tex, (uv + float2(-1.0, -1.0) * delta)) *  1.0;
				hr += tex2D(tex, (uv + float2( 0.0, -1.0) * delta)) *  0.0;
				hr += tex2D(tex, (uv + float2( 1.0, -1.0) * delta)) * -1.0;
				hr += tex2D(tex, (uv + float2(-1.0,  0.0) * delta)) *  2.0;
				hr += tex2D(tex, (uv + float2( 0.0,  0.0) * delta)) *  0.0;
				hr += tex2D(tex, (uv + float2( 1.0,  0.0) * delta)) * -2.0;
				hr += tex2D(tex, (uv + float2(-1.0,  1.0) * delta)) *  1.0;
				hr += tex2D(tex, (uv + float2( 0.0,  1.0) * delta)) *  0.0;
				hr += tex2D(tex, (uv + float2( 1.0,  1.0) * delta)) * -1.0;
			
				vt += tex2D(tex, (uv + float2(-1.0, -1.0) * delta)) *  1.0;
				vt += tex2D(tex, (uv + float2( 0.0, -1.0) * delta)) *  2.0;
				vt += tex2D(tex, (uv + float2( 1.0, -1.0) * delta)) *  1.0;
				vt += tex2D(tex, (uv + float2(-1.0,  0.0) * delta)) *  0.0;
				vt += tex2D(tex, (uv + float2( 0.0,  0.0) * delta)) *  0.0;
				vt += tex2D(tex, (uv + float2( 1.0,  0.0) * delta)) *  0.0;
				vt += tex2D(tex, (uv + float2(-1.0,  1.0) * delta)) * -1.0;
				vt += tex2D(tex, (uv + float2( 0.0,  1.0) * delta)) * -2.0;
				vt += tex2D(tex, (uv + float2( 1.0,  1.0) * delta)) * -1.0;
			
				return sqrt(hr * hr + vt * vt);
			}
		
			float4 frag (v2f_img IN) : COLOR 
			{
				float s = sobel(_MainTex, IN.uv, _MainTex_TexelSize);

				//return s;

				float l = step(_Threshold, s);
				
				float4 ori = tex2D(_MainTex, IN.uv);
				float4 col = lerp(ori, _EdgeColor, l);

				return col;
			}
		
			ENDCG
		}
		
		Pass 
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			ENDCG
		}
	} 
}
