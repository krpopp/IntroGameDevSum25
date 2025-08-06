using UnityEngine;

public class PlayerCollide : MonoBehaviour
{
    public bool hasKey = false;

    public AudioClip soundKey;
    public AudioClip soundDoor;
    private AudioSource audioSource;

    void Start()
    {
        audioSource = GetComponent<AudioSource>();
    }
    void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.name == "door")
        
        {
            if (hasKey)
            {
                audioSource.PlayOneShot(soundDoor);
                Destroy(collision.gameObject); 
            }

        }

    }

    void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.name == "key")
        {
            audioSource.PlayOneShot(soundKey);
            hasKey = true; 
            Destroy(collision.gameObject); 
        }

    
    }
}
