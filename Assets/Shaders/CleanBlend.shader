Shader "I_Jemin/CleanBlend" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NormalMap ("Normal Map", 2D) = "black" {}
		_AlphaOpacity ("Opacity", Range(0,1)) = 0.5
	}
	SubShader {
		Tags { "Queue" = "Transparent" "RenderType"="Transparent" }
		
		// fist pass
		pass {
			zwrite on // record z
			ColorMask 0
		}

		// second pass

		zwrite off // off z
		
		CGPROGRAM
		#pragma surface surf Standard alpha:fade
		sampler2D _MainTex;
		sampler2D _NormalMap;
		float _AlphaOpacity;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NormalMap;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {

			o.Normal = UnpackNormal(tex2D(_NormalMap,IN.uv_NormalMap));
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) ;
			o.Albedo = c.rgb;

			o.Alpha = _AlphaOpacity;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
