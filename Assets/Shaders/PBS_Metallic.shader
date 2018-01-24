Shader "I_Jemin/Metallic" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NormalMap("Normal Map",2D) = "black" {}
		_MetallicTex("Metallic Map",2D) = "black" {}
		_Smooth("Smooth",Range(0,1)) = 0.5
	
	}
	SubShader {
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows


		sampler2D _MainTex;
		sampler2D _MetallicTex;
		sampler2D _NormalMap;
		float _Smooth;

		struct Input {
			float2 uv_MainTex;
			float2 uv_MetallicTex;
			float2 uv_NormalMap;
		};

		half _Metallic;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));

			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Smoothness = _Smooth;

			o.Metallic = tex2D(_MetallicTex,IN.uv_MetallicTex).r;

			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
