using UnityEngine;
using UnityEngine.SceneManagement; 

public class exit : MonoBehaviour
{
    public AudioClip soundExit;

    private AudioSource audioSource;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        DontDestroyOnLoad(gameObject);
        audioSource = GetComponent<AudioSource>();
    }

    // Update is called once per frame
    void Update()
    {

    }
    
    void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            audioSource.PlayOneShot(soundExit);
            SceneManager.LoadScene("StartScene");
        }
    }
}
