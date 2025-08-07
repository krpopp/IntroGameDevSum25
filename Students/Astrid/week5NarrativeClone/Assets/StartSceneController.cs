using UnityEngine;
using UnityEngine.SceneManagement;

public class StartSceneController : MonoBehaviour
{
    public int targetSceneIndex = 1;

    // public PlayerCollide scriptA;
    // void Start()
    // {
    //     if (scriptA != null)
    //     {
    //         bool value = scriptA.exit;

    //     }
    // }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            SceneManager.LoadScene(targetSceneIndex);
            Debug.Log(targetSceneIndex);
        }
    }
}