using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneController : MonoBehaviour
{
    public static SceneController Instance { get; private set; }
    
    [Header("Scene Names")]
    [SerializeField] private string bootSceneName = "Boot";
    [SerializeField] private string introSceneName = "Intro";
    [SerializeField] private string mainSceneName = "Main";
    [SerializeField] private string successSceneName = "Success";
    [SerializeField] private string failSceneName = "Fail";
    [SerializeField] private string specialSceneName = "Special";
    
    [Header("Transition Settings")]
    [SerializeField] private float transitionDelay = 0.5f;
    
    private void Awake()
    {
        // Singleton pattern
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
    
    private void Start()
    {
        // If we're in Boot scene, auto-load Intro
        if (SceneManager.GetActiveScene().name == bootSceneName)
        {
            LoadIntroScene();
        }
    }
    
    public void LoadIntroScene()
    {
        StartCoroutine(LoadSceneWithDelay(introSceneName));
    }
    
    public void LoadMainScene()
    {
        StartCoroutine(LoadSceneWithDelay(mainSceneName));
    }
    
    public void LoadSuccessScene()
    {
        StartCoroutine(LoadSceneWithDelay(successSceneName));
    }
    
    public void LoadFailScene()
    {
        StartCoroutine(LoadSceneWithDelay(failSceneName));
    }
    
    public void LoadSpecialScene()
    {
        StartCoroutine(LoadSceneWithDelay(specialSceneName));
    }
    
    public void RestartGame()
    {
        // Reset game state and go back to intro
        if (GameController.Instance != null)
        {
            GameController.Instance.ResetGameState();
        }
        LoadIntroScene();
    }
    
    public void QuitGame()
    {
        #if UNITY_EDITOR
            UnityEditor.EditorApplication.isPlaying = false;
        #else
            Application.Quit();
        #endif
    }
    
    private System.Collections.IEnumerator LoadSceneWithDelay(string sceneName)
    {
        // Optional: Add fade transition here
        yield return new WaitForSeconds(transitionDelay);
        
        SceneManager.LoadScene(sceneName);
    }
    
    public void ReloadCurrentScene()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }
}

