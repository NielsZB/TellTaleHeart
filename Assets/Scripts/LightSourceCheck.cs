using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightSourceCheck : MonoBehaviour
{
    enum LightSourceType
    {
        Directional,
        Point,
        spot
    }

    [SerializeField] LightSourceType type = LightSourceType.Point;
    [SerializeField, Tooltip("Only needed for the types Directional and Spot.")] Transform lightTransform = null;
    [SerializeField] LayerMask mask = new LayerMask();

    Transform corpse;

    bool inRange { get { return corpse != null; } }

    private void Update()
    {
        if (type == LightSourceType.Directional)
        {
            if (lightTransform == null)
            {
                Debug.Log($"{type} needs a lightTransform to work.", this);
                Debug.Break();
            }

            if (!Physics.Raycast(transform.position, -lightTransform.forward, 1000f, mask))
            {
                Debug.Log("Dead");
                Debug.DrawRay(transform.position, -lightTransform.forward * 10f);
            }
        }
        else if (type == LightSourceType.spot)
        {
            if (lightTransform == null)
            {
                Debug.Log($"{type} needs a lightTransform to work.", this);
                Debug.Break();
            }
            if (inRange)
            {
                Ray ray = new Ray()
                {
                    origin = lightTransform.position,
                    direction = corpse.position - lightTransform.position
                };
                if (Physics.Raycast(ray, out RaycastHit hit))
                {
                    if (hit.transform.CompareTag("Corpse"))
                    {
                        Debug.Log("Dead!");
                        Debug.DrawRay(ray.origin, corpse.position);
                    }
                }
            }
        }
        else if (type == LightSourceType.Point)
        {
            if (inRange)
            {
                Ray ray = new Ray()
                {
                    origin = transform.position,
                    direction = corpse.position - transform.position
                };
                if (Physics.Raycast(ray, out RaycastHit hit))
                {
                    if (hit.transform.CompareTag("Corpse"))
                    {
                        Debug.Log("Dead!");
                        Debug.DrawLine(ray.origin, corpse.position);
                    }
                }
            }
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Corpse"))
        {
            corpse = other.transform;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Corpse"))
        {
            corpse = null;
        }
    }
}
