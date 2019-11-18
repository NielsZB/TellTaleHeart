using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawWithMouse : MonoBehaviour
{
    public Camera _camera;
    public Shader _DrawShader;
    [Range(1, 500)]
    public float brushSize;
    [Range(0, 1)]
    public float brushStrenght;

    private RenderTexture _Splatmap;
    private Material _BloodMaterial, _DrawMaterial;


    private RaycastHit _hit;

    // Start is called before the first frame update
    void Start()
    {
        _DrawMaterial = new Material(_DrawShader);
        _DrawMaterial.SetVector("_Color", Color.red);

        _BloodMaterial = GetComponent<MeshRenderer>().material;
        _Splatmap = new RenderTexture(1024,1024, 0, RenderTextureFormat.ARGBFloat);
        _BloodMaterial.SetTexture("_MainTex", _Splatmap);
    }

    // Update is called once per frame
    void Update()
    {



        if(Input.GetKey(KeyCode.Mouse2))
        {
            if (Physics.Raycast(_camera.ScreenPointToRay(Input.mousePosition), out _hit))
            {
                _DrawMaterial.SetVector("_Coordinate", new Vector4(_hit.textureCoord.x, _hit.textureCoord.y,0 ,0));
                _DrawMaterial.SetFloat("_Size", brushSize);
                _DrawMaterial.SetFloat("_Strenght", brushStrenght);
                RenderTexture temp = RenderTexture.GetTemporary(_Splatmap.width, _Splatmap.height, 0, RenderTextureFormat.ARGBFloat);
                Graphics.Blit(_Splatmap, temp);
                Graphics.Blit(temp, _Splatmap, _DrawMaterial);
                RenderTexture.ReleaseTemporary(temp);

            }
        }
    }
}
