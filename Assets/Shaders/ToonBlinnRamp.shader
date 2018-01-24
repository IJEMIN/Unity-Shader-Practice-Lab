Shader "I_Jemin/ToonBlinnRamp" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NormalMap("Normal Map",2D) = "black" {}
		_RampTex ("RampTexture",2D) = "black" {}
		_OutlineThreshold("Outline Threshold",Range(0,1)) = 0.2
		_SpecularPower("Specular Power",Range(0,10)) = 3
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		CGPROGRAM
		#pragma surface surf ToonBlinn noambient
		sampler2D _MainTex;
		sampler2D _NormalMap;
		sampler2D _RampTex;
		float _OutlineThreshold;
		float _SpecularPower;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NormalMap;
		};
		void surf (Input IN, inout SurfaceOutput o) {
			o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));

			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		fixed4 LightingToonBlinn(SurfaceOutput s, float3 lightDir,float3 viewDir, float atten)
		{
			//Lambert
			float diffuseBrightness = dot(s.Normal,lightDir);
			diffuseBrightness = saturate(diffuseBrightness);

			//Half-Lambert
			diffuseBrightness = diffuseBrightness * 0.5 + 0.5;

			fixed3 rampColor = tex2D(_RampTex, float2(diffuseBrightness, 0.5));

			fixed3 diffuseLight = rampColor * s.Albedo;

			//Blinn-Phong Specular
			float3 halfVec = normalize(viewDir + lightDir);

			float specBrightness = dot(halfVec,s.Normal);

			specBrightness = saturate(specBrightness);
			specBrightness = pow(specBrightness,10 - _SpecularPower);

			fixed3 specLight = tex2D(_RampTex,float2(0,specBrightness));

			// Draw outlint by rim
			float rimBrightness = dot(s.Normal,viewDir);
			rimBrightness = abs(rimBrightness);

			if(rimBrightness < _OutlineThreshold)
			{
				rimBrightness = 0;
			}
			else
			{
				rimBrightness = 1;
			}

			// final output

			fixed4 c;

			// don't draw atten for toony effect
			c.rgb = (diffuseLight + specLight) * _LightColor0 * rimBrightness;
			c.a = s.Alpha;

			return c;
		}


		ENDCG
	}
	FallBack "Diffuse"
}
