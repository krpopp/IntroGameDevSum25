using UnityEngine;

public class PlayerCollide : MonoBehaviour
{

    //boolean to track if i have the key or not
    bool hasKey = false;

    //reference to the dialogue UI object
    public GameObject wDogDialogue;

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
            }
        }
    }

    //built-in event triggered when 2D hitboxes first overlap
    void OnTriggerEnter2D(Collider2D collision)
    {
        //Debug.Log(collision.gameObject.name);
        //if the thing i overlapped with is named burger
        if (collision.gameObject.name == "Burger")
        {
            //i have the burger (key)
            hasKey = true;
            //destroy the burger object
            Destroy(collision.gameObject);
        }
    }

    //built-in event triggered continuously if hitboxes are overlapping
    void OnTriggerStay2D(Collider2D collision)
    {
        //if i press space and if the thing i'm overlapping with is called NPC
        if (Input.GetKey(KeyCode.Space) && collision.gameObject.name == "NPC")
        {
            //turn on my dialogue game object
            wDogDialogue.SetActive(true);
        }
    }
}
