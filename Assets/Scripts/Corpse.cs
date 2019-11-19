using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Corpse : MonoBehaviour
{
    Animator animator;
    CharacterJoint joint;
    [SerializeField] Transform head;
    [SerializeField] Transform legs;

    public Vector3 HeadPosition { get { return head.position; } }
    public Vector3 LegsPosition { get { return legs.position; } }
    private void Start()
    {
        animator = GetComponent<Animator>();
    }

    public void GrabHead(Rigidbody playerRB)
    {
        animator.SetTrigger("HeadsUp");
    }

    public void GrabLegs(Rigidbody playerRB)
    {
        animator.SetTrigger("LegsUp");
    }

    public void Release()
    {
        animator.SetTrigger("Release");
    }

}
