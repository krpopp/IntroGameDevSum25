using UnityEngine;
using UnityEngine.SceneManagement;

public class MainSceneController : MonoBehaviour
{
    [Header("Scene References")]
    [SerializeField] private Transform playerSpawnPoint;
    [SerializeField] private GameObject playerPrefab;
    [SerializeField] private Camera mainCamera;
    
    [Header("Camera Settings")]
    [SerializeField] private float cameraFollowSpeed = 5f;
    [SerializeField] private Vector2 cameraBounds = new Vector2(1366f, 768f);
    
    [Header("UI References")]
    [SerializeField] private GameObject timerUI;
    [SerializeField] private GameObject temperatureUI;
    [SerializeField] private GameObject inventoryUI;
    [SerializeField] private GameObject colaUI;
    [SerializeField] private GameObject dialogueUI;
    
    private GameObject currentPlayer;
    private bool sceneInitialized = false;
    
    private void Start()
    {
        InitializeScene();
        SubscribeToGameEvents();
    }
    
    private void OnDestroy()
    {
        UnsubscribeFromGameEvents();
    }
    
    private void InitializeScene()
    {
        if (sceneInitialized) return;
        
        // Spawn player if not already present
        if (currentPlayer == null && playerPrefab != null && playerSpawnPoint != null)
        {
            currentPlayer = Instantiate(playerPrefab, playerSpawnPoint.position, Quaternion.identity);
        }
        
        // Set up camera
        if (mainCamera == null)
        {
            mainCamera = Camera.main;
        }
        
        // Initialize UI
        InitializeUI();
        
        sceneInitialized = true;
    }
    
    private void InitializeUI()
    {
        // Set up UI references if not assigned
        if (timerUI == null)
        {
            timerUI = GameObject.Find("TimerUI");
        }
        
        if (temperatureUI == null)
        {
            temperatureUI = GameObject.Find("TemperatureUI");
        }
        
        if (inventoryUI == null)
        {
            inventoryUI = GameObject.Find("InventoryUI");
        }
        
        if (colaUI == null)
        {
            colaUI = GameObject.Find("ColaUI");
        }
        
        if (dialogueUI == null)
        {
            dialogueUI = GameObject.Find("DialogueUI");
        }
        
        // Hide dialogue UI initially
        if (dialogueUI != null)
        {
            dialogueUI.SetActive(false);
        }
    }
    
    private void SubscribeToGameEvents()
    {
        if (GameController.Instance != null)
        {
            GameController.Instance.OnGameSuccess += HandleGameSuccess;
            GameController.Instance.OnGameFailure += HandleGameFailure;
        }
    }
    
    private void UnsubscribeFromGameEvents()
    {
        if (GameController.Instance != null)
        {
            GameController.Instance.OnGameSuccess -= HandleGameSuccess;
            GameController.Instance.OnGameFailure -= HandleGameFailure;
        }
    }
    
    private void HandleGameSuccess()
    {
        // Check if it's the special ending
        if (GameController.Instance != null && 
            GameController.Instance.GetChosenPizzaType() == "special_pizza")
        {
            LoadSpecialScene();
        }
        else
        {
            LoadSuccessScene();
        }
    }
    
    private void HandleGameFailure()
    {
        LoadFailScene();
    }
    
    private void LoadSuccessScene()
    {
        if (SceneController.Instance != null)
        {
            SceneController.Instance.LoadSuccessScene();
        }
        else
        {
            SceneManager.LoadScene("Success");
        }
    }
    
    private void LoadFailScene()
    {
        if (SceneController.Instance != null)
        {
            SceneController.Instance.LoadFailScene();
        }
        else
        {
            SceneManager.LoadScene("Fail");
        }
    }
    
    private void LoadSpecialScene()
    {
        if (SceneController.Instance != null)
        {
            SceneController.Instance.LoadSpecialScene();
        }
        else
        {
            SceneManager.LoadScene("Special");
        }
    }
    
    private void Update()
    {
        // Handle camera following
        if (currentPlayer != null && mainCamera != null)
        {
            FollowPlayerWithCamera();
        }
        
        // Handle scene restart (for testing)
        if (Input.GetKeyDown(KeyCode.R))
        {
            RestartScene();
        }
    }
    
    private void FollowPlayerWithCamera()
    {
        Vector3 targetPosition = currentPlayer.transform.position;
        targetPosition.z = mainCamera.transform.position.z; // Keep camera's Z position
        
        // Clamp camera position to room bounds
        float halfCameraWidth = mainCamera.orthographicSize * mainCamera.aspect;
        float halfCameraHeight = mainCamera.orthographicSize;
        
        targetPosition.x = Mathf.Clamp(targetPosition.x, halfCameraWidth, cameraBounds.x - halfCameraWidth);
        targetPosition.y = Mathf.Clamp(targetPosition.y, halfCameraHeight, cameraBounds.y - halfCameraHeight);
        
        // Smooth camera movement
        mainCamera.transform.position = Vector3.Lerp(
            mainCamera.transform.position, 
            targetPosition, 
            cameraFollowSpeed * Time.deltaTime
        );
    }
    
    private void RestartScene()
    {
        if (SceneController.Instance != null)
        {
            SceneController.Instance.RestartGame();
        }
        else
        {
            SceneManager.LoadScene(SceneManager.GetActiveScene().name);
        }
    }
    
    // Public methods for other scripts to access
    public GameObject GetCurrentPlayer()
    {
        return currentPlayer;
    }
    
    public Camera GetMainCamera()
    {
        return mainCamera;
    }
    
    public void ShowDialogue(bool show)
    {
        if (dialogueUI != null)
        {
            dialogueUI.SetActive(show);
        }
    }
    
    public void SetPlayerMovementEnabled(bool enabled)
    {
        if (currentPlayer != null)
        {
            PlayerController playerController = currentPlayer.GetComponent<PlayerController>();
            if (playerController != null)
            {
                // Toggle player movement by changing game state or a simple flag
                // Assuming disabling means pausing player input
                if (!enabled)
                {
                    GameEvents.InvokeGameStateChanged(GameState.Paused);
                }
                else
                {
                    GameEvents.InvokeGameStateChanged(GameState.Playing);
                }
            }
        }
    }
}

