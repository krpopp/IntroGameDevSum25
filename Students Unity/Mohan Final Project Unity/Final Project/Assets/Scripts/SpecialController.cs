using UnityEngine;
using UnityEngine.InputSystem;
using TMPro;

public class SpecialController : MonoBehaviour
{
    [Header("UI References")]
    [SerializeField] private GameObject specialTitle;
    [SerializeField] private GameObject specialText;
    [SerializeField] private GameObject instructionsText;
    [SerializeField] private GameObject backgroundPanel;
    
    [Header("Animation Settings")]
    [SerializeField] private float fadeInDuration = 0.5f;
    [SerializeField] private float textFadeInDelay = 0.5f;
    
    private bool canProceed = false;
    
    private void Start()
    {
        // Initialize UI state
        if (specialTitle != null) specialTitle.SetActive(false);
        if (specialText != null) specialText.SetActive(false);
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
        if (specialTitle != null)
        {
            specialTitle.SetActive(true);
            SetSpecialTitle();
        }
        
        yield return new WaitForSeconds(0.5f);
        
        // Show special text
        if (specialText != null)
        {
            specialText.SetActive(true);
            SetSpecialText();
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
    
    private void SetSpecialTitle()
    {
        if (specialTitle != null)
        {
            TextMeshProUGUI titleComponent = specialTitle.GetComponent<TextMeshProUGUI>();
            if (titleComponent != null)
            {
                titleComponent.text = "HIDDEN ENDING";
            }
        }
    }
    
    private void SetSpecialText()
    {
        if (specialText != null)
        {
            TextMeshProUGUI textComponent = specialText.GetComponent<TextMeshProUGUI>();
            if (textComponent != null)
            {
                textComponent.text = "You found the legendary Special Pizza!\n\n" +
                                   "This rare delicacy is said to grant\n" +
                                   "eternal warmth to those who discover it.\n\n" +
                                   "You are truly a master delivery robot!\n\n" +
                                   "Congratulations on finding this secret ending!";
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
                textComponent.text = "Press SPACE to return to menu\nPress R to play again";
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

