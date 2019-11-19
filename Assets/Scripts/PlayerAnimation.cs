using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAnimation : MonoBehaviour
{
    PlayerMovement movement;
    Grab grab;
    Animator animator;

    int IsMovingHash;
    int IsGrabbingHash;
    void Start()
    {
        movement = GetComponent<PlayerMovement>();
        grab = GetComponentInChildren<Grab>();
        animator = GetComponent<Animator>();

        IsMovingHash = Animator.StringToHash("IsWalking");
        IsGrabbingHash = Animator.StringToHash("IsGrabbing");
    }

    private void Update()
    {
        animator.SetBool(IsMovingHash, movement.IsMoving);
        animator.SetBool(IsGrabbingHash, grab.HasObject);
    }
}
