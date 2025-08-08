using UnityEngine;
using UnityEngine.SceneManagement;

public class ExitBush : MonoBehaviour
{
    [Header("Exit Settings")]
    public AudioClip exitSound;
    public string nextSceneName = "StartScene";
    
    void Update()
    {
        PlayerController player = FindFirstObjectByType<PlayerController>();
        if (player != null)
        {
            Collider2D playerCollider = player.GetComponent<Collider2D>();
            Collider2D bushCollider = GetComponent<Collider2D>();
            
            if (playerCollider != null && bushCollider != null)
            {
                if (playerCollider.bounds.Intersects(bushCollider.bounds))
                {
                    if (player.HasItem("key"))
                    {
                        if (exitSound != null)
                        {
                            AudioManager.Instance?.PlaySound("exit");
                        }
                        
                        if (GameManager.Instance != null)
                        {
                            GameManager.Instance.CompleteGame();
                        }
                        else
                        {
                            SceneManager.LoadScene(nextSceneName);
                        }
                        
                        Debug.Log("Level completed! Returning to start screen.");
                    }
                }
            }
        }
    }
}

