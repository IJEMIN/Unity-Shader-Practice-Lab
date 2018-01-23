Shader "I_Jemin/Lambert/RimLight" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NormalMap("Noraml Map",2D) = "white" {}
		_RimColor("Rim Color",Color) = (1,1,1,1)
		_RimPow("Rim Thinness",Range(0,10)) = 2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _NormalMap;
		fixed4 _RimColor;
		float _RimPow;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NormalMap;
			float3 viewDir;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			o.Normal = UnpackNormal(tex2D(_NormalMap,IN.uv_NormalMap));
			fixed4 c = tex2D(_MainTex,IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;

			float rimBrightness = dot(o.Normal,IN.viewDir);
			rimBrightness = 1 - rimBrightness;
			rimBrightness = pow(rimBrightness,_RimPow);
			
			// Don't draw rim when light is off
			o.Emission = _RimColor * rimBrightness * _LightColor0;
		}



		ENDCG
	}
	FallBack "Diffuse"
}
