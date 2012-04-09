Shader "Planet/Atmosfera2"
{
	Properties 
	{
_BaseNubes("_BaseNubes", 2D) = "black" {}
_Velocidad("_Velocidad", Float) = 0.01
_PaletaColor("_PaletaColor", 2D) = "black" {}
_Ilum("_Ilum", 2D) = "black" {}
_atmCerca("_atmCerca", Color) = (0.3706838,0.4156485,0.9552239,1)
_atmLejos("_atmLejos", Color) = (0,0.9160838,1,1)
_Espesura("_Espesura", Float) = 3
_alturaNubes("_alturaNubes", Range(-0.1,2) ) = -0.1
_prueba1("_prueba1", Float) = 0.1

	}
	
	SubShader 
	{
		Tags
		{
"Queue"="Transparent"
"IgnoreProjector"="False"
"RenderType"="Transparent"

		}

		
Cull Back
ZWrite On
ZTest LEqual
ColorMask RGBA
Blend SrcAlpha OneMinusDstAlpha
Fog{
Color (0.6285365,0.8134524,0.8507463,1)
Density 2
}


		CGPROGRAM
#pragma surface surf BlinnPhongEditor  fullforwardshadows vertex:vert
#pragma target 3.0


sampler2D _BaseNubes;
float _Velocidad;
sampler2D _PaletaColor;
sampler2D _Ilum;
float4 _atmCerca;
float4 _atmLejos;
float _Espesura;
float _alturaNubes;
float _prueba1;

			struct EditorSurfaceOutput {
				half3 Albedo;
				half3 Normal;
				half3 Emission;
				half3 Gloss;
				half Specular;
				half Alpha;
				half4 Custom;
			};
			
			inline half4 LightingBlinnPhongEditor_PrePass (EditorSurfaceOutput s, half4 light)
			{
half3 spec = light.a * s.Gloss;
half4 c;
c.rgb = (s.Albedo * light.rgb + light.rgb * spec);
c.a = s.Alpha;
return c;

			}

			inline half4 LightingBlinnPhongEditor (EditorSurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
			{
				half3 h = normalize (lightDir + viewDir);
				
				half diff = max (0, dot ( lightDir, s.Normal ));
				
				float nh = max (0, dot (s.Normal, h));
				float spec = pow (nh, s.Specular*128.0);
				
				half4 res;
				res.rgb = _LightColor0.rgb * diff;
				res.w = spec * Luminance (_LightColor0.rgb);
				res *= atten * 2.0;

				return LightingBlinnPhongEditor_PrePass( s, res );
			}
			
			struct Input {
				float3 viewDir;
float2 uv_BaseNubes;

			};

			void vert (inout appdata_full v, out Input o) {
float4 VertexOutputMaster0_0_NoInput = float4(0,0,0,0);
float4 VertexOutputMaster0_1_NoInput = float4(0,0,0,0);
float4 VertexOutputMaster0_2_NoInput = float4(0,0,0,0);
float4 VertexOutputMaster0_3_NoInput = float4(0,0,0,0);


			}
			

			void surf (Input IN, inout EditorSurfaceOutput o) {
				o.Normal = float3(0.0,0.0,1.0);
				o.Alpha = 1.0;
				o.Albedo = 0.0;
				o.Emission = 0.0;
				o.Gloss = 0.0;
				o.Specular = 0.0;
				o.Custom = 0.0;
				
float4 Fresnel0_1_NoInput = float4(0,0,1,1);
float4 Fresnel0=(1.0 - dot( normalize( float4( IN.viewDir.x, IN.viewDir.y,IN.viewDir.z,1.0 ).xyz), normalize( Fresnel0_1_NoInput.xyz ) )).xxxx;
float4 Pow0=pow(Fresnel0,_Espesura.xxxx);
float4 Saturate0=saturate(Pow0);
float4 Lerp0=lerp(_atmCerca,_atmLejos,Saturate0);
float4 Multiply0=Lerp0 * Saturate0;
float4 Multiply1=_Time * _Velocidad.xxxx;
float4 UV_Pan0=float4((IN.uv_BaseNubes.xyxy).x + Multiply1.y,(IN.uv_BaseNubes.xyxy).y,(IN.uv_BaseNubes.xyxy).z,(IN.uv_BaseNubes.xyxy).w);
float4 Tex2D1=tex2D(_BaseNubes,UV_Pan0.xy);
float4 Add1=Multiply0 + Tex2D1;
float4 Multiply3=Tex2D1 * _prueba1.xxxx;
float4 Master0_1_NoInput = float4(0,0,1,1);
float4 Master0_2_NoInput = float4(0,0,0,0);
float4 Master0_3_NoInput = float4(0,0,0,0);
float4 Master0_4_NoInput = float4(0,0,0,0);
float4 Master0_7_NoInput = float4(0,0,0,0);
float4 Master0_6_NoInput = float4(1,1,1,1);
o.Albedo = Add1;
o.Alpha = Multiply3;

				o.Normal = normalize(o.Normal);
			}
		ENDCG
	}
	Fallback "Diffuse"
}