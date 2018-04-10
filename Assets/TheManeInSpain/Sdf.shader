Shader "New Chromantics/Sdf"
{
	Properties
	{
		ColourTexture ("ColourTexture", 2D) = "white" {}
		SdfTexture ("SdfTexture", 2D) = "white" {}
		ColourCount("ColourCount", Range(1,10)) = 10
		Colour0("Colour0", COLOR) = (1,0,0,1)
		Colour1("Colour1", COLOR) = (0,1,0,1)
		Colour2("Colour2", COLOR) = (1,1,0,1)
		Colour3("Colour3", COLOR) = (0,0,1,1)
		Colour4("Colour4", COLOR) = (1,0,1,1)
		Colour5("Colour5", COLOR) = (0,1,1,1)
		Colour6("Colour6", COLOR) = (1,1,1,1)
		Colour7("Colour7", COLOR) = (0,0,0,1)
		Colour8("Colour8", COLOR) = (0,0,0,1)
		Colour9("Colour9", COLOR) = (0,0,0,1)
		StripeCount("StripeCount", Range(1,40)) = 10
		EdgeDistance("EdgeDistance", Range(0.9,1) ) = 0.99
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D ColourTexture;
			float4 ColourTexture_ST;
			sampler2D SdfTexture;
			float4 Colour0;
			float4 Colour1;
			float4 Colour2;
			float4 Colour3;
			float4 Colour4;
			float4 Colour5;
			float4 Colour6;
			float4 Colour7;
			float4 Colour8;
			float4 Colour9;
			int ColourCount;
			float StripeCount;
			float EdgeDistance;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, ColourTexture);
				return o;
			}

			float4 GetColour(int Index)
			{
				float4 Colours[10];
				Colours[0] = Colour0;
				Colours[1] = Colour1;
				Colours[2] = Colour2;
				Colours[3] = Colour3;
				Colours[4] = Colour4;
				Colours[5] = Colour5;
				Colours[6] = Colour6;
				Colours[7] = Colour7;
				Colours[8] = Colour8;
				Colours[9] = Colour9;
				return Colours[Index];
			}

			
			fixed4 frag (v2f i) : SV_Target
			{
				float4 Colour = tex2D(ColourTexture,i.uv);
				Colour.a = 1;

				float Distance = tex2D(SdfTexture,i.uv).a;
				if ( Distance >= EdgeDistance )
					return Colour;

				Distance += _Time.y;
				Distance *= StripeCount;
				float Stripef = fmod( Distance, ColourCount );
				int Stripe = Stripef;
				return GetColour( Stripe );
			}
			ENDCG
		}
	}
}
