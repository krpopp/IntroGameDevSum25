using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerCollide : MonoBehaviour
{

    public GameObject key;
    private CollectKey bool_key;

    // Start is called before the first frame update
    void Start()
    {
        key = GameObject.Find("Key");
        bool_key = key.GetComponent<CollectKey>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.name == "Door")
        {
            if (bool_key.hasKey)
            {
                Destroy(collision.gameObject);
            }

        }
    }

    void OnTriggerStay2D(Collider2D collision)
    {
        if (Input.GetKey(KeyCode.Space) && collision.gameObject.name == "NPC")
        {
            //npc1Dialogue.SetActive(true);
        }
    }
}
