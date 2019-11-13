using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    PlayerMovement movement;
    PlayerGrab hands;
    Vector2 movementInput;
    bool grabbed;
    private void Start()
    {
        movement = GetComponent<PlayerMovement>();
        hands = GetComponentInChildren<PlayerGrab>();
    }

    private void Update()
    {
        movementInput.Set(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));

        movement.Move(movementInput);

        if(Input.GetButtonDown("Jump"))
        {
            if(hands.HasObject)
            {
                hands.Release();
            }
            else
            {
                hands.Grab();
            }
        }
    }
}
