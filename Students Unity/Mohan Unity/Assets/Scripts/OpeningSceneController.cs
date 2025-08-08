using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class OpeningSceneController : MonoBehaviour
{
    [Header("UI References")]
    public Text titleText;
    public Text startText;
    public Text instructionsText;
    public Button startButton;
    public Button quitButton;
    public Canvas canvas;
    public GameObject mainMenuPanel;
    public GameObject loadingPanel;
    
    [Header("Text Settings")]
    public string gameTitle = "Your Game Title";
    public string startMessage = "Press SPACE or Click to Start";
    public string instructionsMessage = "Use WASD to move, E to interact";
    public float textBlinkSpeed = 1.0f;
    public Color titleColor = Color.white;
    public Color startTextColor = Color.yellow;
    public Color instructionsColor = Color.gray;
    
    [Header("Scene Settings")]
    public string mainGameSceneName = "SampleScene";
    public float sceneTransitionDelay = 1.0f;
    
    [Header("Audio")]
    public AudioClip menuMusic;
    public AudioClip buttonClickSound;
    public AudioClip startGameSound;
    
    private bool isBlinking = true;
    private float blinkTimer = 0f;
    private bool gameStarted = false;
    private AudioSource audioSource;
    
    void Start()
    {
        SetupOpeningScene();
        SetupAudio();
    }
    
    void Update()
    {
        if (!gameStarted)
        {
            HandleTextBlinking();
            HandleInput();
        }
    }
    
    void SetupOpeningScene()
    {
        if (titleText != null)
        {
            titleText.text = gameTitle;
            titleText.color = titleColor;
            titleText.fontSize = 72;
            titleText.alignment = TextAnchor.MiddleCenter;
            titleText.fontStyle = FontStyle.Bold;
        }
        
        if (startText != null)
        {
            startText.text = startMessage;
            startText.color = startTextColor;
            startText.fontSize = 36;
            startText.alignment = TextAnchor.MiddleCenter;
        }
        
        if (instructionsText != null)
        {
            instructionsText.text = instructionsMessage;
            instructionsText.color = instructionsColor;
            instructionsText.fontSize = 24;
            instructionsText.alignment = TextAnchor.MiddleCenter;
        }
        
        if (canvas == null)
        {
            canvas = FindFirstObjectByType<Canvas>();
        }
        
        if (canvas != null)
        {
            canvas.renderMode = RenderMode.ScreenSpaceOverlay;
            canvas.sortingOrder = 100;
        }
        
        if (startButton != null)
        {
            startButton.onClick.AddListener(StartGame);
        }
        
        if (quitButton != null)
        {
            quitButton.onClick.AddListener(QuitGame);
        }
        
        if (mainMenuPanel != null)
        {
            mainMenuPanel.SetActive(true);
        }
        
        if (loadingPanel != null)
        {
            loadingPanel.SetActive(false);
        }
        
        SetBackground();
        
        Debug.Log("Opening scene initialized");
    }
    
    void SetupAudio()
    {
        audioSource = GetComponent<AudioSource>();
        if (audioSource == null)
        {
            audioSource = gameObject.AddComponent<AudioSource>();
        }
        
        if (menuMusic != null)
        {
            audioSource.clip = menuMusic;
            audioSource.loop = true;
            audioSource.Play();
        }
    }
    
    void SetBackground()
    {
        Camera mainCamera = Camera.main;
        if (mainCamera != null)
        {
            mainCamera.backgroundColor = Color.black;
            mainCamera.clearFlags = CameraClearFlags.SolidColor;
        }
    }
    
    void HandleTextBlinking()
    {
        if (!isBlinking || startText == null) return;
        
        blinkTimer += Time.deltaTime;
        if (blinkTimer >= textBlinkSpeed)
        {
            blinkTimer = 0f;
            startText.enabled = !startText.enabled;
        }
    }
    
    void HandleInput()
    {
        if (Input.GetKeyDown(KeyCode.Space) || Input.GetKeyDown(KeyCode.Return))
        {
            StartGame();
        }
        
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            QuitGame();
        }
    }
    
    public void StartGame()
    {
        if (gameStarted) return;
        
        gameStarted = true;
        Debug.Log("Starting game...");
        
        if (startGameSound != null && audioSource != null)
        {
            audioSource.PlayOneShot(startGameSound);
        }
        
        if (loadingPanel != null)
        {
            loadingPanel.SetActive(true);
        }
        
        if (mainMenuPanel != null)
        {
            mainMenuPanel.SetActive(false);
        }
        
        Invoke(nameof(LoadMainGame), sceneTransitionDelay);
    }
    
    void LoadMainGame()
    {
        SceneManager.LoadScene(mainGameSceneName);
    }
    
    public void QuitGame()
    {
        Debug.Log("Quitting game...");
        
        if (buttonClickSound != null && audioSource != null)
        {
            audioSource.PlayOneShot(buttonClickSound);
        }
        
        #if UNITY_EDITOR
            UnityEditor.EditorApplication.isPlaying = false;
        #else
            Application.Quit();
        #endif
    }
    
    public void OnButtonHover()
    {
        if (buttonClickSound != null && audioSource != null)
        {
            audioSource.PlayOneShot(buttonClickSound, 0.5f);
        }
    }
}
