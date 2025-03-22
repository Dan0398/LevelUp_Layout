Shader "UI/Gradient/Rounded Repeat"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _CenterColor ("Center Color", Color) = (0, 0, 0, 1)
        [Toggle(USE_HORIZONTAL)] _UseHorizontal ("Use Horizontal", Float) = 0
    }
    SubShader
    { 
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #pragma multi_compile_local _ USE_HORIZONTAL

            struct appdata
            {
                float4 vertex : POSITION;
                float4 col: COLOR;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 scrPos: TEXCOORD1;
                float4 col: COLOR;
                float4 vertex : SV_POSITION;
            };
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _CenterColor;
            float _DitherScale;
            float _DitherScreenSize;
            float4 _DitherCol;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.scrPos = ComputeScreenPos(o.vertex) * _DitherScreenSize;
                o.col = v.col;
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
#ifdef USE_HORIZONTAL
                fixed Lerp = i.uv.x;
#else
                fixed Lerp = i.uv.y;
#endif
                Lerp = abs(0.5 - Lerp);
                Lerp = sin(radians(Lerp * 90));
                Lerp = pow(Lerp, 2);
                return lerp(_CenterColor, i.col, Lerp);
            }
            ENDCG
        }
    }
}
