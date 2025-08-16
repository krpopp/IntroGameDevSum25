using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Collections;

public class GameOverUI : MonoBehaviour
{
    [Header("Game Over Panel")]
    [SerializeField] private GameObject gameOverPanel;
    [SerializeField] private Image backgroundPanel;
    
    [Header("Success Elements")]
    [SerializeField] private GameObject successPanel;
    [SerializeField] private TextMeshProUGUI successTitle;
    [SerializeField] private TextMeshProUGUI successText;
    [SerializeField] private TextMeshProUGUI successStats;
    [SerializeField] private GameObject successInstructions;
    
    [Header("Failure Elements")]
    [SerializeField] private GameObject failurePanel;
    [SerializeField] private TextMeshProUGUI failureTitle;
    [SerializeField] private TextMeshProUGUI failureText;
    [SerializeField] private GameObject failureInstructions;
    
    [Header("Animation Settings")]
    [SerializeField] private float fadeInDuration = 0.5f;
    [SerializeField] private float textFadeInDelay = 0.3f;
    [SerializeField] private float textFadeInDuration = 0.5f;
    [SerializeField] private float titleSlideSpeed = 5f;
    [SerializeField] private float titleTargetY = 384f;
    
    [Header("Visual Settings")]
    [SerializeField] private Color successColor = Color.green;
    [SerializeField] private Color failureColor = Color.red;
    [SerializeField] private Color backgroundColor = Color.black;
    [SerializeField] private bool enableBackgroundFade = true;
    
    [Header("Audio")]
    [SerializeField] private string successSoundId = "success";
    [SerializeField] private string failureSoundId = "failure";
    [SerializeField] private string gameOverMusicId = "game_over";
    
    [Header("Debug")]
    [SerializeField] private bool debugMode = false;
    
    // State
    private bool isGameOverActive = false;
    private bool isSuccess = false;
    private bool isAnimating = false;
    
    // Animation
    private CanvasGroup canvasGroup;
    private Coroutine fadeCoroutine;
    private Coroutine textCoroutine;
    
    // Events
    public System.Action OnGameOverStart;
    public System.Action OnGameOverComplete;
    public System.Action OnRestartRequested;
    public System.Action OnQuitRequested;
    
    private void Awake()
    {
        // Get or create CanvasGroup
        canvasGroup = GetComponent<CanvasGroup>();
        if (canvasGroup == null)
        {
            canvasGroup = gameObject.AddComponent<CanvasGroup>();
        }
        
        // Set initial state
        SetGameOverActive(false);
    }
    
    private void Start()
    {
        SubscribeToEvents();
    }
    
    private void OnDestroy()
    {
        UnsubscribeFromEvents();
    }
    
    private void SubscribeToEvents()
    {
        GameEvents.OnGameSuccess += OnGameSuccess;
        GameEvents.OnGameFailure += OnGameFailure;
        GameEvents.OnRestartInput += OnRestartInput;
    }
    
    private void UnsubscribeFromEvents()
    {
        GameEvents.OnGameSuccess -= OnGameSuccess;
        GameEvents.OnGameFailure -= OnGameFailure;
        GameEvents.OnRestartInput -= OnRestartInput;
    }
    
    // Event handlers
    private void OnGameSuccess()
    {
        ShowGameOver(true);
    }
    
    private void OnGameFailure()
    {
        ShowGameOver(false);
    }
    
    private void OnRestartInput()
    {
        if (isGameOverActive && !isAnimating)
        {
            RestartGame();
        }
    }
    
    // Public API
    public void ShowGameOver(bool isSuccess)
    {
        if (isGameOverActive) return;
        
        this.isSuccess = isSuccess;
        isGameOverActive = true;
        isAnimating = true;
        
        // Show appropriate panel
        if (successPanel != null)
        {
            successPanel.SetActive(isSuccess);
        }
        if (failurePanel != null)
        {
            failurePanel.SetActive(!isSuccess);
        }
        
        // Start animation
        if (fadeCoroutine != null)
        {
            StopCoroutine(fadeCoroutine);
        }
        fadeCoroutine = StartCoroutine(GameOverAnimationCoroutine());
        
        // Play sound
        string soundId = isSuccess ? successSoundId : failureSoundId;
        if (!string.IsNullOrEmpty(soundId))
        {
            GameEvents.InvokePlaySound(soundId);
        }
        
        // Play music
        if (!string.IsNullOrEmpty(gameOverMusicId))
        {
            GameEvents.InvokePlayMusic(gameOverMusicId);
        }
        
        OnGameOverStart?.Invoke();
        
        if (debugMode)
        {
            Debug.Log($"Game over shown: {(isSuccess ? "Success" : "Failure")}");
        }
    }
    
    public void HideGameOver()
    {
        if (!isGameOverActive) return;
        
        isGameOverActive = false;
        isAnimating = false;
        
        // Stop animations
        if (fadeCoroutine != null)
        {
            StopCoroutine(fadeCoroutine);
            fadeCoroutine = null;
        }
        if (textCoroutine != null)
        {
            StopCoroutine(textCoroutine);
            textCoroutine = null;
        }
        
        // Hide panels
        SetGameOverActive(false);
        
        OnGameOverComplete?.Invoke();
        
        if (debugMode)
        {
            Debug.Log("Game over hidden");
        }
    }
    
    public void RestartGame()
    {
        if (!isGameOverActive) return;
        
        OnRestartRequested?.Invoke();
        GameEvents.InvokeGameRestart();
        
        if (debugMode)
        {
            Debug.Log("Game restart requested");
        }
    }
    
    public void QuitGame()
    {
        OnQuitRequested?.Invoke();
        
        #if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
        #else
        Application.Quit();
        #endif
        
        if (debugMode)
        {
            Debug.Log("Game quit requested");
        }
    }
    
    public void SetSuccessText(string title, string text, string stats = "")
    {
        if (successTitle != null)
        {
            successTitle.text = title;
        }
        if (successText != null)
        {
            successText.text = text;
        }
        if (successStats != null)
        {
            successStats.text = stats;
            successStats.gameObject.SetActive(!string.IsNullOrEmpty(stats));
        }
    }
    
    public void SetFailureText(string title, string text)
    {
        if (failureTitle != null)
        {
            failureTitle.text = title;
        }
        if (failureText != null)
        {
            failureText.text = text;
        }
    }
    
    public void RefreshGameOver()
    {
        // Refresh current game over state
        if (isGameOverActive)
        {
            UpdateVisualState();
        }
    }
    
    // Private methods
    private void SetGameOverActive(bool active)
    {
        if (gameOverPanel != null)
        {
            gameOverPanel.SetActive(active);
        }
        
        if (successPanel != null)
        {
            successPanel.SetActive(active && isSuccess);
        }
        if (failurePanel != null)
        {
            failurePanel.SetActive(active && !isSuccess);
        }
        
        // Set background
        if (backgroundPanel != null)
        {
            backgroundPanel.color = backgroundColor;
        }
    }
    
    private void UpdateVisualState()
    {
        // Update colors based on success/failure
        Color themeColor = isSuccess ? successColor : failureColor;
        
        if (successTitle != null && isSuccess)
        {
            successTitle.color = themeColor;
        }
        if (failureTitle != null && !isSuccess)
        {
            failureTitle.color = themeColor;
        }
    }
    
    // Coroutines
    private IEnumerator GameOverAnimationCoroutine()
    {
        // Fade in background
        if (enableBackgroundFade)
        {
            float elapsed = 0f;
            while (elapsed < fadeInDuration)
            {
                elapsed += Time.deltaTime;
                float t = elapsed / fadeInDuration;
                
                canvasGroup.alpha = t;
                
                yield return null;
            }
            canvasGroup.alpha = 1f;
        }
        
        // Animate title
        if (isSuccess && successTitle != null)
        {
            yield return StartCoroutine(AnimateTitleCoroutine(successTitle));
        }
        else if (!isSuccess && failureTitle != null)
        {
            yield return StartCoroutine(AnimateTitleCoroutine(failureTitle));
        }
        
        // Fade in text
        if (textCoroutine != null)
        {
            StopCoroutine(textCoroutine);
        }
        textCoroutine = StartCoroutine(FadeInTextCoroutine());
        
        isAnimating = false;
    }
    
    private IEnumerator AnimateTitleCoroutine(TextMeshProUGUI title)
    {
        Vector3 startPos = title.transform.localPosition;
        Vector3 targetPos = new Vector3(startPos.x, titleTargetY, startPos.z);
        
        float elapsed = 0f;
        while (elapsed < 1f)
        {
            elapsed += Time.deltaTime * titleSlideSpeed;
            float t = Mathf.Clamp01(elapsed);
            
            title.transform.localPosition = Vector3.Lerp(startPos, targetPos, t);
            
            yield return null;
        }
        
        title.transform.localPosition = targetPos;
    }
    
    private IEnumerator FadeInTextCoroutine()
    {
        yield return new WaitForSeconds(textFadeInDelay);
        
        // Fade in text elements
        TextMeshProUGUI[] textElements = isSuccess ? 
            new TextMeshProUGUI[] { successText, successStats } : 
            new TextMeshProUGUI[] { failureText };
        
        foreach (var text in textElements)
        {
            if (text != null)
            {
                yield return StartCoroutine(FadeInTextElementCoroutine(text));
            }
        }
        
        // Show instructions
        GameObject instructions = isSuccess ? successInstructions : failureInstructions;
        if (instructions != null)
        {
            instructions.SetActive(true);
        }
    }
    
    private IEnumerator FadeInTextElementCoroutine(TextMeshProUGUI text)
    {
        if (text == null) yield break;
        
        Color originalColor = text.color;
        Color transparentColor = new Color(originalColor.r, originalColor.g, originalColor.b, 0f);
        
        text.color = transparentColor;
        
        float elapsed = 0f;
        while (elapsed < textFadeInDuration)
        {
            elapsed += Time.deltaTime;
            float t = elapsed / textFadeInDuration;
            
            text.color = Color.Lerp(transparentColor, originalColor, t);
            
            yield return null;
        }
        
        text.color = originalColor;
    }
    
    // Public API
    public void SetFadeInDuration(float duration)
    {
        fadeInDuration = duration;
    }
    
    public void SetTextFadeInDelay(float delay)
    {
        textFadeInDelay = delay;
    }
    
    public void SetTextFadeInDuration(float duration)
    {
        textFadeInDuration = duration;
    }
    
    public void SetTitleSlideSpeed(float speed)
    {
        titleSlideSpeed = speed;
    }
    
    public void SetSuccessColor(Color color)
    {
        successColor = color;
        UpdateVisualState();
    }
    
    public void SetFailureColor(Color color)
    {
        failureColor = color;
        UpdateVisualState();
    }
    
    public void SetBackgroundColor(Color color)
    {
        backgroundColor = color;
        if (backgroundPanel != null)
        {
            backgroundPanel.color = color;
        }
    }
    
    // Getters
    public bool IsGameOverActive() => isGameOverActive;
    public bool IsSuccess() => isSuccess;
    public bool IsAnimating() => isAnimating;
    
    // Debug
    private void OnValidate()
    {
        // Ensure positive values
        fadeInDuration = Mathf.Max(0f, fadeInDuration);
        textFadeInDelay = Mathf.Max(0f, textFadeInDelay);
        textFadeInDuration = Mathf.Max(0f, textFadeInDuration);
        titleSlideSpeed = Mathf.Max(0f, titleSlideSpeed);
    }
    
    private void OnGUI()
    {
        if (!debugMode) return;
        
        // Draw game over debug info
        GUILayout.BeginArea(new Rect(Screen.width - 300, Screen.height - 550, 290, 190));
        GUILayout.Label("Game Over UI Debug");
        GUILayout.Label($"Active: {isGameOverActive}");
        GUILayout.Label($"Success: {isSuccess}");
        GUILayout.Label($"Animating: {isAnimating}");
        
        if (GUILayout.Button("Show Success"))
        {
            ShowGameOver(true);
        }
        
        if (GUILayout.Button("Show Failure"))
        {
            ShowGameOver(false);
        }
        
        if (GUILayout.Button("Hide"))
        {
            HideGameOver();
        }
        
        if (GUILayout.Button("Restart"))
        {
            RestartGame();
        }
        
        GUILayout.EndArea();
    }
}

