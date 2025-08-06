using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetDepthResToPlayer : MonoBehaviour
{
    public Transform player;
    private Rigidbody rb;

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();

        var tPlayer = GameObject.Find("Player");
        player = tPlayer.transform;

    }

    // Update is called once per frame
    void Update()
    {

        Vector3 pos = transform.position;

        if (pos.y < player.position.y) {
            pos.z = player.position.z - 5;
        }
        else
        {
            pos.z = player.position.z   + 5;
        }

        transform.position = pos;
    }
}
