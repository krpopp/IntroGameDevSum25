using UnityEngine;
using UnityEngine.UI;

public class StartScreenController : MonoBehaviour
{
    [Header("UI References")]
    public Text startText;
    public Canvas canvas;
    public GameObject startScreenPanel;
    
    [Header("Text Settings")]
    public string startMessage = "Press SPACE to Start";
    public float textBlinkSpeed = 1.0f;
    public Color textColor = Color.white;
    
    [Header("Game Objects")]
    public GameObject playerObject;
    public GameObject[] gameObjectsToHide;
    
    private bool isBlinking = true;
    private float blinkTimer = 0f;
    private bool gameStarted = false;
    
    void Start()
    {
        SetupStartScreen();
        HideGameObjects();
    }
    
    void Update()
    {
        if (!gameStarted)
        {
            HandleTextBlinking();
            HandleInput();
        }
    }
    
    void SetupStartScreen()
    {
        if (startText == null)
        {
            startText = FindFirstObjectByType<Text>();
        }
        
        if (startText != null)
        {
            startText.text = startMessage;
            startText.color = textColor;
            startText.fontSize = 48;
            startText.alignment = TextAnchor.MiddleCenter;
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
        
        if (startScreenPanel == null)
        {
            startScreenPanel = canvas?.gameObject;
        }
        
        SetBlackBackground();
        
        Debug.Log("Start screen initialized");
    }
    
    void SetBlackBackground()
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
        if (Input.GetKeyDown(KeyCode.Space))
        {
            StartGame();
        }
    }
    
    void StartGame()
    {
        gameStarted = true;
        Debug.Log("Starting game...");
        
        ShowGameObjects();
        HideStartScreen();
        RestoreCameraSettings();
    }
    
    void HideGameObjects()
    {
        if (playerObject != null)
            playerObject.SetActive(false);
            
        if (gameObjectsToHide != null)
        {
            foreach (GameObject obj in gameObjectsToHide)
            {
                if (obj != null)
                    obj.SetActive(false);
            }
        }
    }
    
    void ShowGameObjects()
    {
        if (playerObject != null)
            playerObject.SetActive(true);
            
        if (gameObjectsToHide != null)
        {
            foreach (GameObject obj in gameObjectsToHide)
            {
                if (obj != null)
                    obj.SetActive(true);
            }
        }
    }
    
    void HideStartScreen()
    {
        if (startScreenPanel != null)
            startScreenPanel.SetActive(false);
    }
    
    void RestoreCameraSettings()
    {
        Camera mainCamera = Camera.main;
        if (mainCamera != null)
        {
            mainCamera.backgroundColor = Color.black;
            mainCamera.clearFlags = CameraClearFlags.SolidColor;
        }
    }
    
    public void ShowStartScreen()
    {
        gameStarted = false;
        if (startScreenPanel != null)
            startScreenPanel.SetActive(true);
        HideGameObjects();
        SetBlackBackground();
    }
}
