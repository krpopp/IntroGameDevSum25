using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class TimerUI : MonoBehaviour
{
    [Header("Timer Display")]
    [SerializeField] private TextMeshProUGUI timerText;
    [SerializeField] private Image timerBar;
    [SerializeField] private Slider timerSlider;
    
    [Header("Visual Settings")]
    [SerializeField] private Color normalColor = Color.white;
    [SerializeField] private Color warningColor = Color.yellow;
    [SerializeField] private Color dangerColor = Color.red;
    [SerializeField] private float warningThreshold = 30f; // seconds
    [SerializeField] private float dangerThreshold = 10f; // seconds
    
    [Header("Animation")]
    [SerializeField] private bool enablePulseAnimation = true;
    [SerializeField] private float pulseSpeed = 2f;
    [SerializeField] private float pulseIntensity = 0.2f;
    [SerializeField] private float warningPulseSpeed = 3f;
    [SerializeField] private float dangerPulseSpeed = 5f;
    
    [Header("Audio")]
    [SerializeField] private string warningSoundId = "timer_warning";
    [SerializeField] private string dangerSoundId = "timer_danger";
    [SerializeField] private string timeUpSoundId = "time_up";
    
    [Header("Debug")]
    [SerializeField] private bool debugMode = false;
    
    // State
    private float currentTime = 120f;
    private float maxTime = 120f;
    private bool isWarning = false;
    private bool isDanger = false;
    private bool hasPlayedWarningSound = false;
    private bool hasPlayedDangerSound = false;
    private bool hasPlayedTimeUpSound = false;
    
    // Animation
    private Vector3 originalScale;
    private float pulseTimer = 0f;
    
    private void Awake()
    {
        // Store original scale for pulse animation
        originalScale = transform.localScale;
        
        // Initialize timer display
        UpdateTimerDisplay();
    }
    
    private void Update()
    {
        // Update pulse animation
        if (enablePulseAnimation)
        {
            UpdatePulseAnimation();
        }
    }
    
    public void UpdateTime(float timeRemaining)
    {
        currentTime = timeRemaining;
        
        // Check for state changes
        bool wasWarning = isWarning;
        bool wasDanger = isDanger;
        
        isWarning = timeRemaining <= warningThreshold && timeRemaining > dangerThreshold;
        isDanger = timeRemaining <= dangerThreshold && timeRemaining > 0f;
        
        // Play warning sound
        if (isWarning && !wasWarning && !hasPlayedWarningSound)
        {
            PlayWarningSound();
            hasPlayedWarningSound = true;
        }
        
        // Play danger sound
        if (isDanger && !wasDanger && !hasPlayedDangerSound)
        {
            PlayDangerSound();
            hasPlayedDangerSound = true;
        }
        
        // Play time up sound
        if (timeRemaining <= 0f && !hasPlayedTimeUpSound)
        {
            PlayTimeUpSound();
            hasPlayedTimeUpSound = true;
        }
        
        // Update display
        UpdateTimerDisplay();
        
        if (debugMode)
        {
            Debug.Log($"Timer updated: {timeRemaining:F1}s (Warning: {isWarning}, Danger: {isDanger})");
        }
    }
    
    public void SetMaxTime(float maxTime)
    {
        this.maxTime = maxTime;
        UpdateTimerDisplay();
    }
    
    public void ResetTimer()
    {
        currentTime = maxTime;
        isWarning = false;
        isDanger = false;
        hasPlayedWarningSound = false;
        hasPlayedDangerSound = false;
        hasPlayedTimeUpSound = false;
        pulseTimer = 0f;
        
        UpdateTimerDisplay();
        
        if (debugMode)
        {
            Debug.Log("Timer reset");
        }
    }
    
    private void UpdateTimerDisplay()
    {
        // Update text
        if (timerText != null)
        {
            if (currentTime <= 0f)
            {
                timerText.text = "TIME UP!";
            }
            else
            {
                int minutes = Mathf.FloorToInt(currentTime / 60f);
                int seconds = Mathf.FloorToInt(currentTime % 60f);
                timerText.text = string.Format("{0:00}:{1:00}", minutes, seconds);
            }
            
            // Update text color
            timerText.color = GetCurrentColor();
        }
        
        // Update bar/slider
        if (timerBar != null)
        {
            timerBar.fillAmount = Mathf.Clamp01(currentTime / maxTime);
            timerBar.color = GetCurrentColor();
        }
        
        if (timerSlider != null)
        {
            timerSlider.value = Mathf.Clamp01(currentTime / maxTime);
        }
    }
    
    private Color GetCurrentColor()
    {
        if (currentTime <= 0f)
        {
            return dangerColor;
        }
        else if (isDanger)
        {
            return dangerColor;
        }
        else if (isWarning)
        {
            return warningColor;
        }
        else
        {
            return normalColor;
        }
    }
    
    private void UpdatePulseAnimation()
    {
        if (!isWarning && !isDanger) return;
        
        pulseTimer += Time.deltaTime;
        
        float pulseSpeed = isDanger ? this.dangerPulseSpeed : this.warningPulseSpeed;
        float pulse = Mathf.Sin(pulseTimer * pulseSpeed) * pulseIntensity + 1f;
        
        transform.localScale = originalScale * pulse;
    }
    
    private void PlayWarningSound()
    {
        if (!string.IsNullOrEmpty(warningSoundId))
        {
            GameEvents.InvokePlaySound(warningSoundId);
        }
        
        if (debugMode)
        {
            Debug.Log("Warning sound played");
        }
    }
    
    private void PlayDangerSound()
    {
        if (!string.IsNullOrEmpty(dangerSoundId))
        {
            GameEvents.InvokePlaySound(dangerSoundId);
        }
        
        if (debugMode)
        {
            Debug.Log("Danger sound played");
        }
    }
    
    private void PlayTimeUpSound()
    {
        if (!string.IsNullOrEmpty(timeUpSoundId))
        {
            GameEvents.InvokePlaySound(timeUpSoundId);
        }
        
        if (debugMode)
        {
            Debug.Log("Time up sound played");
        }
    }
    
    // Public API
    public void SetWarningThreshold(float threshold)
    {
        warningThreshold = threshold;
    }
    
    public void SetDangerThreshold(float threshold)
    {
        dangerThreshold = threshold;
    }
    
    public void SetNormalColor(Color color)
    {
        normalColor = color;
        UpdateTimerDisplay();
    }
    
    public void SetWarningColor(Color color)
    {
        warningColor = color;
        UpdateTimerDisplay();
    }
    
    public void SetDangerColor(Color color)
    {
        dangerColor = color;
        UpdateTimerDisplay();
    }
    
    public void SetPulseAnimation(bool enable)
    {
        enablePulseAnimation = enable;
        if (!enable)
        {
            transform.localScale = originalScale;
        }
    }
    
    public void SetPulseSpeed(float speed)
    {
        pulseSpeed = speed;
    }
    
    public void SetPulseIntensity(float intensity)
    {
        pulseIntensity = intensity;
    }
    
    // Getters
    public float GetCurrentTime() => currentTime;
    public float GetMaxTime() => maxTime;
    public bool IsWarning() => isWarning;
    public bool IsDanger() => isDanger;
    public bool IsTimeUp() => currentTime <= 0f;
    public float GetTimeRemaining() => Mathf.Max(0f, currentTime);
    public float GetTimeProgress() => Mathf.Clamp01(currentTime / maxTime);
    
    // Debug
    private void OnValidate()
    {
        // Ensure thresholds are valid
        warningThreshold = Mathf.Max(0f, warningThreshold);
        dangerThreshold = Mathf.Max(0f, dangerThreshold);
        warningThreshold = Mathf.Max(warningThreshold, dangerThreshold);
        
        // Ensure pulse values are valid
        pulseSpeed = Mathf.Max(0f, pulseSpeed);
        pulseIntensity = Mathf.Clamp01(pulseIntensity);
        warningPulseSpeed = Mathf.Max(0f, warningPulseSpeed);
        dangerPulseSpeed = Mathf.Max(0f, dangerPulseSpeed);
    }
    
    private void OnGUI()
    {
        if (!debugMode) return;
        
        // Draw timer debug info
        GUILayout.BeginArea(new Rect(10, Screen.height - 150, 200, 140));
        GUILayout.Label("Timer UI Debug");
        GUILayout.Label($"Time: {currentTime:F1}s");
        GUILayout.Label($"Progress: {GetTimeProgress():P0}");
        GUILayout.Label($"Warning: {isWarning}");
        GUILayout.Label($"Danger: {isDanger}");
        GUILayout.Label($"Time Up: {IsTimeUp()}");
        
        if (GUILayout.Button("Reset Timer"))
        {
            ResetTimer();
        }
        
        GUILayout.EndArea();
    }
}

