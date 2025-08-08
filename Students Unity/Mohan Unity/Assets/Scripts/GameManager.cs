using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    [Header("Scene Names")]
    public string startSceneName = "StartScene";
    public string mainGameSceneName = "SampleScene";
    
    [Header("Game State")]
    public bool gameStarted = false;
    public bool gameCompleted = false;
    
    public static GameManager Instance { get; private set; }
    
    void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
    }
    
    void Start()
    {
        gameStarted = false;
        gameCompleted = false;
    }
    
    public void StartGame()
    {
        gameStarted = true;
        LoadMainGame();
    }
    
    public void LoadMainGame()
    {
        SceneManager.LoadScene(mainGameSceneName);
    }
    
    public void LoadStartScreen()
    {
        gameStarted = false;
        gameCompleted = false;
        SceneManager.LoadScene(startSceneName);
    }
    
    public void CompleteGame()
    {
        gameCompleted = true;
        LoadStartScreen();
    }
    
    public void RestartGame()
    {
        gameStarted = false;
        gameCompleted = false;
        LoadMainGame();
    }
    
    public void QuitGame()
    {
        #if UNITY_EDITOR
            UnityEditor.EditorApplication.isPlaying = false;
        #else
            Application.Quit();
        #endif
    }
}
