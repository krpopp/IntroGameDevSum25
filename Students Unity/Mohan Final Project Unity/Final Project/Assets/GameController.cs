using UnityEngine;
using System.Collections.Generic;

public class GameController : MonoBehaviour
{
    public static GameController Instance { get; private set; }
    
    [Header("Game Settings")]
    [SerializeField] private float timeLimit = 120f; // 2 minutes
    [SerializeField] private float temperatureUpdateRate = 5f; // seconds per temperature frame
    
    [Header("Game State")]
    [SerializeField] private List<string> collectedItems = new List<string>();
    [SerializeField] private bool timerActive = false;
    [SerializeField] private float timeRemaining = 120f;
    [SerializeField] private float tempValue = 100f;
    [SerializeField] private string correctPizza = "";
    [SerializeField] private bool hasCheckedPizza = false;
    [SerializeField] private bool hasSeenIntro = false;
    [SerializeField] private string chosenPizzaType = "";
    
    // Failure tracking
    private bool timeUp = false;
    private bool wrongPizza = false;
    private bool temperatureFailed = false;
    
    // Timing
    private float gameStartTime = 0f;
    private float temperatureTimer = 0f;
    private int currentTemperatureFrame = 0;
    
    // Events
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
            InitializeGameState();
        }
        else
        {
            Destroy(gameObject);
        }
    }
    
    private void Start()
    {
        gameStartTime = Time.time;
    }
    
    private void Update()
    {
        if (timerActive)
        {
            UpdateTimer();
        }
        
        UpdateTemperature();
        CheckWinConditions();
    }
    
    private void InitializeGameState()
    {
        // Initialize with GameMaker defaults
        collectedItems.Clear();
        timerActive = false;
        timeRemaining = timeLimit;
        tempValue = 100f;
        hasCheckedPizza = false;
        hasSeenIntro = false;
        chosenPizzaType = "";
        
        // Randomly choose correct pizza
        correctPizza = Random.Range(0, 2) == 0 ? "meat" : "vegan";
        
        // Reset failure flags
        timeUp = false;
        wrongPizza = false;
        temperatureFailed = false;
        
        // Reset timing
        gameStartTime = Time.time;
        temperatureTimer = 0f;
        currentTemperatureFrame = 0;
    }
    
    private void UpdateTimer()
    {
        timeRemaining -= Time.deltaTime;
        
        if (timeRemaining <= 0f)
        {
            timeRemaining = 0f;
            timerActive = false;
            timeUp = true;
            OnGameFailure?.Invoke();
        }
        
        OnTimeChanged?.Invoke(timeRemaining);
    }
    
    private void UpdateTemperature()
    {
        temperatureTimer += Time.deltaTime;
        
        if (temperatureTimer >= temperatureUpdateRate)
        {
            temperatureTimer = 0f;
            currentTemperatureFrame++;
            
            if (currentTemperatureFrame >= 9) // GameMaker has 9 temperature frames
            {
                temperatureFailed = true;
                OnGameFailure?.Invoke();
            }
            
            OnTemperatureChanged?.Invoke(currentTemperatureFrame);
        }
    }
    
    private void CheckWinConditions()
    {
        if (hasCheckedPizza) return;
        
        // Check for special pizza (hidden ending)
        if (chosenPizzaType == "special_pizza")
        {
            hasCheckedPizza = true;
            OnGameSuccess?.Invoke();
            return;
        }
        
        // Check for correct pizza delivery
        bool hasMeat = collectedItems.Contains("meat_pizza");
        bool hasVegan = collectedItems.Contains("vegan_pizza");
        
        if (correctPizza == "meat" && hasMeat && !hasVegan)
        {
            hasCheckedPizza = true;
            OnGameSuccess?.Invoke();
        }
        else if (correctPizza == "vegan" && hasVegan && !hasMeat)
        {
            hasCheckedPizza = true;
            OnGameSuccess?.Invoke();
        }
        else if (hasMeat || hasVegan)
        {
            hasCheckedPizza = true;
            wrongPizza = true;
            OnGameFailure?.Invoke();
        }
    }
    
    // Public API
    public void SetIntroSeen()
    {
        hasSeenIntro = true;
        timerActive = true;
    }
    
    public void AddItem(string itemName)
    {
        if (!collectedItems.Contains(itemName))
        {
            collectedItems.Add(itemName);
            OnItemCollected?.Invoke(itemName);
            
            // Start timer when first pizza is collected
            if ((itemName == "meat_pizza" || itemName == "vegan_pizza") && !timerActive)
            {
                timerActive = true;
            }
        }
    }
    
    public void SetChosenPizzaType(string pizzaType)
    {
        chosenPizzaType = pizzaType;
    }
    
    public void ResetGameState()
    {
        InitializeGameState();
    }
    
    // Getters for scene controllers
    public float GetDeliveryTime()
    {
        return Time.time - gameStartTime;
    }
    
    public int GetTemperatureFramesSurvived()
    {
        return currentTemperatureFrame;
    }
    
    public bool IsTimeUp()
    {
        return timeUp;
    }
    
    public bool IsWrongPizza()
    {
        return wrongPizza;
    }
    
    public bool IsTemperatureFailed()
    {
        return temperatureFailed;
    }
    
    public List<string> GetCollectedItems()
    {
        return new List<string>(collectedItems);
    }
    
    public float GetTimeRemaining()
    {
        return timeRemaining;
    }
    
    public bool IsTimerActive()
    {
        return timerActive;
    }
    
    public string GetCorrectPizza()
    {
        return correctPizza;
    }
    
    public string GetChosenPizzaType()
    {
        return chosenPizzaType;
    }
    
    public bool HasSeenIntro()
    {
        return hasSeenIntro;
    }
}
