using UnityEngine;
using UnityEngine.InputSystem;

public class IntroController : MonoBehaviour
{
    [Header("UI References")]
    [SerializeField] private GameObject titleText;
    [SerializeField] private GameObject instructionText;
    [SerializeField] private GameObject pressEnterText;
    
    [Header("Animation Settings")]
    [SerializeField] private float textBlinkSpeed = 1f;
    [SerializeField] private float fadeInDuration = 2f;
    
    private bool canProceed = false;
    private float blinkTimer = 0f;
    private CanvasGroup pressEnterCanvasGroup;
    
    private void Start()
    {
        // Get or create CanvasGroup for blinking effect
        if (pressEnterText != null)
        {
            pressEnterCanvasGroup = pressEnterText.GetComponent<CanvasGroup>();
            if (pressEnterCanvasGroup == null)
            {
                pressEnterCanvasGroup = pressEnterText.AddComponent<CanvasGroup>();
            }
        }
        
        // Start fade in animation
        StartCoroutine(FadeInSequence());
    }
    
    private void Update()
    {
        if (!canProceed) return;
        
        // Blink the "Press Enter" text
        if (pressEnterCanvasGroup != null)
        {
            blinkTimer += Time.deltaTime;
            float alpha = Mathf.Sin(blinkTimer * textBlinkSpeed) * 0.5f + 0.5f;
            pressEnterCanvasGroup.alpha = alpha;
        }
    }
    
    private System.Collections.IEnumerator FadeInSequence()
    {
        // Fade in title
        if (titleText != null)
        {
            CanvasGroup titleGroup = titleText.GetComponent<CanvasGroup>();
            if (titleGroup == null) titleGroup = titleText.AddComponent<CanvasGroup>();
            
            titleGroup.alpha = 0f;
            float timer = 0f;
            
            while (timer < fadeInDuration)
            {
                timer += Time.deltaTime;
                titleGroup.alpha = timer / fadeInDuration;
                yield return null;
            }
            titleGroup.alpha = 1f;
        }
        
        yield return new WaitForSeconds(0.5f);
        
        // Fade in instructions
        if (instructionText != null)
        {
            CanvasGroup instructionGroup = instructionText.GetComponent<CanvasGroup>();
            if (instructionGroup == null) instructionGroup = instructionText.AddComponent<CanvasGroup>();
            
            instructionGroup.alpha = 0f;
            float timer = 0f;
            
            while (timer < fadeInDuration)
            {
                timer += Time.deltaTime;
                instructionGroup.alpha = timer / fadeInDuration;
                yield return null;
            }
            instructionGroup.alpha = 1f;
        }
        
        yield return new WaitForSeconds(0.5f);
        
        // Show "Press Enter" and enable input
        if (pressEnterText != null)
        {
            pressEnterText.SetActive(true);
        }
        canProceed = true;
    }
    
    // Called by Input System
    public void OnStartGame(InputValue value)
    {
        if (value.isPressed && canProceed)
        {
            StartGame();
        }
    }
    

    
    private void StartGame()
    {
        // Set intro as seen
        if (GameController.Instance != null)
        {
            GameController.Instance.SetIntroSeen();
        }
        
        // Load main scene
        if (SceneController.Instance != null)
        {
            SceneController.Instance.LoadMainScene();
        }
        else
        {
            // Fallback
            UnityEngine.SceneManagement.SceneManager.LoadScene("Main");
        }
    }
}

