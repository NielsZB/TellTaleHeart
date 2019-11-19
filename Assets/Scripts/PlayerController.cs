using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    PlayerMovement movement;
    Grab hands;
    Vector2 movementInput;
    private void Start()
    {
        movement = GetComponent<PlayerMovement>();
        hands = GetComponentInChildren<Grab>();
    }

    private void Update()
    {
        movementInput.Set(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));

        movement.Move(movementInput);

        if (Input.GetButtonDown("Jump"))
        {
            hands.TryGrab();
        }

        if (Input.GetButtonUp("Jump"))
        {
            if (hands.HasObject)
            {
                hands.Release();
            }
        }
    }
}
