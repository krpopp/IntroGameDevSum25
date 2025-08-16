using UnityEngine;
using UnityEngine.InputSystem;
using TMPro;

public class SuccessController : MonoBehaviour
{
    [Header("UI References")]
    [SerializeField] private GameObject successTitle;
    [SerializeField] private GameObject successText;
    [SerializeField] private GameObject statsText;
    [SerializeField] private GameObject instructionsText;
    [SerializeField] private GameObject backgroundPanel;
    
    [Header("Animation Settings")]
    [SerializeField] private float titleSlideSpeed = 5f;
    [SerializeField] private float titleTargetY = 384f; // Half of 768
    [SerializeField] private float detailsDelay = 1f;
    [SerializeField] private float fadeInDuration = 0.5f;
    
    private bool titleSlidIn = false;
    private bool showDetails = false;
    private float detailsTimer = 0f;
    private float currentTitleY = -100f; // Start above screen
    
    private void Start()
    {
        // Initialize UI state
        if (successTitle != null)
        {
            RectTransform titleRect = successTitle.GetComponent<RectTransform>();
            if (titleRect != null)
            {
                titleRect.anchoredPosition = new Vector2(titleRect.anchoredPosition.x, currentTitleY);
            }
        }
        
        if (successText != null) successText.SetActive(false);
        if (statsText != null) statsText.SetActive(false);
        if (instructionsText != null) instructionsText.SetActive(false);
        
        // Start background fade
        StartCoroutine(FadeInBackground());
    }
    
    private void Update()
    {
        // Slide in title
        if (!titleSlidIn && successTitle != null)
        {
            RectTransform titleRect = successTitle.GetComponent<RectTransform>();
            if (titleRect != null)
            {
                currentTitleY += titleSlideSpeed;
                titleRect.anchoredPosition = new Vector2(titleRect.anchoredPosition.x, currentTitleY);
                
                if (currentTitleY >= titleTargetY)
                {
                    currentTitleY = titleTargetY;
                    titleRect.anchoredPosition = new Vector2(titleRect.anchoredPosition.x, currentTitleY);
                    titleSlidIn = true;
                    detailsTimer = 0f;
                }
            }
        }
        
        // Show details after title arrives
        if (titleSlidIn && !showDetails)
        {
            detailsTimer += Time.deltaTime;
            if (detailsTimer >= detailsDelay)
            {
                showDetails = true;
                ShowSuccessDetails();
            }
        }
    }
    
    private void ShowSuccessDetails()
    {
        if (successText != null)
        {
            successText.SetActive(true);
            SetSuccessText();
        }
        
        if (statsText != null)
        {
            statsText.SetActive(true);
            SetStatsText();
        }
        
        if (instructionsText != null)
        {
            instructionsText.SetActive(true);
            SetInstructionsText();
        }
    }
    
    private void SetSuccessText()
    {
        if (successText != null)
        {
            TextMeshProUGUI textComponent = successText.GetComponent<TextMeshProUGUI>();
            if (textComponent != null)
            {
                textComponent.text = "Delivery Address: CIRCUITS & FIXES Robot Repair Shop\n\n" +
                                   "\"Thanks for making it! We've been ordering pizzas\n" +
                                   "to find and rescue damaged delivery units.\n" +
                                   "Let's get that heating coil fixed!\"\n\n" +
                                   "Welcome to the Robot Collective.";
            }
        }
    }
    
    private void SetStatsText()
    {
        if (statsText != null && GameController.Instance != null)
        {
            TextMeshProUGUI textComponent = statsText.GetComponent<TextMeshProUGUI>();
            if (textComponent != null)
            {
                float deliveryTime = GameController.Instance.GetDeliveryTime();
                int tempFramesSurvived = GameController.Instance.GetTemperatureFramesSurvived();
                
                textComponent.text = $"Delivery Time: {deliveryTime:F1} seconds\n" +
                                   $"Temperature Frames Survived: {tempFramesSurvived}/9";
            }
        }
    }
    
    private void SetInstructionsText()
    {
        if (instructionsText != null)
        {
            TextMeshProUGUI textComponent = instructionsText.GetComponent<TextMeshProUGUI>();
            if (textComponent != null)
            {
                textComponent.text = "Press SPACE to continue\nPress R to deliver another pizza";
            }
        }
    }
    
    private System.Collections.IEnumerator FadeInBackground()
    {
        if (backgroundPanel != null)
        {
            CanvasGroup bgGroup = backgroundPanel.GetComponent<CanvasGroup>();
            if (bgGroup == null) bgGroup = backgroundPanel.AddComponent<CanvasGroup>();
            
            bgGroup.alpha = 0f;
            float timer = 0f;
            
            while (timer < fadeInDuration)
            {
                timer += Time.deltaTime;
                bgGroup.alpha = timer / fadeInDuration;
                yield return null;
            }
            bgGroup.alpha = 0.9f; // Match GameMaker's alpha
        }
    }
    
    // Input System callbacks
    public void OnContinue(InputValue value)
    {
        if (value.isPressed && showDetails)
        {
            ContinueToMenu();
        }
    }
    
    public void OnRestart(InputValue value)
    {
        if (value.isPressed && showDetails)
        {
            RestartGame();
        }
    }
    

    
    private void ContinueToMenu()
    {
        if (SceneController.Instance != null)
        {
            SceneController.Instance.LoadIntroScene();
        }
        else
        {
            UnityEngine.SceneManagement.SceneManager.LoadScene("Intro");
        }
    }
    
    private void RestartGame()
    {
        if (SceneController.Instance != null)
        {
            SceneController.Instance.RestartGame();
        }
        else
        {
            UnityEngine.SceneManagement.SceneManager.LoadScene("Main");
        }
    }
}

