Shader "UI/Gradient/Linear"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _UpColor ("Up Coror", Color) = (0,0,0,1)
        _MidColor ("Mid Coror", Color) = (0,0,0,1)
        _DownCol ("Down Color", Color) = (0,0,0,1)
        [Toggle(USE_HORIZONTAL)] _UseHorizontal ("Use Horizontal", Float) = 0
        
        
        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255
        
        _ColorMask ("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
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
        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask [_ColorMask]
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
                float4 col: COLOR;
                float4 vertex : SV_POSITION;
            };
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _UpColor;
            float4 _MidColor;
            float4 _DownCol;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.col = v.col;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
#ifdef USE_HORIZONTAL
                fixed Lerp = i.uv.x;
#else
                fixed Lerp = i.uv.y;
#endif
                fixed4 multiplyColor = fixed4(1,1,1,1);
                if (Lerp < 0.5)
                {
                    multiplyColor = lerp(_DownCol, _MidColor, Lerp / 0.5);
                }
                else
                {
                    multiplyColor = lerp(_MidColor, _UpColor, (Lerp-0.5) / 0.5);
                }
                multiplyColor.a = i.col.a;
                return tex2D(_MainTex, i.uv) * multiplyColor;
            }
            ENDCG
        }
    }
}
