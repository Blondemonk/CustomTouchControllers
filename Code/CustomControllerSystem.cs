using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public enum ControllerEnum
{
    BASE,
    BUTTON_ONE,
    BUTTON_ONE_TEXT,
    BUTTON_TWO,
    BUTTON_TWO_TEXT,
    BUTTON_MAIN,
    BUTTON_MAIN_TEXT,
    TOGGLE,
    PRIMARY_TRIGGER,
    SECONDARY_TRIGGER,
    TOUCHPAD,
    THUMBREST
}

public class CustomControllerSystem : MonoBehaviour
{
    private Dictionary<ControllerEnum, string> buttonColourMap = new Dictionary<ControllerEnum, string>();
    private Dictionary<ControllerEnum, string> buttonEmitMap = new Dictionary<ControllerEnum, string>();
    private Dictionary<ControllerEnum, Color> defaultColourMap = new Dictionary<ControllerEnum, Color>();

    public void Awake()
    {
        buttonColourMap[ControllerEnum.BASE] = "_Color";
        buttonColourMap[ControllerEnum.BUTTON_ONE] = "_BOColor";
        buttonColourMap[ControllerEnum.BUTTON_ONE_TEXT] = "_BOTColor";
        buttonColourMap[ControllerEnum.BUTTON_TWO] = "_BTColor";
        buttonColourMap[ControllerEnum.BUTTON_TWO_TEXT] = "_BTTColor";
        buttonColourMap[ControllerEnum.BUTTON_MAIN] = "_BMColor";
        buttonColourMap[ControllerEnum.BUTTON_MAIN_TEXT] = "_BMTColor";
        buttonColourMap[ControllerEnum.TOGGLE] = "_TColor";
        buttonColourMap[ControllerEnum.PRIMARY_TRIGGER] = "_PTColor";
        buttonColourMap[ControllerEnum.SECONDARY_TRIGGER] = "_STColor";
        buttonColourMap[ControllerEnum.TOUCHPAD] = "_TPColor";
        buttonColourMap[ControllerEnum.THUMBREST] = "_TRColor";

        buttonEmitMap[ControllerEnum.BASE] = "_BaseEmit";
        buttonEmitMap[ControllerEnum.BUTTON_ONE] = "_BOEmit";
        buttonEmitMap[ControllerEnum.BUTTON_ONE_TEXT] = "_BOTEmit";
        buttonEmitMap[ControllerEnum.BUTTON_TWO] = "_BTEmit";
        buttonEmitMap[ControllerEnum.BUTTON_TWO_TEXT] = "_BTTEmit";
        buttonEmitMap[ControllerEnum.BUTTON_MAIN] = "_BMEmit";
        buttonEmitMap[ControllerEnum.BUTTON_MAIN_TEXT] = "_BMTEmit";
        buttonEmitMap[ControllerEnum.TOGGLE] = "_TColor";
        buttonEmitMap[ControllerEnum.PRIMARY_TRIGGER] = "_PTEmit";
        buttonEmitMap[ControllerEnum.SECONDARY_TRIGGER] = "_STEmit";
        buttonEmitMap[ControllerEnum.TOUCHPAD] = "_TPEmit";
        buttonEmitMap[ControllerEnum.THUMBREST] = "_TREmit";

        GetDefaultColours();
    }

    public void SetControllerButtonColour(ControllerEnum button, Color col)
    {
        SetColour(buttonColourMap[button], col);
    }

    void SetColour(string colName, Color col)
    {
        gameObject.GetComponent<Renderer>().material.SetColor(colName, col);
    }

    public void SetControllerButtonEmit(ControllerEnum button, bool on)
    {
        SetEmit(buttonEmitMap[button], on);
    }

    void SetEmit(string colName, bool on)
    {
        if (on)
            gameObject.GetComponent<Renderer>().material.SetFloat(colName, 1.0f);
        else
            gameObject.GetComponent<Renderer>().material.SetFloat(colName, 0.0f);
    }

    public void SetControllerDefaultButtonColour(ControllerEnum button)
    {
        SetColour(buttonColourMap[button], defaultColourMap[button]);
    }

    void GetDefaultColours()
    {
        Renderer renderer = gameObject.GetComponent<Renderer>();

        foreach(ControllerEnum button in Enum.GetValues(typeof(ControllerEnum)))
        {
            defaultColourMap[button] = renderer.material.GetColor(buttonColourMap[button]);
        }
    }
}
