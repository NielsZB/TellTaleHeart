using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{

    [HideInInspector] public bool isEnabled;
    [SerializeField] float movementSpeed = 5f;
    [SerializeField] float rotationSpeed = 20f;
    Vector2 input;

    float inputAmount
    {
        get
        {
            return Mathf.Clamp01(Mathf.Abs(input.x) + Mathf.Abs(input.y));
        }
    }

    Vector3 direction;
    Quaternion rotationDirection;
    Transform cameraTransform;
    Rigidbody rb;
    bool SetRotation;
    PlayerGrab grab;

    public bool IsMoving { get { return rb.velocity.magnitude > 0.1f; } }

    private void Start()
    {
        cameraTransform = Camera.main.transform;
        rb = GetComponent<Rigidbody>();
        grab = GetComponentInChildren<PlayerGrab>();
    }

    private void Update()
    {
        direction = normalizedCameraCorrection();
        direction.y = 0f;
        if (grab.HasObject)
        {
            SetDirectionRotation(grab.grabbedObject.transform.position - transform.position);
        }
        else
        {
            SetDirectionRotation();
        }
    }

    private void FixedUpdate()
    {
        if (isEnabled)
        {
            rb.velocity = (direction * movementSpeed * inputAmount);
        }
    }

    Vector3 normalizedCameraCorrection()
    {
        Vector3 correctedVertical = input.y * cameraTransform.forward;
        Vector3 correctedHorizontal = input.x * cameraTransform.right;

        return (correctedVertical + correctedHorizontal).normalized;
    }

    void SetDirectionRotation()
    {
        rb.angularVelocity = Vector3.zero;
        if (direction != Vector3.zero)
        {
            rotationDirection = Quaternion.LookRotation(direction);

            transform.rotation = Quaternion.Slerp(
                transform.rotation,
                rotationDirection,
                Time.fixedDeltaTime * inputAmount * rotationSpeed);
        }
    }
    void SetDirectionRotation(Vector3 direction)
    {
        rb.angularVelocity = Vector3.zero;
        if (direction != Vector3.zero)
        {
            direction.y = 0f;
            rotationDirection = Quaternion.LookRotation(direction);

            transform.rotation = Quaternion.Slerp(
                transform.rotation,
                rotationDirection,
                Time.fixedDeltaTime * inputAmount * rotationSpeed);
        }
    }


    public void Move(Vector2 input)
    {
        this.input.Set(input.x, input.y);
    }
}
