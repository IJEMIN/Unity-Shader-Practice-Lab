Shader "I_Jemin/CubemapReflection" {
	Properties{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_NormalMap("Normal Map",2D) = "black" {}
		_Cube("Reflection Cubemap",Cube) = "" {}
		_ReflectionOpacity("Reflection Opacity",Range(0,1)) = 0.3
	}
	SubShader {
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows

		sampler2D _MainTex;
		sampler2D _NormalMap;
		samplerCUBE _Cube;
		float _ReflectionOpacity;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NormalMap;
			float3 worldRefl;
			INTERNAL_DATA
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {

			o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);

			o.Alpha = c.a;

			o.Albedo = c.rgb * (1 - _ReflectionOpacity);
			o.Emission = texCUBE(_Cube, WorldReflectionVector(IN,o.Normal)) * _ReflectionOpacity;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
