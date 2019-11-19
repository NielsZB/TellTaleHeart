using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Grab : MonoBehaviour
{
    List<Rigidbody> objectsInRange = new List<Rigidbody>();

    public Rigidbody GrabbedObject { get; private set; }
    public bool HasObject { get { return GrabbedObject != null; } }

    public void TryGrab()
    {
        GrabbedObject = GetClosestObject();

        if (!HasObject)
            return;
        
        SpringJoint joint = gameObject.AddComponent<SpringJoint>();

        joint.spring = 100f;
        joint.connectedBody = GrabbedObject;

        if (GrabbedObject.TryGetComponent(out Corpse corpse))
        {
            float distanceToHeadSqr = (corpse.HeadPosition - transform.position).sqrMagnitude;
            float distanceToLegsSqr = (corpse.LegsPosition - transform.position).sqrMagnitude;

            if (distanceToHeadSqr > distanceToLegsSqr)
            {
                corpse.GrabLegs(GetComponentInParent<Rigidbody>());
            }
            else
            {
                corpse.GrabHead(GetComponentInParent<Rigidbody>());
            }
        }
    }

    public void Release()
    {
        if (GrabbedObject != null)
        {
            if (GrabbedObject.TryGetComponent(out Corpse corpse))
            {
                corpse.Release();
            }

            Destroy(GetComponent<SpringJoint>());
            GrabbedObject = null;

        }
    }
    
    
    Rigidbody GetClosestObject()
    {
        if (objectsInRange.Count == 0)
            return null;

        float closestDistanceSqr = Mathf.Infinity;
        Rigidbody closestObject = null;
        Vector3 position = transform.position;
        for (int i = 0; i < objectsInRange.Count; i++)
        {
            float distanceSqr = (objectsInRange[i].transform.position - position).sqrMagnitude;

            if (distanceSqr < closestDistanceSqr)
            {
                closestDistanceSqr = distanceSqr;
                closestObject = objectsInRange[i];
            }
        }

        return closestObject;
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.TryGetComponent(out Rigidbody otherBody))
        {
            objectsInRange.Add(otherBody);

        }
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.TryGetComponent(out Rigidbody otherBody))
        {
            if (otherBody == GrabbedObject)
            {
                Release();
            }
            objectsInRange.Remove(otherBody);

        }
    }
}
