using UnityEngine;

public class Door : MonoBehaviour
{
    private void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.CompareTag("Player"))
        {
            PlayerController player = collision.gameObject.GetComponent<PlayerController>();
            if (player != null && player.HasItem("key"))
            {
                player.RemoveItem("key");
                AudioManager.Instance?.PlaySound("door");
                Destroy(gameObject);
            }
        }
    }
}
