using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ReplacementShaderEffect : MonoBehaviour
{
    [SerializeField]
    private Color _color;
    [SerializeField]
    private float _slider;
    [SerializeField]
    private Shader _replacementShader;

    void OnValidate()
    {
        Shader.SetGlobalColor("_Color_1", _color);
    }

    private void Update()
    {
        Shader.SetGlobalFloat("_Temp", _slider);
    }

    void OnEnable()
    {
        if (_replacementShader != null)
        {
            GetComponent<Camera>().SetReplacementShader(_replacementShader, "");
        }
    }

    void OnDisable()
    {
        GetComponent<Camera>().ResetReplacementShader();
    }

}