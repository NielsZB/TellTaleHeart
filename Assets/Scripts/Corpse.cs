using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Corpse : MonoBehaviour
{
    Animator animator;
    CharacterJoint joint;
    public Transform Head;
    public Transform Legs;

    private void Start()
    {
        animator = GetComponent<Animator>();
    }

    public void GrabHead(Rigidbody playerRB)
    {
        animator.SetTrigger("GrabHead");
        //if (joint == null)
        //{
        //    joint = gameObject.AddComponent<CharacterJoint>();
        //}
        //joint.autoConfigureConnectedAnchor = false;
        //joint.connectedBody = playerRB;
        //joint.connectedAnchor = playerRB.transform.InverseTransformPoint(transform.forward * 0.1f);
        //Debug.DrawLine(transform.forward * 1f, transform.position);
        //joint.axis = Vector3.up;
        //joint.anchor = -Vector3.forward;
        //joint.enableProjection = true;
        //joint.connectedMassScale = 10f;
    }

    public void GrabLegs(Rigidbody playerRB)
    {
        animator.SetTrigger("GrabLegs");
        //if (joint == null)
        //{
        //    joint = gameObject.AddComponent<CharacterJoint>();
        //}
        //joint.autoConfigureConnectedAnchor = false;
        //joint.connectedBody = playerRB;
        //joint.connectedAnchor = playerRB.transform.InverseTransformPoint(transform.forward * 0.1f);

        //joint.axis = Vector3.up;
        //joint.anchor = -Vector3.forward;
        //joint.enableProjection = true;
        //joint.connectedMassScale = 10f;
    }

    public void Release()
    {
        animator.SetTrigger("Release");
        //Destroy(joint);
    }

}
