using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class ColaUI : MonoBehaviour
{
    [Header("Cola Display")]
    [SerializeField] private GameObject colaPanel;
    [SerializeField] private Image colaIcon;
    [SerializeField] private TextMeshProUGUI colaText;
    [SerializeField] private Slider colaSlider;
    [SerializeField] private Image colaBackground;
    
    [Header("Visual Settings")]
    [SerializeField] private Color normalColor = Color.white;
    [SerializeField] private Color highlightColor = Color.yellow;
    [SerializeField] private Color warningColor = Color.red;
    [SerializeField] private Sprite colaSprite;
    [SerializeField] private bool showColaIcon = true;
    [SerializeField] private bool showColaText = true;
    [SerializeField] private bool showColaSlider = false;
    
    [Header("Animation")]
    [SerializeField] private bool enableAnimations = true;
    [SerializeField] private float pulseSpeed = 2f;
    [SerializeField] private float pulseIntensity = 0.2f;
    [SerializeField] private bool pulseWhenColaAvailable = true;
    
    [Header("Audio")]
    [SerializeField] private string colaAvailableSoundId = "cola_available";
    [SerializeField] private string colaUsedSoundId = "cola_used";
    
    [Header("Debug")]
    [SerializeField] private bool debugMode = false;
    
    // State
    private bool hasCola = false;
    private bool isColaAvailable = false;
    private bool isPulsing = false;
    
    // Animation
    private Vector3 originalScale;
    private float pulseTimer = 0f;
    
    private void Awake()
    {
        // Store original scale for pulse animation
        originalScale = transform.localScale;
        
        // Initialize cola display
        UpdateColaDisplay();
    }
    
    private void Update()
    {
        // Update pulse animation
        if (enableAnimations && isPulsing)
        {
            UpdatePulseAnimation();
        }
    }
    
    public void UpdateColaStatus()
    {
        // Check if player has cola
        var player = FindObjectOfType<PlayerInventory>();
        if (player != null)
        {
            hasCola = player.HasItem("cola");
            isColaAvailable = hasCola;
        }
        
        UpdateColaDisplay();
        
        if (debugMode)
        {
            Debug.Log($"Cola status updated: Has Cola = {hasCola}, Available = {isColaAvailable}");
        }
    }
    
    public void SetColaAvailable(bool available)
    {
        isColaAvailable = available;
        UpdateColaDisplay();
        
        // Play sound
        if (available && !string.IsNullOrEmpty(colaAvailableSoundId))
        {
            GameEvents.InvokePlaySound(colaAvailableSoundId);
        }
        
        if (debugMode)
        {
            Debug.Log($"Cola availability set to: {available}");
        }
    }
    
    public void SetHasCola(bool hasCola)
    {
        this.hasCola = hasCola;
        UpdateColaDisplay();
        
        if (debugMode)
        {
            Debug.Log($"Has cola set to: {hasCola}");
        }
    }
    
    public void UseCola()
    {
        if (!hasCola) return;
        
        hasCola = false;
        isColaAvailable = false;
        
        // Play use sound
        if (!string.IsNullOrEmpty(colaUsedSoundId))
        {
            GameEvents.InvokePlaySound(colaUsedSoundId);
        }
        
        UpdateColaDisplay();
        
        if (debugMode)
        {
            Debug.Log("Cola used");
        }
    }
    
    private void UpdateColaDisplay()
    {
        // Update panel visibility
        if (colaPanel != null)
        {
            colaPanel.SetActive(hasCola || isColaAvailable);
        }
        
        // Update icon
        if (colaIcon != null)
        {
            colaIcon.gameObject.SetActive(showColaIcon && (hasCola || isColaAvailable));
            if (colaSprite != null)
            {
                colaIcon.sprite = colaSprite;
            }
            
            // Set icon color
            if (hasCola)
            {
                colaIcon.color = normalColor;
            }
            else if (isColaAvailable)
            {
                colaIcon.color = highlightColor;
            }
            else
            {
                colaIcon.color = warningColor;
            }
        }
        
        // Update text
        if (colaText != null)
        {
            colaText.gameObject.SetActive(showColaText);
            
            if (hasCola)
            {
                colaText.text = "COLA";
                colaText.color = normalColor;
            }
            else if (isColaAvailable)
            {
                colaText.text = "COLA AVAILABLE";
                colaText.color = highlightColor;
            }
            else
            {
                colaText.text = "NO COLA";
                colaText.color = warningColor;
            }
        }
        
        // Update slider
        if (colaSlider != null)
        {
            colaSlider.gameObject.SetActive(showColaSlider);
            colaSlider.value = hasCola ? 1f : (isColaAvailable ? 0.5f : 0f);
        }
        
        // Update background
        if (colaBackground != null)
        {
            if (hasCola)
            {
                colaBackground.color = normalColor;
            }
            else if (isColaAvailable)
            {
                colaBackground.color = highlightColor;
            }
            else
            {
                colaBackground.color = warningColor;
            }
        }
        
        // Update pulse animation
        UpdatePulseState();
    }
    
    private void UpdatePulseState()
    {
        bool shouldPulse = pulseWhenColaAvailable && isColaAvailable && !hasCola;
        
        if (shouldPulse && !isPulsing)
        {
            isPulsing = true;
            pulseTimer = 0f;
        }
        else if (!shouldPulse && isPulsing)
        {
            isPulsing = false;
            transform.localScale = originalScale;
        }
    }
    
    private void UpdatePulseAnimation()
    {
        if (!isPulsing) return;
        
        pulseTimer += Time.deltaTime;
        float pulse = Mathf.Sin(pulseTimer * pulseSpeed) * pulseIntensity + 1f;
        
        transform.localScale = originalScale * pulse;
    }
    
    // Public API
    public void SetColaSprite(Sprite sprite)
    {
        colaSprite = sprite;
        if (colaIcon != null)
        {
            colaIcon.sprite = sprite;
        }
    }
    
    public void SetShowColaIcon(bool show)
    {
        showColaIcon = show;
        UpdateColaDisplay();
    }
    
    public void SetShowColaText(bool show)
    {
        showColaText = show;
        UpdateColaDisplay();
    }
    
    public void SetShowColaSlider(bool show)
    {
        showColaSlider = show;
        UpdateColaDisplay();
    }
    
    public void SetNormalColor(Color color)
    {
        normalColor = color;
        UpdateColaDisplay();
    }
    
    public void SetHighlightColor(Color color)
    {
        highlightColor = color;
        UpdateColaDisplay();
    }
    
    public void SetWarningColor(Color color)
    {
        warningColor = color;
        UpdateColaDisplay();
    }
    
    public void SetEnableAnimations(bool enable)
    {
        enableAnimations = enable;
        if (!enable && isPulsing)
        {
            isPulsing = false;
            transform.localScale = originalScale;
        }
    }
    
    public void SetPulseWhenColaAvailable(bool pulse)
    {
        pulseWhenColaAvailable = pulse;
        UpdatePulseState();
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
    public bool HasCola() => hasCola;
    public bool IsColaAvailable() => isColaAvailable;
    public bool IsPulsing() => isPulsing;
    public Sprite GetColaSprite() => colaSprite;
    
    // Debug
    private void OnValidate()
    {
        // Ensure positive values
        pulseSpeed = Mathf.Max(0f, pulseSpeed);
        pulseIntensity = Mathf.Clamp01(pulseIntensity);
    }
    
    private void OnGUI()
    {
        if (!debugMode) return;
        
        // Draw cola debug info
        GUILayout.BeginArea(new Rect(10, Screen.height - 500, 200, 140));
        GUILayout.Label("Cola UI Debug");
        GUILayout.Label($"Has Cola: {hasCola}");
        GUILayout.Label($"Available: {isColaAvailable}");
        GUILayout.Label($"Pulsing: {isPulsing}");
        GUILayout.Label($"Show Icon: {showColaIcon}");
        GUILayout.Label($"Show Text: {showColaText}");
        
        if (GUILayout.Button("Use Cola"))
        {
            UseCola();
        }
        
        if (GUILayout.Button("Toggle Available"))
        {
            SetColaAvailable(!isColaAvailable);
        }
        
        GUILayout.EndArea();
    }
}

