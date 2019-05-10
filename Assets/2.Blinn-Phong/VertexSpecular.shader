﻿Shader "2/VertexSpecular"
{
	Properties
	{
		_Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
		_Specular ("Specular", Color) = (1, 1, 1, 1)
		_Gloss ("Gloss", Range(8.0, 256)) = 20
	}
	SubShader
	{
		Pass
		{
			Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"
			
			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;

			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				fixed3 color : COLOR;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				// ambient
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				
				// diffuse
				fixed3 worldNormal = normalize(mul(v.normal, (float3x3) unity_WorldToObject));	// 法线向量转换到世界空间，可以直接乘上顶点变换矩阵的逆转置矩阵
																								// World2Object 即 Object2World 的逆矩阵
																								// 再调换 mul 乘法的位置，就得到了转置矩阵
				//fixed3 worldNormal = normalize(v.normal);										// 如果法线不转换到模型空间，物体旋转时光照不会跟随改变，只有改变光照角度时才会改变
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));
				
				fixed3 worldPos = mul(unity_ObjectToWorld, v.vertex);
				fixed3 reflectDir = normalize(reflect(-worldLight, worldNormal));
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos.xyz);
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);

				o.color = ambient + diffuse + specular;

				return o;
			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				return fixed4(i.color, 1.0);
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
