Shader "I_Jemin/Menual Spec" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NormalMap("Normal Map",2D) = "black" {}
		_GlossMap("Smooth(Gloss) Map",2D) = "black" {}
		_SpecColor("Specular Color",Color) = (0,0,0,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf StandardSpecular fullforwardshadows


		sampler2D _MainTex;
		sampler2D _GlossMap;
		sampler2D _NormalMap;
		float _Smooth;

		struct Input {
			float2 uv_MainTex;
			float2 uv_GlossMap;
			float2 uv_NormalMap;
		};

		void surf (Input IN, inout SurfaceOutputStandardSpecular o) {
			o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));

			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;

			o.Smoothness = tex2D(_GlossMap,IN.uv_GlossMap).r;
			o.Specular = _SpecColor.rgb;

			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
