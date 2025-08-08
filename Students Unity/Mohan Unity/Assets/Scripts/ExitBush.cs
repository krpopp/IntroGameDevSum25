using UnityEngine;
using UnityEngine.SceneManagement;

public class ExitBush : MonoBehaviour
{
    [Header("Exit Settings")]
    public string nextSceneName = "Opening";
    
    void Start()
    {
        nextSceneName = "Opening";
        Collider2D collider = GetComponent<Collider2D>();
        if (collider != null)
        {
            collider.isTrigger = true;
        }
    }
    
    void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            SceneManager.LoadScene(nextSceneName);
        }
    }
}

