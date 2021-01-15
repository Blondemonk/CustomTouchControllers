# Custom Touch Controllers for the Oculus Quest 2


The Oculus Quest is a fantastic piece of technology, opening up a field of take-it-with-you virtual experiences with its high-quality display and solid hand/controller tracking. However, as part of my latest project ([Cover Drive Cricket](https://coverdrive.cricket)), I found that I wanted to customise the default controller models to provide a better onboarding experience - things like button highlighting, for example. Taking it to the extreme, how about the flexibility to do something like this?

![Customised Oculus Touch controllers](https://raw.githubusercontent.com/Blondemonk/CustomTouchControllers/main/Images/CustomTouch.png)

Maybe a bit extreme for onboarding, but very, very customisable! Here's how I did it...

(Disclaimer: The models are created by Oculus, and you should download the Oculus Integration package on Unity to use their models. Use of the materials in this blog is subject to the restrictions in the [Oculus SDK License Agreement](https://developer.oculus.com/licenses/oculussdk/))

## Oculus' Models
The base models that Oculus provides are part of the Oculus Integration package in Unity. If you're really interested, they can be found in `<ProjectName>/Oculus/VR/Meshes/OculusTouchForQuest2`, and the respective texures are in `<ProjectName>/Oculus/VR/Textures/OculusTouchForQuest2`. There should be two `.fbx` models, with respective `.png` files  (Left and Right) and a `Roughness.png` file too. They should look something like the images below.

Left Controller:

![Controller albedo image - Left](https://raw.githubusercontent.com/Blondemonk/CustomTouchControllers/main/Textures/OculusTouchForQuest2_Left_Orig.png)

Right controller:

![Controller albedo image - Right](https://raw.githubusercontent.com/Blondemonk/CustomTouchControllers/main/Textures/OculusTouchForQuest2_Right_Orig.png)

Roughness:

![Controller roughness image](https://raw.githubusercontent.com/Blondemonk/CustomTouchControllers/main/Textures/OculusTouchForQuest2_Roughness_Orig.png)

## Trial and Error
The idea here is to try and identify which parts of these images (specifically the left and right controllers - I'll leave roughness alone from this point on) map to which parts of the controller. Some parts are obvious - you can spot the Oculus logo immediately, and there are some interesting shapes and patterns to investigate. I've got to admit though, my approach was less than sophisticated and included simply colouring in areas of the images and checking Unity's re-rendered models to see if I'd hit a button or not!

After a little while, I ended up with the below:

Left Controller:

![Controller button masks - Left](https://raw.githubusercontent.com/Blondemonk/CustomTouchControllers/main/Images/OculusTouchForQuest2_Left.png)
[The right controller is the same, but with X/Y replaced with A/B]

The blue areas represent the primary trigger; the green areas are for the secondary trigger, and the red is the toggle. Why are there two areas? The smaller area represents the visible trigger/toggle, where as the larger area is generally for the sides/bottom of the triggers/toggle.

## Button Masks
As my shader knowledge is far from expert, I decided to split these images into separate masks, where each mask would either be a block of colour where the button is, or completely transparent where the button is not - I can then use a shader to set button colours individually based on the transparency of each mask. I also split out the text on each button into their own masks so that you can set text colour separately.

I'm always up for learning more, so please reach out to me if there's a better way and I'll update this post!

Y button

![Mask for the Y button](https://raw.githubusercontent.com/Blondemonk/CustomTouchControllers/main/Masks/Y_Mask.png)
![Mask for the text on the Y button](https://raw.githubusercontent.com/Blondemonk/CustomTouchControllers/main/Masks/Y_Text.png)

Settings button

![Mask for the Settings button](https://raw.githubusercontent.com/Blondemonk/CustomTouchControllers/main/Masks/Settings_Mask.png)
![Mask for the text on the Settings button](https://raw.githubusercontent.com/Blondemonk/CustomTouchControllers/main/Masks/Settings_Text.png)

Thumbrest

![Mask for the Thumbrest](https://raw.githubusercontent.com/Blondemonk/CustomTouchControllers/main/Masks/Thumbrest_Mask.png)

etc...

## Bringing It All Together
So, now we've got our button masks, let's write a shader so we can render our customised controllers in Unity.

Loosely, what we want to do is to be able to define a colour for each button/trigger/toggle (and the base colour for the controller) and then use the shader to determine whether each mask is transparent or not and therefore which colour to apply to that point of the model.

For bonus points, let's also add boolean switches to enable/disable emission for each button/trigger/toggle in our shader too!

[SimpleMaskedColourShader.shader](https://raw.githubusercontent.com/Blondemonk/CustomTouchControllers/main/Materials/SimpleMaskedColourShader.shader)
```
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
```
Phew, lots of copy-pasting!

To use this shader, you need to follow a few steps:
- Create new `OculusTouchForQuest2_Left.mat` and `OculusTouchForQuest2_Right.mat` files.
- Drag the `SimpleMaskedColourShader.shader` file onto each material.
- Drag the correct mask images into their respective slots on each shader.

![Setting the mask images in the shader](https://raw.githubusercontent.com/Blondemonk/CustomTouchControllers/main/Images/SettingMasks.PNG)

- Copy/move the Oculus `/fbx` models under your `OVRCameraRig` object (under the correct controller anchors).

![Putting the controllers in the right place](https://raw.githubusercontent.com/Blondemonk/CustomTouchControllers/main/Images/Anchors.PNG)

- Expand the models, select the mesh, and change the mesh material to use our new `OculusTouchForQuest2_Left.mat` or `OculusTouchForQuest2_Right.mat` material.

![Setting the mesh materials](https://raw.githubusercontent.com/Blondemonk/CustomTouchControllers/main/Images/Meshes.PNG)

Let's see how that's worked out:

<figure class="video_container">
  <iframe src="https://www.youtube.com/embed/9czztcSyk4Y" frameborder="0" allowfullscreen="true" height="400px" width="600px"> </iframe>
</figure>

## [Bonus] Script-activation
No that we've got our custom controller shader, what happens if we want to be able to change styles at run-time? Let's write some simple scripts to enable us to edit this on the fly.

[CustomControllerSystem.cs](https://raw.githubusercontent.com/Blondemonk/CustomTouchControllers/main/Code/CustomControllerSystem.cs)
```
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class ControllerHandler : MonoBehaviour
{
    [SerializeField]
    private GameObject leftController = default;
    [SerializeField]
    private GameObject rightController = default;

    private static Color red = new Color(1f, 0f, 0f);
    private static Color black = new Color(0f, 0f, 0f);

    void Awake()
    {
        UpdateControllers();
    }

    // Other logic that you might require...
    // This is a good centralised place to check if triggers are pressed, etc

    void UpdateControllers()
    {
        if (leftController == null || rightController == null)
        {
            // If you haven't pre-defined the controllers in the editor
            // Find them via tags at run-time
            GameObject[] controllers = GameObject.FindGameObjectsWithTag("GameController");
            // Bit of an assumption, but this can be changed if needed
            leftController = controllers[0];
            rightController = controllers[1];

            leftController.GetComponentInChildren<CustomControllerSystem>().Awake();
            rightController.GetComponentInChildren<CustomControllerSystem>().Awake();
        }
    }

    // Convenience methods
    public static void HighlightButtonOne(bool active)
    {
        HighlightButtonOne(active, true);
        HighlightButtonOne(active, false);
    }

    public static void HighlightButtonOne(bool active, bool isLeft)
    {
        if (active)
        {
            SetButtonOneColour(red, isLeft);
            SetButtonOneTextColour(black, isLeft);
            SetButtonOneEmit(true, isLeft);
            SetButtonOneTextEmit(true, isLeft);
        }
        else
        {
            SetDefaultButtonOneColour(isLeft);
            SetDefaultButtonOneTextColour(isLeft);
            SetButtonOneEmit(false, isLeft);
            SetButtonOneTextEmit(false, isLeft);
        }
    }

    public static void HighlightButtonTwo(bool active)
    {
        HighlightButtonTwo(active, true);
        HighlightButtonTwo(active, false);
    }

    public static void HighlightButtonTwo(bool active, bool isLeft)
    {
        if (active)
        {
            SetButtonTwoColour(red, isLeft);
            SetButtonTwoTextColour(black, isLeft);
            SetButtonTwoEmit(true, isLeft);
            SetButtonTwoTextEmit(true, isLeft);
        }
        else
        {
            SetDefaultButtonTwoColour(isLeft);
            SetDefaultButtonTwoTextColour(isLeft);
            SetButtonTwoEmit(false, isLeft);
            SetButtonTwoTextEmit(false, isLeft);
        }
    }

    public static void HighlightToggle(bool active)
    {
        HighlightToggle(active, true);
        HighlightToggle(active, false);
    }

    public static void HighlightToggle(bool active, bool isLeft)
    {
        if (active)
        {
            SetToggleColour(red, isLeft);
            SetToggleEmit(true, isLeft);
        }
        else
        {
            SetDefaultToggleColour(isLeft);
            SetToggleEmit(false, isLeft);
        }
    }

    public static void HighlightPrimaryTrigger(bool active)
    {
        HighlightPrimaryTrigger(active, true);
        HighlightPrimaryTrigger(active, false);
    }

    public static void HighlightPrimaryTrigger(bool active, bool isLeft)
    {
        if (active)
        {
            SetPrimaryTriggerColour(red, isLeft);
            SetPrimaryTriggerEmit(true, isLeft);
        }
        else
        {
            SetDefaultPrimaryTriggerColour(isLeft);
            SetPrimaryTriggerEmit(false, isLeft);
        }
    }

    public static void HighlightSecondaryTrigger(bool active)
    {
        HighlightSecondaryTrigger(active, true);
        HighlightSecondaryTrigger(active, false);
    }

    public static void HighlightSecondaryTrigger(bool active, bool isLeft)
    {
        if (active)
        {
            SetSecondaryTriggerColour(red, isLeft);
            SetSecondaryTriggerEmit(true, isLeft);
        }
        else
        {
            SetDefaultSecondaryTriggerColour(isLeft);
            SetSecondaryTriggerEmit(false, isLeft);
        }
    }


    // Base methods for all buttons
    public static void SetControllerButtonColour(ControllerEnum button, Color col, bool isLeft)
    {
        if (isLeft)
        {
            if (leftController != null)
                leftController.GetComponentInChildren<CustomControllerSystem>().SetControllerButtonColour(button, col);
        }
        else
        {
            if (rightController != null)
                rightController.GetComponentInChildren<CustomControllerSystem>().SetControllerButtonColour(button, col);
        }
    }

    public static void SetControllerButtonEmit(ControllerEnum button, bool on, bool isLeft)
    {
        if (isLeft)
        {
            if (leftController != null)
                leftController.GetComponentInChildren<CustomControllerSystem>().SetControllerButtonEmit(button, on);
        }
        else
        {
            if (rightController != null)
                rightController.GetComponentInChildren<CustomControllerSystem>().SetControllerButtonEmit(button, on);
        }
    }

    public static void SetControllerDefaultButtonColour(ControllerEnum button, bool isLeft)
    {
        if (isLeft)
        {
            if (leftController != null)
                leftController.GetComponentInChildren<CustomControllerSystem>().SetControllerDefaultButtonColour(button);
        }
        else
        {
            if (rightController != null)
                rightController.GetComponentInChildren<CustomControllerSystem>().SetControllerDefaultButtonColour(button);
        }
    }

    // Button One
    public static void SetButtonOneColour(Color col, bool isLeft)
    {
        SetControllerButtonColour(ControllerEnum.BUTTON_ONE, col, isLeft);
    }

    public static void SetButtonOneEmit(bool on, bool isLeft)
    {
        SetControllerButtonEmit(ControllerEnum.BUTTON_ONE, on, isLeft);
    }

    public static void SetDefaultButtonOneColour(bool isLeft)
    {
        SetControllerDefaultButtonColour(ControllerEnum.BUTTON_ONE, isLeft);
    }

    // Button One Text
    public static void SetButtonOneTextColour(Color col, bool isLeft)
    {
        SetControllerButtonColour(ControllerEnum.BUTTON_ONE_TEXT, col, isLeft);
    }

    public static void SetButtonOneTextEmit(bool on, bool isLeft)
    {
        SetControllerButtonEmit(ControllerEnum.BUTTON_ONE_TEXT, on, isLeft);
    }

    public static void SetDefaultButtonOneTextColour(bool isLeft)
    {
        SetControllerDefaultButtonColour(ControllerEnum.BUTTON_ONE_TEXT, isLeft);
    }

    // Button Two
    public static void SetButtonTwoColour(Color col, bool isLeft)
    {
        SetControllerButtonColour(ControllerEnum.BUTTON_TWO, col, isLeft);
    }

    public static void SetButtonTwoEmit(bool on, bool isLeft)
    {
        SetControllerButtonEmit(ControllerEnum.BUTTON_TWO, on, isLeft);
    }

    public static void SetDefaultButtonTwoColour(bool isLeft)
    {
        SetControllerDefaultButtonColour(ControllerEnum.BUTTON_TWO, isLeft);
    }

    // Button Two Text
    public static void SetButtonTwoTextColour(Color col, bool isLeft)
    {
        SetControllerButtonColour(ControllerEnum.BUTTON_TWO_TEXT, col, isLeft);
    }

    public static void SetButtonTwoTextEmit(bool on, bool isLeft)
    {
        SetControllerButtonEmit(ControllerEnum.BUTTON_TWO_TEXT, on, isLeft);
    }

    public static void SetDefaultButtonTwoTextColour(bool isLeft)
    {
        SetControllerDefaultButtonColour(ControllerEnum.BUTTON_TWO_TEXT, isLeft);
    }

    // Toggle
    public static void SetToggleColour(Color col, bool isLeft)
    {
        SetControllerButtonColour(ControllerEnum.TOGGLE, col, isLeft);
    }

    public static void SetToggleEmit(bool on, bool isLeft)
    {
        SetControllerButtonColour(ControllerEnum.TOGGLE, on, isLeft);
    }

    public static void SetDefaultToggleColour(bool isLeft)
    {
        SetControllerDefaultButtonColour(ControllerEnum.TOGGLE, isLeft);
    }

    // Primary Trigger
    public static void SetPrimaryTriggerColour(Color col, bool isLeft)
    {
        SetControllerButtonColour(ControllerEnum.PRIMARY_TRIGGER, col, isLeft);
    }

    public static void SetPrimaryTriggerEmit(bool on, bool isLeft)
    {
        SetControllerButtonEmit(ControllerEnum.PRIMARY_TRIGGER, on, isLeft);
    }

    public static void SetDefaultPrimaryTriggerColour(bool isLeft)
    {
        SetControllerDefaultButtonColour(ControllerEnum.PRIMARY_TRIGGER, isLeft);
    }

    // Secondary Trigger
    public static void SetSecondaryTriggerColour(Color col, bool isLeft)
    {
        SetControllerButtonColour(ControllerEnum.SECONDARY_TRIGGER, col, isLeft);
    }

    public static void SetSecondaryTriggerEmit(bool on, bool isLeft)
    {
        SetControllerButtonEmit(ControllerEnum.SECONDARY_TRIGGER, on, isLeft);
    }

    public static void SetDefaultSecondaryTriggerColour(bool isLeft)
    {
        SetControllerDefaultButtonColour(ControllerEnum.SECONDARY_TRIGGER, isLeft);
    }
}
```
This script essentially defines static convenience methods to set a button's colour or emission, then you can just call `HighlightButtonOne(true);` from another script to set the A and X buttons to red.

To use, place `CustomControllerSystem.cs` on your controller models, and then add `ControllerHandler.cs` to your scene as you would for other central logic (I use empty GameObjects, though I'm aware I should read up on Scriptable Objects!).

And that's it - thanks for reading. If you've any questions, please reach out!
