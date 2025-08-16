using System.Collections.Generic;
using UnityEngine;

public enum GameState
{
    Boot,
    Intro,
    Playing,
    Dialogue,
    Paused,
    Success,
    Failure,
    Special
}

public class GameManager : MonoBehaviour
{
    public static GameManager Instance { get; private set; }
    
    [Header("Configuration")]
    [SerializeField] private GameData gameData;
    [SerializeField] private bool debugMode = false;
    
    [Header("Game State")]
    [SerializeField] private GameState currentState = GameState.Boot;
    [SerializeField] private float timeRemaining = 120f;
    [SerializeField] private int temperatureFrame = 0;
    [SerializeField] private List<string> collectedItems = new List<string>();
    [SerializeField] private string correctPizza = "";
    [SerializeField] private string chosenPizzaType = "";
    [SerializeField] private bool hasSeenIntro = false;
    [SerializeField] private bool hasCheckedPizza = false;
    
    // Private state
    private bool timerActive = false;
    private bool timeUp = false;
    private bool wrongPizza = false;
    private bool temperatureFailed = false;
    private float gameStartTime = 0f;
    private float temperatureTimer = 0f;
    private HashSet<string> gameFlags = new HashSet<string>();
    
    // Events
    public System.Action<GameState> OnStateChanged;
    public System.Action<float> OnTimeChanged;
    public System.Action<int> OnTemperatureChanged;
    public System.Action<string> OnItemCollected;
    public System.Action OnGameSuccess;
    public System.Action OnGameFailure;
    
    private void Awake()
    {
        // Singleton pattern
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
            InitializeGame();
        }
        else
        {
            Destroy(gameObject);
        }
    }
    
    private void Start()
    {
        gameStartTime = Time.time;
        SubscribeToEvents();
    }
    
    private void OnDestroy()
    {
        UnsubscribeFromEvents();
    }
    
    private void Update()
    {
        if (timerActive)
        {
            UpdateTimer();
        }
        
        UpdateTemperature();
        CheckWinConditions();
        
        if (debugMode)
        {
            HandleDebugInput();
        }
    }
    
    private void InitializeGame()
    {
        // Initialize with default values
        timeRemaining = gameData.timeLimit;
        temperatureFrame = 0;
        collectedItems.Clear();
        gameFlags.Clear();
        
        // Randomly choose correct pizza
        correctPizza = Random.Range(0, 2) == 0 ? "meat" : "vegan";
        
        // Reset flags
        hasSeenIntro = false;
        hasCheckedPizza = false;
        chosenPizzaType = "";
        timerActive = false;
        timeUp = false;
        wrongPizza = false;
        temperatureFailed = false;
        
        // Reset timing
        gameStartTime = Time.time;
        temperatureTimer = 0f;
        
        if (debugMode)
        {
            Debug.Log($"Game initialized. Correct pizza: {correctPizza}");
        }
    }
    
    private void SubscribeToEvents()
    {
        GameEvents.OnItemCollected += AddItem;
        GameEvents.OnGameRestart += ResetGame;
    }
    
    private void UnsubscribeFromEvents()
    {
        GameEvents.OnItemCollected -= AddItem;
        GameEvents.OnGameRestart -= ResetGame;
    }
    
    private void UpdateTimer()
    {
        timeRemaining -= Time.deltaTime;
        
        if (timeRemaining <= 0f)
        {
            timeRemaining = 0f;
            timerActive = false;
            timeUp = true;
            GameEvents.InvokeGameFailure();
        }
        
        GameEvents.InvokeTimeChanged(timeRemaining);
        OnTimeChanged?.Invoke(timeRemaining);
    }
    
    private void UpdateTemperature()
    {
        temperatureTimer += Time.deltaTime;
        
        if (temperatureTimer >= gameData.temperatureUpdateRate)
        {
            temperatureTimer = 0f;
            temperatureFrame++;
            
            if (temperatureFrame >= gameData.maxTemperatureFrames)
            {
                temperatureFailed = true;
                GameEvents.InvokeGameFailure();
            }
            
            GameEvents.InvokeTemperatureChanged(temperatureFrame);
            OnTemperatureChanged?.Invoke(temperatureFrame);
        }
    }
    
    private void CheckWinConditions()
    {
        if (hasCheckedPizza) return;
        
        // Check for special pizza (hidden ending)
        if (chosenPizzaType == "special_pizza")
        {
            hasCheckedPizza = true;
            GameEvents.InvokeGameSuccess();
            return;
        }
        
        // Check for correct pizza delivery
        bool hasMeat = collectedItems.Contains("meat_pizza");
        bool hasVegan = collectedItems.Contains("vegan_pizza");
        
        if (correctPizza == "meat" && hasMeat && !hasVegan)
        {
            hasCheckedPizza = true;
            GameEvents.InvokeGameSuccess();
        }
        else if (correctPizza == "vegan" && hasVegan && !hasMeat)
        {
            hasCheckedPizza = true;
            GameEvents.InvokeGameSuccess();
        }
        else if (hasMeat || hasVegan)
        {
            hasCheckedPizza = true;
            wrongPizza = true;
            GameEvents.InvokeGameFailure();
        }
    }
    
    // Public API
    public void SetGameState(GameState newState)
    {
        if (currentState != newState)
        {
            currentState = newState;
            OnStateChanged?.Invoke(newState);
            GameEvents.InvokeGameStateChanged(newState);
            
            if (debugMode)
            {
                Debug.Log($"Game state changed to: {newState}");
            }
        }
    }
    
    public void SetIntroSeen()
    {
        hasSeenIntro = true;
        timerActive = true;
        SetGameFlag("intro_seen");
    }
    
    public void AddItem(string itemId)
    {
        if (!collectedItems.Contains(itemId))
        {
            collectedItems.Add(itemId);
            OnItemCollected?.Invoke(itemId);
            
            // Start timer when first pizza is collected
            if ((itemId == "meat_pizza" || itemId == "vegan_pizza") && !timerActive)
            {
                timerActive = true;
            }
            
            if (debugMode)
            {
                Debug.Log($"Item collected: {itemId}");
            }
        }
    }
    
    public void SetChosenPizzaType(string pizzaType)
    {
        chosenPizzaType = pizzaType;
        if (debugMode)
        {
            Debug.Log($"Pizza type chosen: {pizzaType}");
        }
    }
    
    public void SetGameFlag(string flag)
    {
        gameFlags.Add(flag);
        if (debugMode)
        {
            Debug.Log($"Game flag set: {flag}");
        }
    }
    
    public bool HasGameFlag(string flag)
    {
        return gameFlags.Contains(flag);
    }
    
    public void ResetGame()
    {
        InitializeGame();
        SetGameState(GameState.Intro);
        if (debugMode)
        {
            Debug.Log("Game reset");
        }
    }
    
    // Getters
    public GameState GetCurrentState() => currentState;
    public float GetTimeRemaining() => timeRemaining;
    public int GetTemperatureFrame() => temperatureFrame;
    public List<string> GetCollectedItems() => new List<string>(collectedItems);
    public string GetCorrectPizza() => correctPizza;
    public string GetChosenPizzaType() => chosenPizzaType;
    public bool HasSeenIntro() => hasSeenIntro;
    public bool IsTimerActive() => timerActive;
    public float GetDeliveryTime() => Time.time - gameStartTime;
    public bool IsTimeUp() => timeUp;
    public bool IsWrongPizza() => wrongPizza;
    public bool IsTemperatureFailed() => temperatureFailed;
    public GameData GetGameData() => gameData;
    
    // Debug
    private void HandleDebugInput()
    {
        if (Input.GetKeyDown(KeyCode.F1))
        {
            AddItem("meat_pizza");
        }
        if (Input.GetKeyDown(KeyCode.F2))
        {
            AddItem("vegan_pizza");
        }
        if (Input.GetKeyDown(KeyCode.F3))
        {
            SetChosenPizzaType("special_pizza");
        }
        if (Input.GetKeyDown(KeyCode.F4))
        {
            timeRemaining = 0f;
        }
    }
    
}

