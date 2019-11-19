using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;



namespace Drifter.Lib.Components.Framework
{
    public class SceneLightController : MonoBehaviour
    {
    
        float lastFrameTime;

        public AnimationCurve lightCurve;

        public Light _light;
        public Material _mat;
        // Start is called before the first frame update
        private void Awake()
        {
            
            _light = GetComponent<Light>();
            lastFrameTime = lightCurve.keys.LastOrDefault().time;
        

           
        }


        // Update is called once per frame
        private void Update()
        {
            if (_light != null)
            {
                _light.intensity = lightCurve.Evaluate(Time.realtimeSinceStartup % lastFrameTime);
            }
            else if (_mat != null)
            {
                _mat.SetFloat("_Alpha", lightCurve.Evaluate(Time.realtimeSinceStartup % lastFrameTime));
            }
            
        }
    }
}
