Shader "I_Jemin/HalfLambert" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NormalMap("Noraml Map",2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
		#pragma surface surf HalfLambert

		sampler2D _MainTex;
		sampler2D _NormalMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NormalMap;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			o.Normal = UnpackNormal(tex2D(_NormalMap,IN.uv_NormalMap));
			fixed4 c = tex2D(_MainTex,IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		fixed4 LightingHalfLambert(SurfaceOutput s, float3 lightDir, float atten)
		{
			float brightness = dot(s.Normal,lightDir);
			// Half Lambert
			brightness = brightness * 0.5 + 0.5;

			return fixed4(s.Albedo * brightness * _LightColor0.rgb * atten,s.Alpha);
		}

		ENDCG
	}
	FallBack "Diffuse"
}
