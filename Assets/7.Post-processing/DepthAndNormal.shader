Shader "7/DepthAndNormal"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
		[Toggle] _DepthActive ("Show Depth", Float) = 0
		[Toggle] _NormalActive ("Show Normal", Float) = 0
    }
    SubShader
    {
		ZTest Always Cull Off ZWrite Off
        Pass
		{
			CGPROGRAM
			#pragma shader_feature DEPTH_VIEW
			#pragma shader_feature NORMAL_VIEW
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _CameraDepthTexture;
			sampler2D _CameraDepthNormalsTexture;
			float _DepthActive;
			float _NormalActive;

			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 uv : TEXCOORD0;
			};

			v2f vert(appdata_img v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				if (_NormalActive > 0.999)
				{
					fixed3 normal = DecodeViewNormalStereo(tex2D(_CameraDepthNormalsTexture, i.uv));
					return fixed4(normal * 0.5 + 0.5, 1.0);
				}
				else
				{
					if(_DepthActive > 0.999)
					{
						float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
						float linearDepth = Linear01Depth(depth);
						return fixed4(linearDepth, linearDepth, linearDepth, 1.0);
					}
					return fixed4(tex2D(_MainTex, i.uv));
				}
			}
			ENDCG
		}
    }
    FallBack Off
}
