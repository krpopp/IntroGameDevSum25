using UnityEngine;
using UnityEngine.InputSystem;
using TMPro;

public class FailController : MonoBehaviour
{
    [Header("UI References")]
    [SerializeField] private GameObject failTitle;
    [SerializeField] private GameObject failText;
    [SerializeField] private GameObject instructionsText;
    [SerializeField] private GameObject backgroundPanel;
    
    [Header("Animation Settings")]
    [SerializeField] private float fadeInDuration = 0.5f;
    [SerializeField] private float textFadeInDelay = 0.5f;
    
    private bool canProceed = false;
    
    private void Start()
    {
        // Initialize UI state
        if (failTitle != null) failTitle.SetActive(false);
        if (failText != null) failText.SetActive(false);
        if (instructionsText != null) instructionsText.SetActive(false);
        
        // Start fade in sequence
        StartCoroutine(FadeInSequence());
    }
    
    private System.Collections.IEnumerator FadeInSequence()
    {
        // Fade in background
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
            bgGroup.alpha = 0.9f;
        }
        
        yield return new WaitForSeconds(textFadeInDelay);
        
        // Show title
        if (failTitle != null)
        {
            failTitle.SetActive(true);
            SetFailTitle();
        }
        
        yield return new WaitForSeconds(0.5f);
        
        // Show failure text
        if (failText != null)
        {
            failText.SetActive(true);
            SetFailText();
        }
        
        yield return new WaitForSeconds(0.5f);
        
        // Show instructions
        if (instructionsText != null)
        {
            instructionsText.SetActive(true);
            SetInstructionsText();
        }
        
        canProceed = true;
    }
    
    private void SetFailTitle()
    {
        if (failTitle != null)
        {
            TextMeshProUGUI titleComponent = failTitle.GetComponent<TextMeshProUGUI>();
            if (titleComponent != null)
            {
                titleComponent.text = "DELIVERY FAILED";
            }
        }
    }
    
    private void SetFailText()
    {
        if (failText != null && GameController.Instance != null)
        {
            TextMeshProUGUI textComponent = failText.GetComponent<TextMeshProUGUI>();
            if (textComponent != null)
            {
                string failureReason = GetFailureReason();
                textComponent.text = failureReason;
            }
        }
    }
    
    private string GetFailureReason()
    {
        if (GameController.Instance == null) return "Something went wrong!";
        
        // Check different failure conditions
        if (GameController.Instance.IsTimeUp())
        {
            return "Time's up! The pizza got too cold.\n\nYou need to deliver faster next time!";
        }
        else if (GameController.Instance.IsWrongPizza())
        {
            return "Wrong pizza delivered!\n\nYou brought the wrong type of pizza.\nMake sure to check which one they ordered!";
        }
        else if (GameController.Instance.IsTemperatureFailed())
        {
            return "You froze to death!\n\nThe pizza wasn't enough to keep you warm.\nTry to find additional heat sources!";
        }
        else
        {
            return "Delivery failed!\n\nSomething went wrong with your delivery.\nTry again!";
        }
    }
    
    private void SetInstructionsText()
    {
        if (instructionsText != null)
        {
            TextMeshProUGUI textComponent = instructionsText.GetComponent<TextMeshProUGUI>();
            if (textComponent != null)
            {
                textComponent.text = "Press SPACE to return to menu\nPress R to try again";
            }
        }
    }
    
    // Input System callbacks
    public void OnContinue(InputValue value)
    {
        if (value.isPressed && canProceed)
        {
            ReturnToMenu();
        }
    }
    
    public void OnRestart(InputValue value)
    {
        if (value.isPressed && canProceed)
        {
            RestartGame();
        }
    }
    
    // Legacy input support
    private void Update()
    {
        if (!canProceed) return;
        
        if (Input.GetKeyDown(KeyCode.Space))
        {
            ReturnToMenu();
        }
        else if (Input.GetKeyDown(KeyCode.R))
        {
            RestartGame();
        }
    }
    
    private void ReturnToMenu()
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

