Shader "UI/Gradient/4 Corners"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _UpLeft ("Up Left Color", Color) = (0,0,0,1)
        _UpRight ("Up Right Color", Color) = (0,0,0,1)
        _DownLeft ("Down Left Color", Color) = (0,0,0,1)
        _DonwRight ("Down Right Color", Color) = (0,0,0,1)
        
        
        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255
        
        _ColorMask ("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
    }
    SubShader
    { Tags
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
            float4 _UpLeft;
            float4 _UpRight;
            float4 _DownLeft;
            float4 _DonwRight;

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
                float4 UpColor = lerp(_UpLeft, _UpRight, i.uv.x);
                float4 DownColor = lerp(_DownLeft, _DonwRight, i.uv.x);
                return tex2D(_MainTex, i.uv) * fixed4(lerp(DownColor, UpColor, i.uv.y).rgb, i.col.a);
            }
            ENDCG
        }
    }
}
