using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DialogueTransform : MonoBehaviour
{

    [SerializeField] private Transform player;

    private Vector2 currentPos;
    private float xOffset = 404.95f;
    private float yOffset = 270.02f;

    // Start is called before the first frame update
    void Start()
    {
        var tar = GameObject.Find("Player");
        player = tar.transform;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.Space))
        {
            Vector2 currentPos = transform.position;
            currentPos.x = player.position.x + xOffset;
            currentPos.y = player.position.y + yOffset;
            transform.position = currentPos;
        }
    }
}
