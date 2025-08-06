using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour

{ 
    public GameObject player;
    private Vector3 targetPos;
    private float lerpSpeed;

    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("Player");
        lerpSpeed = 5f;
    }

    void Update()
    {
        targetPos = player.transform.position;
        targetPos.z = -10;

        transform.position = Vector3.Lerp(transform.position, targetPos, lerpSpeed * Time.deltaTime);
    }
}
