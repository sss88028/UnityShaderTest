using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class Post : MonoBehaviour
{
    #region private-field
    [SerializeField]
    private Material _effectMaterial;
    #endregion private-field

    #region MonoBehaviour-method
    private void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        if (_effectMaterial != null)
        {
            Graphics.Blit(src, dst, _effectMaterial);
        }
    }
    #endregion MonoBehaviour-method
}