using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerCollide : MonoBehaviour
{

    [SerializeField] public GameObject key;
    [SerializeField] public GameObject dial;
    [SerializeField] private CollectKey bool_key;
    [SerializeField] private DialogueTrigger dial_text;

    [SerializeField] private GameObject npcTouching;

    // Start is called before the first frame update
    void Start()
    {
        //key = GameObject.Find("Key");
        //dial = GameObject.Find("Dialogue");

        bool_key = key.GetComponent<CollectKey>();
        dial_text = dial.GetComponent<DialogueTrigger>();
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

        if (collision.gameObject.name == "NPC1")
        {
            dial_text.SetDialogue("The key is some way to the east of here.");
            dial.SetActive(true);
            Debug.Log("testing npc dial");


        }
    }

    void OnTriggerStay2D(Collider2D collision)
    {
        if (Input.GetKeyDown(KeyCode.Space) && (collision.gameObject.name == "NPC1" || collision.gameObject.name == "NPC2"))
        {
            dial_text.SetDialogue("The key is some way to the east of here.");
            dial.SetActive(true);
            Debug.Log("testing npc dial");
            npcTouching = collision.gameObject;
        }
    }
}
