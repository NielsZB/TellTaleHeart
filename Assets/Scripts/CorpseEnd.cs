using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CorpseEnd : MonoBehaviour
{
    struct Limit
    {
        public float limit;
        public float bounciness;
        public float contactDistance;

        public Limit(float limit, float bounciness, float contactDistance)
        {
            this.limit = limit;
            this.bounciness = bounciness;
            this.contactDistance = contactDistance;
        }
    }

    struct Spring
    {
        public float spring;
        public float damper;

        public Spring(float spring, float damper)
        {
            this.spring = spring;
            this.damper = damper;
        }
    }

    [SerializeField] Spring twistLimitSpring = new Spring(20f, 0.3f);
    [SerializeField] Limit lowTwistLimit = new Limit(-20f, 1f, 0f);
    [SerializeField] Limit highTwistLimit = new Limit(70f, 1f, 0f);
    [SerializeField] Spring swingLimitSpring = new Spring(20f, 0.3f);
    [SerializeField] Limit swing1Limit = new Limit(40f, 1f, 0f);
    [SerializeField] Limit swing2Limit = new Limit(40f, 1f, 0f);

    readonly bool enableProjection = true;
    readonly bool enableCollision = true;

    CharacterJoint joint;
    Rigidbody rb;

    public CharacterJoint ClosestJoint;
    public Rigidbody ClosestJointRB { get { return ClosestJoint.GetComponent<Rigidbody>(); } }


    public CharacterJoint FurthestJoint;
    public Rigidbody FurthestJointRB { get { return FurthestJoint.GetComponent<Rigidbody>(); } }


    public CorpseEnd OtherEndJoint;

    bool grabbed;


    void SetupJoint(Rigidbody bodyToConnect)
    {
        if (TryGetComponent(out CharacterJoint joint))
        {
            this.joint = joint;
        }
        else
        {
            joint = gameObject.AddComponent<CharacterJoint>();
        }

        joint.autoConfigureConnectedAnchor = true;
        joint.connectedBody = bodyToConnect;
        joint.twistLimitSpring = AddSpring(twistLimitSpring);
        joint.lowTwistLimit = AddLimit(lowTwistLimit);
        joint.highTwistLimit = AddLimit(highTwistLimit);
        joint.swingLimitSpring = AddSpring(swingLimitSpring);
        joint.swing1Limit = AddLimit(swing1Limit);
        joint.swing2Limit = AddLimit(swing2Limit);
        joint.enableProjection = enableProjection;
        joint.enableCollision = enableCollision;
    }
    void RemoveJoint()
    {
        if (joint != null)
        {
            if (TryGetComponent(out CharacterJoint joint))
            {
                Destroy(joint);
            }
            this.joint = null;
        }
    }

    public void Grab()
    {
        grabbed = true;
        rb.isKinematic = true;
        RemoveJoint();
        ClosestJoint.connectedBody = rb;
        FurthestJoint.connectedBody = ClosestJointRB;
        OtherEndJoint.SetupJoint(FurthestJointRB);
    }
    public void Release()
    {
        grabbed = false;
        rb.isKinematic = false;
        RemoveJoint();
    }

    public void UpdateRigidbody(Vector3 position)
    {
        rb.MovePosition(position);
    }

    private void Start()
    {
        rb = GetComponent<Rigidbody>();
    }
    SoftJointLimitSpring AddSpring(Spring spring)
    {
        return new SoftJointLimitSpring
        {
            spring = spring.spring,
            damper = spring.damper
        };
    }

    SoftJointLimit AddLimit(Limit limit)
    {
        return new SoftJointLimit
        {
            limit = limit.limit,
            bounciness = limit.bounciness,
            contactDistance = limit.contactDistance,
        };
    }
}
