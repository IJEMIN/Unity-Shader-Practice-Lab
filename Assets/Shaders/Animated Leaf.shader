Shader "Custom/Animated Leaf" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_OffsetY ("Offset Y",Range(0,0.1)) = 0.05
		_TimeRatio("Time Ratio", Range(0,5)) = 1
	}
	SubShader {
		Tags { "Queue" = "AlphaTest" "RenderType"="TransparentCutout" }

		cull off
		CGPROGRAM
		#pragma surface surf Lambert alphatest:_Cutoff vertex:vert noshadow

		sampler2D _MainTex;
		
		float _OffsetY;
		float _TimeRatio;

		struct Input {
			float2 uv_MainTex;
		};

		void vert(inout appdata_full v)
		{
			v.vertex.y += sin(_Time.y * _TimeRatio) * _OffsetY * v.texcoord.x * v.texcoord.y;
		}


		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
