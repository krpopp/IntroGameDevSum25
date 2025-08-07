using UnityEngine;
using UnityEngine.SceneManagement;
public class PlayerCollide : MonoBehaviour
{
    SoundEffectManager SFXmanager;
    void Awake()
    {
        SFXmanager = GameObject.FindGameObjectWithTag("Audio").GetComponent<SoundEffectManager>();
    }

    //boolean to track if i have the key or not
    bool hasKey = false;
    public bool have_dialogue = false;
    public int away_distance = 0;

    //reference to the dialogue UI object
    public GameObject NPC1Dialogue1;
    public GameObject NPC1Dialogue2;
    public GameObject NPC2Dialogue1;

    public bool exit = false;

    //built-in event triggered by the first impact of 2D collisions
    void OnCollisionEnter2D(Collision2D collision)
    {
        //Debug.Log(collision.gameObject.name);
        //if the object i hit is named door
        if (collision.gameObject.name == "Door")
        {
            //and if i have the key
            if (hasKey)
            {
                //destroy the door
                Destroy(collision.gameObject);
                SFXmanager.PlaySFX(SFXmanager.door);
            }
        }
    }

    //built-in event triggered when 2D hitboxes first overlap
    void OnTriggerEnter2D(Collider2D collision)
    {
        //Debug.Log(collision.gameObject.name);
        //if the thing i overlapped with is named burger
        if (collision.gameObject.name == "Key")
        {
            //i have the burger (key)
            hasKey = true;
            //destroy the burger object
            Destroy(collision.gameObject);
            SFXmanager.PlaySFX(SFXmanager.key);
        }
    }

    //built-in event triggered continuously if hitboxes are overlapping
    void OnTriggerStay2D(Collider2D collision)
    {
        //if i press space and if the thing i'm overlapping with is called NPC
        if (!hasKey && collision.gameObject.name == "NPC1")
        {
            if (Input.GetKey(KeyCode.Space))
            {
                //turn on my dialogue game object
                NPC1Dialogue1.SetActive(true);
                SFXmanager.PlaySFX(SFXmanager.dialogue);
            }
        }

        if (hasKey && collision.gameObject.name == "NPC1")
        {
            if (Input.GetKey(KeyCode.Space))
            {
                //turn on my dialogue game object
                NPC1Dialogue2.SetActive(true);
                SFXmanager.PlaySFX(SFXmanager.dialogue);
            }
        }

        if (hasKey && collision.gameObject.name == "NPC2")
        {
            if (Input.GetKey(KeyCode.Space))
            {
                //turn on my dialogue game object
                NPC2Dialogue1.SetActive(true);
                SFXmanager.PlaySFX(SFXmanager.dialogue);
            }
        }

        if (collision.gameObject.name == "Exit")
        {
            exit = true;
            SceneManager.LoadScene("StartScene");
            SFXmanager.PlaySFX(SFXmanager.exit);
        }
    }

    void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.gameObject.name == "NPC1")
        {
            NPC1Dialogue1.SetActive(false);
            NPC1Dialogue2.SetActive(false);
        }

        if (collision.gameObject.name == "NPC2")
        {
            NPC2Dialogue1.SetActive(false);
        }
    }

}
