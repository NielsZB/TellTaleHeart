using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeadBodyBloodTrack : MonoBehaviour
{

    public Shader _DrawShader;

    public GameObject _bloodTerrain;


    private RenderTexture _Splatmap;

    private Material _DrawMaterial;
    private Material myMaterial;
    private Transform body;

    private RaycastHit _bloodAreaHit;
    int _LayerMask;

    [Range(1, 500)]
    public float brushSize;
    [Range(0, 1)]
    public float brushStrenght;



    // Start is called before the first frame update
    void Start()
    {
        _bloodTerrain = GameObject.FindGameObjectWithTag("BloodFloor");
        body = GetComponent<Transform>();
        _LayerMask = LayerMask.GetMask("TransparentFX");
        _DrawMaterial = new Material(_DrawShader);
        myMaterial = _bloodTerrain.GetComponent<MeshRenderer>().material;
        myMaterial.SetTexture("_MainTex", _Splatmap = new RenderTexture(1024, 1024, 0, RenderTextureFormat.ARGBFloat));
    }

    // Update is called once per frame
    void Update()
    {
        if (Physics.Raycast(body.position, -Vector3.up, out _bloodAreaHit, 4f, _LayerMask ))
        {
            _DrawMaterial.SetVector("_Coordinate", new Vector4(_bloodAreaHit.textureCoord.x, _bloodAreaHit.textureCoord.y, 0, 0));
            _DrawMaterial.SetFloat("_Size", brushSize);
            _DrawMaterial.SetFloat("_Strenght", brushStrenght);
            RenderTexture temp = RenderTexture.GetTemporary(_Splatmap.width, _Splatmap.height, 0, RenderTextureFormat.ARGBFloat);
            Graphics.Blit(_Splatmap, temp);
            Graphics.Blit(temp, _Splatmap, _DrawMaterial);
            RenderTexture.ReleaseTemporary(temp);

        }
    }
}
