﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerGrab : MonoBehaviour
{
    [SerializeField] LayerMask mask = new LayerMask();
    List<GameObject> grabbableObjects = new List<GameObject>();
    GameObject grabbedObject = null;
    Rigidbody rb;

    public bool HasObject
    {
        get
        {
            return grabbedObject != null;
        }
    }

    public void Grab()
    {
        grabbedObject = GetClosestGameobject();

        Ray ray = new Ray
        {
            origin = transform.position,
            direction = grabbedObject.transform.position - transform.position
        };


        
        SpringJoint joint = grabbedObject.AddComponent<SpringJoint>();
        joint.connectedBody = rb;
        joint.connectedAnchor.Set(0f, 0.5f, 1f);
        joint.spring = 20f;
        joint.damper = 0.5f;
        joint.massScale = 10f;
        joint.enableCollision = true;

    }

    public void Release()
    {
        Destroy(grabbedObject.GetComponent<SpringJoint>());
        grabbedObject.GetComponent<Rigidbody>().WakeUp();
        grabbedObject = null;

    }
    private void Start()
    {
        rb = GetComponentInParent<Rigidbody>();
        rb.maxAngularVelocity = 0f;
    }

    private GameObject GetClosestGameobject()
    {
        float closestDistanceSqr = Mathf.Infinity;
        GameObject closestGameObject = null;
        Vector3 position = transform.position;

        for (int i = 0; i < grabbableObjects.Count; i++)
        {
            float distanceSqr = (position - grabbableObjects[i].transform.position).sqrMagnitude;

            if (distanceSqr < closestDistanceSqr)
            {
                closestDistanceSqr = distanceSqr;
                closestGameObject = grabbableObjects[i];
            }
        }
        return closestGameObject;
    }

    private void OnTriggerEnter(Collider other)
    {
        grabbableObjects.Add(other.gameObject);
    }
    private void OnTriggerExit(Collider other)
    {
        if (grabbableObjects.Contains(other.gameObject))
        {
            grabbableObjects.Remove(other.gameObject);
        }
    }

    //List<HingeJoint> grabbableObjects;
    //HingeJoint grabbedObject;
    //Rigidbody rb;

    //public bool HasObject
    //{
    //    get
    //    {
    //        return grabbedObject != null;
    //    }
    //}
    //private void Start()
    //{
    //    rb = GetComponent<Rigidbody>();
    //    grabbableObjects = new List<HingeJoint>();
    //}

    //public void Grab()
    //{

    //    if (grabbableObjects.Count <= 0)
    //        return;

    //    grabbedObject = GetClosestHinge();

    //    grabbedObject.connectedBody = rb;
    //}

    //public void Release()
    //{
    //    grabbedObject.connectedBody = null;
    //    grabbedObject = null;
    //}


    //HingeJoint GetClosestHinge()
    //{
    //    float closestDistanceSqr = Mathf.Infinity;
    //    HingeJoint closestHinge = null;
    //    Vector3 position = transform.position;

    //    for (int i = 0; i < grabbableObjects.Count; i++)
    //    {
    //        float distanceSqr = (position - grabbableObjects[i].transform.position).sqrMagnitude;

    //        if (distanceSqr < closestDistanceSqr)
    //        {
    //            closestDistanceSqr = distanceSqr;
    //            closestHinge = grabbableObjects[i];
    //        }
    //    }

    //    return closestHinge;
    //}


    //private void OnTriggerEnter(Collider other)
    //{
    //    if (other.TryGetComponent(out HingeJoint grabObject))
    //    {
    //        Debug.Log(grabObject,grabObject.gameObject);
    //        grabbableObjects.Add(grabObject);
    //    }
    //}

    //private void OnTriggerExit(Collider other)
    //{
    //    if (other.TryGetComponent(out HingeJoint grabObject))
    //    {
    //        grabbableObjects.Remove(grabObject);
    //    }
    //}
}
