using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Goal : MonoBehaviour
{
    public bool bodyInGoal { get; private set; }

    Transition transition;


    private void Start()
    {
        transition = FindObjectOfType<Transition>();
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Body"))
        {
            transition.TransitionToBlack();
        }
    }
}