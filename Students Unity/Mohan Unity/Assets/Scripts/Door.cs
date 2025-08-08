using UnityEngine;

public class Door : MonoBehaviour
{
    [Header("Door Settings")]
    public float unlockDistance = 3f;
    public AudioClip unlockSound;
    
    private void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.CompareTag("Player"))
        {
            PlayerController player = collision.gameObject.GetComponent<PlayerController>();
            if (player != null && player.HasItem("key"))
            {
                player.RemoveItem("key");
                AudioManager.Instance?.PlaySound("door");
                Debug.Log("Door unlocked!");
                Destroy(gameObject);
            }
            else if (player != null)
            {
                Debug.Log("You need a key to unlock this door!");
            }
        }
    }
}
