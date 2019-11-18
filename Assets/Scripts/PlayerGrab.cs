using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerGrab : MonoBehaviour
{
    List<GameObject> grabbableObjects = new List<GameObject>();
    GameObject grabbedObject = null;
    Rigidbody rb;
    Rigidbody rbGrabbedObject;
    bool grabbing;
    Animator animator;

    CorpseEnd corpseEnd;
    Vector3 corpseOffset;
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
        corpseEnd = GetClosestCorpseEnd();

        if (corpseEnd != null)
        {
            corpseOffset = corpseEnd.transform.position - transform.position;
            corpseEnd.Grab();
        }
        if (grabbedObject != null)
        {
            rbGrabbedObject = grabbedObject.GetComponent<Rigidbody>();
            grabbing = true;

        }
    }

    public void Release()
    {
        grabbedObject.GetComponent<Rigidbody>().WakeUp();
        rbGrabbedObject = null;
        grabbedObject = null;

        if(corpseEnd != null)
        {
            corpseEnd.Release();
            corpseEnd = null;
        }

        grabbing = false;
    }
    private void Start()
    {
        rb = GetComponentInParent<Rigidbody>();
        rb.maxAngularVelocity = 0f;
        animator = GetComponentInParent<Animator>();
    }

    public void Update()
    {
        //if (grabbing)
        //{
        //    rbGrabbedObject.velocity = rb.velocity;
        //}

        animator.SetBool("isGrabbing", grabbing);


    }
    public void FixedUpdate()
    {
        if (grabbing)
        {
            if (corpseEnd != null)
            {
                corpseEnd.UpdateRigidbody(transform.position + corpseOffset);
            }
        }
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
    private CorpseEnd GetClosestCorpseEnd()
    {
        float closestDistanceSqr = Mathf.Infinity;
        CorpseEnd closestEnd = null;
        Vector3 position = transform.position;

        for (int i = 0; i < grabbableObjects.Count; i++)
        {
            if (grabbableObjects[i].TryGetComponent(out CorpseEnd end))
            {
                float distanceSqr = (position - grabbableObjects[i].transform.position).sqrMagnitude;
                if (distanceSqr < closestDistanceSqr)
                {
                    closestDistanceSqr = distanceSqr;
                    closestEnd = end;
                }

            }

        }
        return closestEnd;
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
