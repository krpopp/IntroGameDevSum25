using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerCollide : MonoBehaviour
{
    bool hasKey = false;
    public GameObject npc1Dialogue;
    public GameObject npc2Dialogue;


    public AudioSource key_Audio;

    public AudioSource door_Audio;


    void Awake()
    {
        if (npc1Dialogue) npc1Dialogue.SetActive(false);
        if (npc2Dialogue) npc2Dialogue.SetActive(false);
    }

    void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.name == "Door")
        {


            if (hasKey == true)
            {
                door_Audio.Play();
                Destroy(collision.gameObject);

            }

        }
        if (collision.gameObject.name == "Key")
        {
               key_Audio.Play();
               hasKey = true;
              Destroy(collision.gameObject);
        }

        if (collision.gameObject.name == "Tree2")
        {
            SceneManager.LoadScene("StartScene");

        }
    }

    void OnTriggerStay2D(Collider2D collision)
    {
        
        if (collision.gameObject.name == "NPC1" && Input.GetKeyDown(KeyCode.Space))
        {
            npc1Dialogue.SetActive(true);
        }
        else if (collision.gameObject.name == "NPC2" && Input.GetKeyDown(KeyCode.Space))
        {
            npc2Dialogue.SetActive(true);
        }
    }

    void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.gameObject.name == "NPC1")
        {
            npc1Dialogue.SetActive(false); 
        }
        else if (collision.gameObject.name == "NPC2")
        {

            npc2Dialogue.SetActive(false);
        }
    }

    void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.name == "Door" && hasKey)
        {
            Destroy(collision.gameObject);
        }
    }


    private void OnCollisionStay2D(Collision2D collision)
    {
        
    }

    private void OnCollisionExit2D(Collision2D collision)
    {
        
    }
}
