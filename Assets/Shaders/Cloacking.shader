Shader "I_Jemin/Cloaking" {
	Properties {
		_MainTex("Albedo Texture",2D) = "white" {}
		_DeformMap("Cloaking Extran Deform Map",2D) = "black" {}
		_NormalMap("Normal Map",2D) = "black" {}
		_Opacity("Opacity",Range(0,1)) = 0.1
		_DeformIntense("Deform by Normal Intensity",Range(0,3)) = 1
		_RimPow("Rim Pow",Range(0,60)) = 30
		_RimColor("Rim Color",Color) = (0,1,1,1)

	}
	SubShader {
		Tags { "Queue" = "Transparent" "RenderType" = "Opaque"}
		zwrite off

		GrabPass {}

		CGPROGRAM
		#pragma surface surf CloakingLight noambient novertexlights noforwardadd
		#pragma target 3.0

		sampler2D _GrabTexture;
		sampler2D _DeformMap;
		sampler2D _MainTex;
		sampler2D _NormalMap;
		float _DeformIntense;
		float _Opacity;
		float _RimPow;
		float3 _RimColor;

		struct Input
		{
			float4 color:COLOR;
			float4 screenPos;
			float2 uv_DeformMap;
			float2 uv_MainTex;
			float2 uv_NormalMap;
			float3 viewDir;
		};

		void surf(Input IN, inout SurfaceOutput o) {
			o.Normal = UnpackNormal(tex2D(_NormalMap,IN.uv_NormalMap));

			float4 c = tex2D(_MainTex,IN.uv_MainTex);

			

			float2 noiseOffset = tex2D(_DeformMap,IN.uv_DeformMap).rg;

			noiseOffset *= o.Normal.z * 0.1;

			float2 uv_screen = IN.screenPos.rg/IN.screenPos.a;

			uv_screen += o.Normal.rg * _DeformIntense;

			fixed3 mappingScreenColor = tex2D(_GrabTexture,uv_screen + noiseOffset);
			
			float rimBrightness = 1 - saturate(dot(IN.viewDir,o.Normal));
			rimBrightness = pow(rimBrightness,_RimPow);
			

			o.Emission = mappingScreenColor * (1-_Opacity) + _RimColor * rimBrightness;
			o.Albedo = c.rgb;
		}

		fixed4 LightingCloakingLight(SurfaceOutput s, float3 lightDir, float atten)
		{


			return fixed4(s.Albedo * _Opacity * _LightColor0,1);
		}
		


		ENDCG
	}
	FallBack "Diffuse"
}
