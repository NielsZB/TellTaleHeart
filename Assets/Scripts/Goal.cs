using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Goal : MonoBehaviour
{
    public bool Won;
    public Animator animator;

    private void OnTriggerEnter(Collider other)
    {
        if(other.CompareTag("Corpse"))
        {
            Won = true;
            animator.SetTrigger("Won");
        }
    }
}