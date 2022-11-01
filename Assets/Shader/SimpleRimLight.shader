Shader "Custom/SimpleRimLight"
{
    Properties
	{
		_MainTex("Base texture", 2D) = "white" {}
		_RampTex("Ramp texture", 2D) = "white" {}

		_AmbientStrength("Ambient Strength",Range(0,1.0)) = 0.1
		_DiffStrength("Diff Strength",Range(0,1.0)) = 0.1
		_SpecStrength("Spec Strength",Range(0,5.0)) = 0.1

		_SpecPow("Specular Pow",int) = 0.5
		_Brightness("Brightness",Range(0,1.0)) = 0.5
		_TintColor("Tint Color",Color) = (1.0,1.0,1.0,1.0)
		
		_RimStrength("Rim Strength",Range(0,1.0)) = 0.1
		_RimAmount("Rim Amount",Range(0, 1.0)) = 0.1
		_OutlineAmount("Outline Amount",Range(0, 1.0)) = 0.1
		_OutlineColor("Outline Color",Color) = (1.0,1.0,1.0,1.0)
	}

	SubShader
	{
		Tags 
		{
			"LightMode" = "ForwardBase"
		}
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityLightingCommon.cginc" // for _LightColor0
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv: TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float2 uv: TEXCOORD0;			
				float3 viewDir : TEXCOORD1;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.uv = v.uv;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _RampTex;

			float _AmbientStrength;
			float _SpecStrength;
			float _DiffStrength;

			float4 _TintColor;
			float _SpecPow;
			float _Brightness;

			float _RimStrength;
			float _RimAmount;
			float _OutlineAmount;
			float4 _OutlineColor;

			float4 frag(v2f i) : SV_Target
			{
			
				float4 baseColor = tex2D(_MainTex, i.uv) ;
				float3 normal = normalize(i.normal);
				//ambient
				float3 ambient = _LightColor0 * _AmbientStrength;

				//diffuse
				float ndotL = dot(i.normal, _WorldSpaceLightPos0);
				float2 uv = float2((ndotL * 0.5 + 0.5), 0);
				float3 ramp = tex2D(_RampTex, uv);

				float3 diff = ramp * _LightColor0 * _DiffStrength;

				//specular
				float3 reflectDir = reflect(-_WorldSpaceLightPos0, normal);
				float spec = pow(max(dot(i.viewDir, reflectDir), 0.0), _SpecPow);
				float3 specSmooth = smoothstep(0.005, 0.01, spec) * _LightColor0 * _SpecStrength;

				float ndotV = 1 - dot(i.normal, i.viewDir);
				float rimSmooth = max(0, ndotL) * smoothstep(_RimAmount - 0.01, _RimAmount + 0.01, ndotV) ;
				float3 rimlight = rimSmooth * _LightColor0 * _RimStrength;
				float lerp = step(ndotV, _OutlineAmount);
				float4 finalColor = 
					float4((diff + ambient + rimlight + specSmooth), 1.0) * lerp + 
					_OutlineColor * (1 - lerp);

				return finalColor;
			}
			ENDCG
		}
	}
}
