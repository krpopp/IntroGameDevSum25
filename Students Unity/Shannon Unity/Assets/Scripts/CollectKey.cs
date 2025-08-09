using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollectKey : MonoBehaviour
{
    [SerializeField] AudioSource audioSrc;
    [SerializeField] AudioClip collectKey;
    public bool hasKey;

    //private AudioSource keyAudio;
    // Start is called before the first frame update
    void Start()
    {
        hasKey = false;
        //keyAudio = GetComponent<AudioSource>();
    }
    void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.name == "Player")
        {
            hasKey = true;
            audioSrc.PlayOneShot(collectKey);
            Destroy(gameObject);
            
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
