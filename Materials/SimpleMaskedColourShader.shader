Shader "Custom/SimpleMaskedColourShader"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Base", 2D) = "white" {}
        [NoScaleOffset] _PTTex ("Primary Trigger Mask", 2D) = "white" {}
        [NoScaleOffset] _STTex ("Secondary Trigger Mask", 2D) = "white" {}
        [NoScaleOffset] _TTex ("Toggle Mask", 2D) = "white" {}
        [NoScaleOffset] _BOTex ("Button One Mask", 2D) = "white" {}
        [NoScaleOffset] _BOTTex ("Button One Text Mask", 2D) = "white" {}
        [NoScaleOffset] _BTTex ("Button Two Mask", 2D) = "white" {}
        [NoScaleOffset] _BTTTex ("Button Two Text Mask", 2D) = "white" {}
        [NoScaleOffset] _BMTex ("Button Main Mask", 2D) = "white" {}
        [NoScaleOffset] _BMTTex ("Button Main Text Mask", 2D) = "white" {}
        [NoScaleOffset] _TPTex ("Touchpad Mask", 2D) = "white" {}
        [NoScaleOffset] _TRTex ("Thumbrest Mask", 2D) = "white" {}

        // Allow the user to define a different colour for this object
        _PTColor ("Primary Trigger Color", Color) = (0.5,0.5,0.5,1)
        _STColor ("Secondary Trigger Color", Color) = (0.5,0.5,0.5,1)
        _TColor ("Toggle Color", Color) = (0,0,0,1)
        _BOColor ("Button One Color", Color) = (0,0,0,1)
        _BOTColor ("Button One Text Color", Color) = (1,1,1,1)
        _BTColor ("Button Two Color", Color) = (0,0,0,1)
        _BTTColor ("Button Two Text Color", Color) = (1,1,1,1)
        _BMColor ("Button Main Color", Color) = (0,0,0,1)
        _BMTColor ("Button Main Text Color", Color) = (1,1,1,1)
        _TPColor ("Touchpad Color", Color) = (0,0,0,1)
        _TRColor ("Thumbrest Color", Color) = (1,1,1,1)

        [MaterialToggle] _BaseEmit ("Base controller is emitting", Float) = 0
        [MaterialToggle] _PTEmit ("Primary Trigger is emitting", Float) = 0
        [MaterialToggle] _STEmit ("Secondary Trigger is emitting", Float) = 0
        [MaterialToggle] _TEmit ("Toggle is emitting", Float) = 0
        [MaterialToggle] _BOEmit ("Button One is emitting", Float) = 0
        [MaterialToggle] _BOTEmit ("Button One Text is emitting", Float) = 0
        [MaterialToggle] _BTEmit ("Button Two is emitting", Float) = 0
        [MaterialToggle] _BTTEmit ("Button Two Text is emitting", Float) = 0
        [MaterialToggle] _BMEmit ("Button Main is emitting", Float) = 0
        [MaterialToggle] _BMTEmit ("Button Main Text is emitting", Float) = 0
        [MaterialToggle] _TPEmit ("Touchpad is emitting", Float) = 0
        [MaterialToggle] _TREmit ("Thumbrest is emitting", Float) = 0

        _Glossiness ("Smoothness", Range(0,1)) = 1.0
        [HDR] _Emission ("Emission", Color) = (0,0,0)
        [NoScaleOffset] _MetallicTex ("Metallic", 2D) = "white" {}
        _Color ("Base Color", Color) = (1,1,1,1)
        _Black ("Black", Color) = (0,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        // texture we will sample
        sampler2D _MainTex;
        sampler2D _PTTex;
        sampler2D _STTex;
        sampler2D _TTex;
        sampler2D _BOTex;
        sampler2D _BOTTex;
        sampler2D _BTTex;
        sampler2D _BTTTex;
        sampler2D _BMTex;
        sampler2D _BMTTex;
        sampler2D _TPTex;
        sampler2D _TRTex;

        // color as defined in the material inspector
        fixed4 _PTColor;
        fixed4 _STColor;
        fixed4 _TColor;
        fixed4 _BOColor;
        fixed4 _BOTColor;
        fixed4 _BTColor;
        fixed4 _BTTColor;
        fixed4 _BMColor;
        fixed4 _BMTColor;
        fixed4 _TPColor;
        fixed4 _TRColor;

        float _BaseEmit;
        float _PTEmit;
        float _STEmit;
        float _TEmit;
        float _BOEmit;
        float _BOTEmit;
        float _BTEmit;
        float _BTTEmit;
        float _BMEmit;
        float _BMTEmit;
        float _TPEmit;
        float _TREmit;

        fixed4 _Color;
        half _Glossiness;
        half3 _Emission;
        half3 _Black;
        sampler2D _MetallicTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 baseCol = tex2D (_MainTex, IN.uv_MainTex) * _Color;

            fixed4 PTCol = tex2D(_PTTex, IN.uv_MainTex);
            fixed4 STCol = tex2D(_STTex, IN.uv_MainTex);
            fixed4 TCol = tex2D(_TTex, IN.uv_MainTex);
            fixed4 BOCol = tex2D(_BOTex, IN.uv_MainTex);
            fixed4 BOTCol = tex2D(_BOTTex, IN.uv_MainTex);
            fixed4 BTCol = tex2D(_BTTex, IN.uv_MainTex);
            fixed4 BTTCol = tex2D(_BTTTex, IN.uv_MainTex);
            fixed4 BMCol = tex2D(_BMTex, IN.uv_MainTex);
            fixed4 BMTCol = tex2D(_BMTTex, IN.uv_MainTex);
            fixed4 TPCol = tex2D(_TPTex, IN.uv_MainTex);
            fixed4 TRCol = tex2D(_TRTex, IN.uv_MainTex);

            fixed4 Metallic = tex2D(_MetallicTex, IN.uv_MainTex);

            fixed4 col = PTCol.a * _PTColor;
            col += STCol.a * _STColor;
            col += TCol.a * _TColor;
            col += BOCol.a * _BOColor;
            col += BOTCol.a * _BOTColor;
            col += BTCol.a * _BTColor;
            col += BTTCol.a * _BTTColor;
            col += BMCol.a * _BMColor;
            col += BMTCol.a * _BMTColor;
            col += TPCol.a * _TPColor;
            col += TRCol.a * _TRColor;

            float emiss = baseCol.a * _BaseEmit;
            emiss += PTCol.a * _PTEmit;
            emiss += STCol.a * _STEmit;
            emiss += TCol.a * _TEmit;
            emiss += BOCol.a * _BOEmit;
            emiss += BOTCol.a * _BOTEmit;
            emiss += BTCol.a * _BTEmit;
            emiss += BTTCol.a * _BTTEmit;
            emiss += BMCol.a * _BMEmit;
            emiss += BMTCol.a * _BMTEmit;
            emiss += TPCol.a * _TPEmit;
            emiss += TRCol.a * _TREmit;

            o.Albedo = col.a > 0.5 ? col.rgb : baseCol.rgb;
            o.Metallic = Metallic.r;
            o.Smoothness = Metallic.a * _Glossiness;
            _Emission = baseCol.a > 0.5 ? baseCol.rgb : col.rgb;
            o.Emission = emiss > 0.5 ? _Emission : _Black;
            o.Alpha = 1.0;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
