Shader "6/Refraction"
{
    Properties
	{
		_Color("Color Tint", Color) = (1,1,1,1)
		_RefractColor("Refract Color", Color) = (1,1,1,1)
		_RefractAmout("Refract Amout", Range(0, 1)) = 1
		_RefractRatio("Refract Ratio", Range(0.1, 1)) = 0.5
		_RefractCubemap("Refract Cubemap", CUBE) = "_Skybox"{}
	}
	SubShader
	{
		Tags { "Queue"="Geometry" "RenderType"="Opaque" }
		Pass
		{
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			fixed4 _Color;
			fixed4 _RefractColor;
			fixed _RefractAmout;
			fixed _RefractRatio;
			samplerCUBE _RefractCubemap;

			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				fixed3 worldPos : TEXCOORD0;
				fixed3 worldNormal : TEXCOORD1;
				fixed3 worldViewDir : TEXCOORD2;
				fixed3 worldRefr : TEXCOORD3;
				SHADOW_COORDS(4)
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);
				o.worldRefr = refract(normalize(-o.worldViewDir), o.worldNormal, _RefractRatio);
				TRANSFER_SHADOW(o);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldViewDir = normalize(i.worldViewDir);
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
				fixed3 diffuse = _LightColor0.rgb * _Color.rgb * max(0, dot(worldNormal, worldViewDir));
				fixed3 refraction = texCUBE(_RefractCubemap, i.worldRefr).rgb * _RefractColor.rgb;

				UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);

				fixed3 color = ambient + lerp(diffuse, refraction, _RefractAmout) * atten;
				return fixed4(color, 1.0);
			}
			ENDCG
		}
	}
    FallBack "Diffuse"
}
