using UnityEngine;

public class orangeTalking : MonoBehaviour
{
    public bool playerNear;
    public float distance;
    public GameObject DialogueBoxOrange;
    public GameObject DialogueBoxOrange2;

    public PlayerCollide playerCollide;

    public Transform player; 

    public AudioClip snd_talk;
    private AudioSource audioSource;

    void Start()
    {
        audioSource = GetComponent<AudioSource>();
    }

    void Update()
    {
        distance = Vector2.Distance(player.position, transform.position);

        if (distance < 0.15 && Input.GetKeyDown(KeyCode.Space))
        {
            audioSource.PlayOneShot(snd_talk);

            if (playerCollide.hasKey == false)
            {
                DialogueBoxOrange.SetActive(true);
            }
            else
            {
                DialogueBoxOrange2.SetActive(true);
            }
        }

        if (playerNear == false)
        {
            DialogueBoxOrange.SetActive(false);
            DialogueBoxOrange2.SetActive(false);
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
