using UnityEngine;

public class blueTalking : MonoBehaviour
{
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    public bool playerNear;
    public GameObject DialogueBoxBlue;

    public Transform player;
    public float distance; 
    public PlayerCollide playerCollide;

     public AudioClip snd_talk;
    private AudioSource audioSource;



    void Start()
    {
        audioSource = GetComponent<AudioSource>();
    }

    void Update()
    {
        distance = Vector2.Distance(player.position, transform.position);

        if (distance < 0.15  && Input.GetKeyDown(KeyCode.Space))
        {
            audioSource.PlayOneShot(snd_talk);
            
            DialogueBoxBlue.SetActive(true);

        }

        if (playerNear == false)
        {
            DialogueBoxBlue.SetActive(false);

        }
    }

    void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            playerNear = true;
        }
    }

    void OnTriggerExit2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            playerNear = false;
        }
    }
    
    void LateUpdate()
    {
        
        SpriteRenderer sr = GetComponent<SpriteRenderer>();
        sr.sortingOrder = -(int)(transform.position.y * 100); 
    }

}
