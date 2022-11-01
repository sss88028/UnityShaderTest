using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoRotate : MonoBehaviour
{
    #region private-field
    [SerializeField]
    private float _rotateSpeed = 1.0f;
    #endregion private-field

    #region MonoBehaviour-method
    private void Update()
    {
        transform.Rotate(Vector3.up, 45 * _rotateSpeed * Time.deltaTime);
    }
    #endregion MonoBehaviour-method
}
