Shader "I_Jemin/BasicBlinnPhong" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NormalMap("Noraml Map",2D) = "black" {}
		_SpecularColor("Specular Color",Color) = (1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		CGPROGRAM
		#pragma surface surf BasicBlinn fullforwardshadows

		sampler2D _MainTex;
		sampler2D _NormalMap;
		fixed4 _SpecularColor;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NormalMap;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			
			o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));

			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;

		}

		fixed4 LightingBasicBlinn(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
		{
			// Lambert
			float diffuseBrightness = saturate(dot(s.Normal, lightDir));

			fixed3 lambertColor = diffuseBrightness * s.Albedo;

			// Blinn Phong Specular
			float3 halfVec = normalize(lightDir + viewDir);
			float specularBrightness = saturate(dot(s.Normal, halfVec));

			specularBrightness = pow(specularBrightness, 48);

			fixed4 specularColor = specularBrightness * _SpecularColor;

			// final output

			fixed4 c;

			c.rgb = (lambertColor + specularColor) * _LightColor0.rgb * atten;

			c.a = s.Alpha;

			return c;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
