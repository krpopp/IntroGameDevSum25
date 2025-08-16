using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class TemperatureUI : MonoBehaviour
{
    [Header("Temperature Display")]
    [SerializeField] private TextMeshProUGUI temperatureText;
    [SerializeField] private Image temperatureBar;
    [SerializeField] private Slider temperatureSlider;
    [SerializeField] private Image[] temperatureFrames;
    
    [Header("Visual Settings")]
    [SerializeField] private Color normalColor = Color.green;
    [SerializeField] private Color warningColor = Color.yellow;
    [SerializeField] private Color dangerColor = Color.red;
    [SerializeField] private int maxTemperatureFrames = 9;
    [SerializeField] private int warningThreshold = 6;
    [SerializeField] private int dangerThreshold = 8;
    
    [Header("Animation")]
    [SerializeField] private bool enablePulseAnimation = true;
    [SerializeField] private float pulseSpeed = 2f;
    [SerializeField] private float pulseIntensity = 0.2f;
    [SerializeField] private float warningPulseSpeed = 3f;
    [SerializeField] private float dangerPulseSpeed = 5f;
    
    [Header("Audio")]
    [SerializeField] private string warningSoundId = "temp_warning";
    [SerializeField] private string dangerSoundId = "temp_danger";
    [SerializeField] private string overheatSoundId = "temp_overheat";
    
    [Header("Debug")]
    [SerializeField] private bool debugMode = false;
    
    // State
    private int currentTemperatureFrame = 0;
    private bool isWarning = false;
    private bool isDanger = false;
    private bool hasPlayedWarningSound = false;
    private bool hasPlayedDangerSound = false;
    private bool hasPlayedOverheatSound = false;
    
    // Animation
    private Vector3 originalScale;
    private float pulseTimer = 0f;
    
    private void Awake()
    {
        // Store original scale for pulse animation
        originalScale = transform.localScale;
        
        // Initialize temperature display
        UpdateTemperatureDisplay();
    }
    
    private void Update()
    {
        // Update pulse animation
        if (enablePulseAnimation)
        {
            UpdatePulseAnimation();
        }
    }
    
    public void UpdateTemperature(int temperatureFrame)
    {
        currentTemperatureFrame = temperatureFrame;
        
        // Check for state changes
        bool wasWarning = isWarning;
        bool wasDanger = isDanger;
        
        isWarning = temperatureFrame >= warningThreshold && temperatureFrame < dangerThreshold;
        isDanger = temperatureFrame >= dangerThreshold && temperatureFrame < maxTemperatureFrames;
        
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
        
        // Play overheat sound
        if (temperatureFrame >= maxTemperatureFrames && !hasPlayedOverheatSound)
        {
            PlayOverheatSound();
            hasPlayedOverheatSound = true;
        }
        
        // Update display
        UpdateTemperatureDisplay();
        
        if (debugMode)
        {
            Debug.Log($"Temperature updated: {temperatureFrame} (Warning: {isWarning}, Danger: {isDanger})");
        }
    }
    
    public void SetMaxTemperatureFrames(int maxFrames)
    {
        maxTemperatureFrames = maxFrames;
        UpdateTemperatureDisplay();
    }
    
    public void ResetTemperature()
    {
        currentTemperatureFrame = 0;
        isWarning = false;
        isDanger = false;
        hasPlayedWarningSound = false;
        hasPlayedDangerSound = false;
        hasPlayedOverheatSound = false;
        pulseTimer = 0f;
        
        UpdateTemperatureDisplay();
        
        if (debugMode)
        {
            Debug.Log("Temperature reset");
        }
    }
    
    private void UpdateTemperatureDisplay()
    {
        // Update text
        if (temperatureText != null)
        {
            if (currentTemperatureFrame >= maxTemperatureFrames)
            {
                temperatureText.text = "OVERHEATED!";
            }
            else
            {
                temperatureText.text = $"TEMP: {currentTemperatureFrame}/{maxTemperatureFrames}";
            }
            
            // Update text color
            temperatureText.color = GetCurrentColor();
        }
        
        // Update bar/slider
        if (temperatureBar != null)
        {
            temperatureBar.fillAmount = Mathf.Clamp01((float)currentTemperatureFrame / maxTemperatureFrames);
            temperatureBar.color = GetCurrentColor();
        }
        
        if (temperatureSlider != null)
        {
            temperatureSlider.value = Mathf.Clamp01((float)currentTemperatureFrame / maxTemperatureFrames);
        }
        
        // Update temperature frames
        UpdateTemperatureFrames();
    }
    
    private void UpdateTemperatureFrames()
    {
        if (temperatureFrames == null) return;
        
        for (int i = 0; i < temperatureFrames.Length; i++)
        {
            if (temperatureFrames[i] != null)
            {
                // Show frame if it's within the current temperature
                bool shouldShow = i < currentTemperatureFrame;
                temperatureFrames[i].gameObject.SetActive(shouldShow);
                
                // Set color based on temperature level
                if (shouldShow)
                {
                    temperatureFrames[i].color = GetCurrentColor();
                }
            }
        }
    }
    
    private Color GetCurrentColor()
    {
        if (currentTemperatureFrame >= maxTemperatureFrames)
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
            Debug.Log("Temperature warning sound played");
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
            Debug.Log("Temperature danger sound played");
        }
    }
    
    private void PlayOverheatSound()
    {
        if (!string.IsNullOrEmpty(overheatSoundId))
        {
            GameEvents.InvokePlaySound(overheatSoundId);
        }
        
        if (debugMode)
        {
            Debug.Log("Temperature overheat sound played");
        }
    }
    
    // Public API
    public void SetWarningThreshold(int threshold)
    {
        warningThreshold = threshold;
    }
    
    public void SetDangerThreshold(int threshold)
    {
        dangerThreshold = threshold;
    }
    
    public void SetNormalColor(Color color)
    {
        normalColor = color;
        UpdateTemperatureDisplay();
    }
    
    public void SetWarningColor(Color color)
    {
        warningColor = color;
        UpdateTemperatureDisplay();
    }
    
    public void SetDangerColor(Color color)
    {
        dangerColor = color;
        UpdateTemperatureDisplay();
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
    public int GetCurrentTemperatureFrame() => currentTemperatureFrame;
    public int GetMaxTemperatureFrames() => maxTemperatureFrames;
    public bool IsWarning() => isWarning;
    public bool IsDanger() => isDanger;
    public bool IsOverheated() => currentTemperatureFrame >= maxTemperatureFrames;
    public float GetTemperatureProgress() => Mathf.Clamp01((float)currentTemperatureFrame / maxTemperatureFrames);
    
    // Debug
    private void OnValidate()
    {
        // Ensure thresholds are valid
        maxTemperatureFrames = Mathf.Max(1, maxTemperatureFrames);
        warningThreshold = Mathf.Clamp(warningThreshold, 0, maxTemperatureFrames);
        dangerThreshold = Mathf.Clamp(dangerThreshold, 0, maxTemperatureFrames);
        warningThreshold = Mathf.Min(warningThreshold, dangerThreshold);
        
        // Ensure pulse values are valid
        pulseSpeed = Mathf.Max(0f, pulseSpeed);
        pulseIntensity = Mathf.Clamp01(pulseIntensity);
        warningPulseSpeed = Mathf.Max(0f, warningPulseSpeed);
        dangerPulseSpeed = Mathf.Max(0f, dangerPulseSpeed);
    }
    
    private void OnGUI()
    {
        if (!debugMode) return;
        
        // Draw temperature debug info
        GUILayout.BeginArea(new Rect(10, Screen.height - 300, 200, 140));
        GUILayout.Label("Temperature UI Debug");
        GUILayout.Label($"Frame: {currentTemperatureFrame}/{maxTemperatureFrames}");
        GUILayout.Label($"Progress: {GetTemperatureProgress():P0}");
        GUILayout.Label($"Warning: {isWarning}");
        GUILayout.Label($"Danger: {isDanger}");
        GUILayout.Label($"Overheated: {IsOverheated()}");
        
        if (GUILayout.Button("Reset Temperature"))
        {
            ResetTemperature();
        }
        
        GUILayout.EndArea();
    }
}

