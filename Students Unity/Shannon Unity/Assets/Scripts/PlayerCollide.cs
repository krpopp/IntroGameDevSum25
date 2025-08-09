using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;


public class PlayerCollide : MonoBehaviour
{

    [SerializeField] public GameObject key;
    [SerializeField] public GameObject dial;
    [SerializeField] private CollectKey bool_key;
    [SerializeField] private DialogueTrigger dial_text;

    [SerializeField] private GameObject npcTouching;

    [SerializeField] private AudioSource audioSrc;
    [SerializeField] private AudioClip audioClipDoor;
    [SerializeField] private AudioClip audioClipTalk;


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
                audioSrc.PlayOneShot(audioClipDoor);
                Destroy(collision.gameObject);
                
            }

        }

        if (collision.gameObject.name == "Exit")
        {

               

        }

        /*if (collision.gameObject.name == "NPC1")
        {
            dial_text.SetDialogue("The key is some way to the east of here.");
            dial.SetActive(true);
            Debug.Log("testing npc dial");


        }*/
    }

    void OnTriggerStay2D(Collider2D collision)
    {
        Debug.Log(Input.GetKey(KeyCode.Space));
        if (Input.GetKey(KeyCode.Space) && collision.gameObject.name == "NPC1")
        //collision.gameObject.name == "NPC1" || collision.gameObject.name == "NPC2")
        {
            if (!bool_key.hasKey)
            {
                dial_text.SetDialogue("The key is some way to the east of here.");
                dial.SetActive(true);
                //Debug.Log("testing npc dial");
                npcTouching = collision.gameObject;
            }
            else
            {
                dial_text.SetDialogue("Great. My friend will tell you how to escape this place.");
                dial.SetActive(true);
                npcTouching = collision.gameObject;
            }

        }
        else if (Input.GetKey(KeyCode.Space) && collision.gameObject.name == "NPC2")
        {
            dial_text.SetDialogue("The exit is north of here, hidden behind a tree.");
            dial.SetActive(true);
            npcTouching = collision.gameObject;
        }
    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        dial.SetActive(false);
    }
}
