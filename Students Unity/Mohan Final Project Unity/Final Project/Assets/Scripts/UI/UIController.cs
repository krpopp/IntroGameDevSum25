using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class UIController : MonoBehaviour, IGameStateListener
{
    [Header("UI Panels")]
    [SerializeField] private GameObject mainGameUI;
    [SerializeField] private GameObject dialogueUI;
    [SerializeField] private GameObject pauseUI;
    [SerializeField] private GameObject gameOverUI;
    [SerializeField] private GameObject interactionPromptUI;
    
    [Header("HUD Elements")]
    [SerializeField] private TimerUI timerUI;
    [SerializeField] private TemperatureUI temperatureUI;
    [SerializeField] private InventoryUI inventoryUI;
    [SerializeField] private ColaUI colaUI;
    
    [Header("Dialogue UI")]
    [SerializeField] private DialogueUI dialogueUIController;
    
    [Header("Game Over UI")]
    [SerializeField] private GameOverUI gameOverUIController;
    
    [Header("Settings")]
    [SerializeField] private bool showUIInInspector = true;
    [SerializeField] private bool debugMode = false;
    
    // State
    private GameState currentState = GameState.Boot;
    private bool isUIVisible = true;
    
    // Events
    public System.Action<bool> OnUIVisibilityChangedEvent;
    public System.Action<GameState> OnUIStateChanged;
    
    private void Awake()
    {
        // Ensure UI components are assigned
        ValidateUIComponents();
    }
    
    private void Start()
    {
        SubscribeToEvents();
        InitializeUI();
    }
    
    private void OnDestroy()
    {
        UnsubscribeFromEvents();
    }
    
    private void ValidateUIComponents()
    {
        // Auto-find UI components if not assigned
        if (timerUI == null)
            timerUI = GetComponentInChildren<TimerUI>();
        if (temperatureUI == null)
            temperatureUI = GetComponentInChildren<TemperatureUI>();
        if (inventoryUI == null)
            inventoryUI = GetComponentInChildren<InventoryUI>();
        if (colaUI == null)
            colaUI = GetComponentInChildren<ColaUI>();
        if (dialogueUIController == null)
            dialogueUIController = GetComponentInChildren<DialogueUI>();
        if (gameOverUIController == null)
            gameOverUIController = GetComponentInChildren<GameOverUI>();
    }
    
    private void SubscribeToEvents()
    {
        GameEvents.OnGameStateChanged += OnGameStateChanged;
        GameEvents.OnTimeChanged += OnTimeChanged;
        GameEvents.OnTemperatureChanged += OnTemperatureChanged;
        GameEvents.OnItemCollected += OnItemCollected;
        GameEvents.OnDialogueStart += OnDialogueStart;
        GameEvents.OnDialogueEnd += OnDialogueEnd;
        GameEvents.OnGameSuccess += OnGameSuccess;
        GameEvents.OnGameFailure += OnGameFailure;
        GameEvents.OnUIVisibilityChanged += OnUIVisibilityChanged;
    }
    
    private void UnsubscribeFromEvents()
    {
        GameEvents.OnGameStateChanged -= OnGameStateChanged;
        GameEvents.OnTimeChanged -= OnTimeChanged;
        GameEvents.OnTemperatureChanged -= OnTemperatureChanged;
        GameEvents.OnItemCollected -= OnItemCollected;
        GameEvents.OnDialogueStart -= OnDialogueStart;
        GameEvents.OnDialogueEnd -= OnDialogueEnd;
        GameEvents.OnGameSuccess -= OnGameSuccess;
        GameEvents.OnGameFailure -= OnGameFailure;
        GameEvents.OnUIVisibilityChanged -= OnUIVisibilityChanged;
    }
    
    private void InitializeUI()
    {
        // Set initial UI state
        SetUIVisibility(true);
        UpdateUIForGameState(GameState.Boot);
        
        if (debugMode)
        {
            Debug.Log("UI Controller initialized");
        }
    }
    
    // Event handlers
    public void OnGameStateChanged(GameState newState)
    {
        currentState = newState;
        UpdateUIForGameState(newState);
        OnUIStateChanged?.Invoke(newState);
        
        if (debugMode)
        {
            Debug.Log($"UI state changed to: {newState}");
        }
    }
    
    private void OnTimeChanged(float timeRemaining)
    {
        if (timerUI != null)
        {
            timerUI.UpdateTime(timeRemaining);
        }
    }
    
    public void OnTemperatureChanged(int temperatureFrame)
    {
        if (temperatureUI != null)
        {
            temperatureUI.UpdateTemperature(temperatureFrame);
        }
    }
    
    public void OnItemCollected(string itemId)
    {
        if (inventoryUI != null)
        {
            inventoryUI.UpdateInventory();
        }
    }
    
    private void OnDialogueStart(string dialogueId)
    {
        ShowDialogueUI();
    }
    
    private void OnDialogueEnd()
    {
        HideDialogueUI();
    }
    
    public void OnGameSuccess()
    {
        ShowGameOverUI(true);
    }
    
    public void OnGameFailure()
    {
        ShowGameOverUI(false);
    }
    
    private void OnUIVisibilityChanged(bool isVisible)
    {
        SetUIVisibility(isVisible);
    }
    
    // UI State Management
    private void UpdateUIForGameState(GameState state)
    {
        switch (state)
        {
            case GameState.Boot:
                HideAllUI();
                break;
            case GameState.Intro:
                HideAllUI();
                break;
            case GameState.Playing:
                ShowMainGameUI();
                HideDialogueUI();
                HideGameOverUI();
                break;
            case GameState.Dialogue:
                ShowMainGameUI();
                ShowDialogueUI();
                HideGameOverUI();
                break;
            case GameState.Paused:
                ShowMainGameUI();
                ShowPauseUI();
                break;
            case GameState.Success:
            case GameState.Failure:
            case GameState.Special:
                HideMainGameUI();
                ShowGameOverUI(state == GameState.Success);
                break;
        }
    }
    
    private void ShowMainGameUI()
    {
        if (mainGameUI != null)
        {
            mainGameUI.SetActive(true);
        }
        
        // Update HUD elements
        UpdateHUD();
    }
    
    private void HideMainGameUI()
    {
        if (mainGameUI != null)
        {
            mainGameUI.SetActive(false);
        }
    }
    
    private void ShowDialogueUI()
    {
        if (dialogueUI != null)
        {
            dialogueUI.SetActive(true);
        }
        
        if (dialogueUIController != null)
        {
            dialogueUIController.ShowDialogue();
        }
    }
    
    private void HideDialogueUI()
    {
        if (dialogueUI != null)
        {
            dialogueUI.SetActive(false);
        }
        
        if (dialogueUIController != null)
        {
            dialogueUIController.HideDialogue();
        }
    }
    
    private void ShowPauseUI()
    {
        if (pauseUI != null)
        {
            pauseUI.SetActive(true);
        }
    }
    
    private void HidePauseUI()
    {
        if (pauseUI != null)
        {
            pauseUI.SetActive(false);
        }
    }
    
    private void ShowGameOverUI(bool isSuccess)
    {
        if (gameOverUI != null)
        {
            gameOverUI.SetActive(true);
        }
        
        if (gameOverUIController != null)
        {
            gameOverUIController.ShowGameOver(isSuccess);
        }
    }
    
    private void HideGameOverUI()
    {
        if (gameOverUI != null)
        {
            gameOverUI.SetActive(false);
        }
        
        if (gameOverUIController != null)
        {
            gameOverUIController.HideGameOver();
        }
    }
    
    private void HideAllUI()
    {
        HideMainGameUI();
        HideDialogueUI();
        HidePauseUI();
        HideGameOverUI();
    }
    
    private void UpdateHUD()
    {
        // Update timer
        if (timerUI != null)
        {
            timerUI.UpdateTime(GameManager.Instance.GetTimeRemaining());
        }
        
        // Update temperature
        if (temperatureUI != null)
        {
            temperatureUI.UpdateTemperature(GameManager.Instance.GetTemperatureFrame());
        }
        
        // Update inventory
        if (inventoryUI != null)
        {
            inventoryUI.UpdateInventory();
        }
        
        // Update cola indicator
        if (colaUI != null)
        {
            colaUI.UpdateColaStatus();
        }
    }
    
    // Public API
    public void SetUIVisibility(bool isVisible)
    {
        isUIVisible = isVisible;
        
        // Apply visibility to all UI elements
        if (mainGameUI != null)
            mainGameUI.SetActive(isVisible && mainGameUI.activeSelf);
        if (dialogueUI != null)
            dialogueUI.SetActive(isVisible && dialogueUI.activeSelf);
        if (pauseUI != null)
            pauseUI.SetActive(isVisible && pauseUI.activeSelf);
        if (gameOverUI != null)
            gameOverUI.SetActive(isVisible && gameOverUI.activeSelf);
        if (interactionPromptUI != null)
            interactionPromptUI.SetActive(isVisible && interactionPromptUI.activeSelf);
        
        OnUIVisibilityChangedEvent?.Invoke(isVisible);
        
        if (debugMode)
        {
            Debug.Log($"UI visibility set to: {isVisible}");
        }
    }
    
    public void ShowInteractionPrompt(string prompt)
    {
        if (interactionPromptUI != null)
        {
            interactionPromptUI.SetActive(true);
            
            // Update prompt text
            var promptText = interactionPromptUI.GetComponentInChildren<TextMeshProUGUI>();
            if (promptText != null)
            {
                promptText.text = prompt;
            }
        }
    }
    
    public void HideInteractionPrompt()
    {
        if (interactionPromptUI != null)
        {
            interactionPromptUI.SetActive(false);
        }
    }
    
    public void TogglePauseUI()
    {
        if (pauseUI != null)
        {
            bool isPaused = pauseUI.activeSelf;
            if (isPaused)
            {
                HidePauseUI();
            }
            else
            {
                ShowPauseUI();
            }
        }
    }
    
    public void RefreshAllUI()
    {
        UpdateHUD();
        
        if (dialogueUIController != null)
        {
            dialogueUIController.RefreshDialogue();
        }
        
        if (gameOverUIController != null)
        {
            gameOverUIController.RefreshGameOver();
        }
    }
    
    // Getters
    public bool IsUIVisible() => isUIVisible;
    public GameState GetCurrentState() => currentState;
    public TimerUI GetTimerUI() => timerUI;
    public TemperatureUI GetTemperatureUI() => temperatureUI;
    public InventoryUI GetInventoryUI() => inventoryUI;
    public ColaUI GetColaUI() => colaUI;
    public DialogueUI GetDialogueUI() => dialogueUIController;
    public GameOverUI GetGameOverUI() => gameOverUIController;
    
    // IGameStateListener implementation
    public void OnTimerChanged(float timeRemaining) => OnTimeChanged(timeRemaining);
    
    // Debug
    private void OnGUI()
    {
        if (!debugMode || !showUIInInspector) return;
        
        // Draw UI debug info
        GUILayout.BeginArea(new Rect(Screen.width - 300, 10, 290, 200));
        GUILayout.Label("UI Controller Debug");
        GUILayout.Label($"State: {currentState}");
        GUILayout.Label($"Visible: {isUIVisible}");
        GUILayout.Label($"Main UI: {mainGameUI?.activeSelf}");
        GUILayout.Label($"Dialogue UI: {dialogueUI?.activeSelf}");
        GUILayout.Label($"Pause UI: {pauseUI?.activeSelf}");
        GUILayout.Label($"Game Over UI: {gameOverUI?.activeSelf}");
        
        if (GUILayout.Button("Toggle UI"))
        {
            SetUIVisibility(!isUIVisible);
        }
        
        if (GUILayout.Button("Refresh UI"))
        {
            RefreshAllUI();
        }
        
        GUILayout.EndArea();
    }
}

