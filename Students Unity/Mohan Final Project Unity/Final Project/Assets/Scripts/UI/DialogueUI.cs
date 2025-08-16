using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Collections;

public class DialogueUI : MonoBehaviour
{
    [Header("Dialogue Panel")]
    [SerializeField] private GameObject dialoguePanel;
    [SerializeField] private Image backgroundPanel;
    [SerializeField] private Image portraitPanel;
    
    [Header("Text Elements")]
    [SerializeField] private TextMeshProUGUI speakerNameText;
    [SerializeField] private TextMeshProUGUI dialogueText;
    [SerializeField] private TextMeshProUGUI continuePromptText;
    
    [Header("Choice Elements")]
    [SerializeField] private GameObject choicePanel;
    [SerializeField] private Button[] choiceButtons;
    [SerializeField] private TextMeshProUGUI[] choiceTexts;
    
    [Header("Animation Settings")]
    [SerializeField] private float fadeInDuration = 0.3f;
    [SerializeField] private float fadeOutDuration = 0.2f;
    [SerializeField] private float textTypeSpeed = 0.05f;
    [SerializeField] private float textPauseDuration = 0.1f;
    [SerializeField] private bool enableTypewriterEffect = true;
    
    [Header("Visual Settings")]
    [SerializeField] private Color defaultTextColor = Color.white;
    [SerializeField] private Color speakerNameColor = Color.yellow;
    [SerializeField] private Color continuePromptColor = Color.gray;
    [SerializeField] private Color choiceButtonNormalColor = Color.white;
    [SerializeField] private Color choiceButtonHighlightColor = Color.yellow;
    
    [Header("Audio")]
    [SerializeField] private string typeSoundId = "text_type";
    [SerializeField] private string choiceSoundId = "choice_select";
    [SerializeField] private string dialogueStartSoundId = "dialogue_start";
    [SerializeField] private string dialogueEndSoundId = "dialogue_end";
    
    [Header("Debug")]
    [SerializeField] private bool debugMode = false;
    
    // State
    private bool isDialogueActive = false;
    private bool isTyping = false;
    private bool isWaitingForInput = false;
    private bool isShowingChoices = false;
    private string currentDialogueText = "";
    private string fullDialogueText = "";
    private int currentChoiceIndex = -1;
    
    // Animation
    private CanvasGroup canvasGroup;
    private Coroutine typewriterCoroutine;
    private Coroutine fadeCoroutine;
    
    // Events
    public System.Action OnDialogueStart;
    public System.Action OnDialogueEnd;
    public System.Action<int> OnChoiceSelected;
    public System.Action OnDialogueAdvance;
    
    private void Awake()
    {
        // Get or create CanvasGroup
        canvasGroup = GetComponent<CanvasGroup>();
        if (canvasGroup == null)
        {
            canvasGroup = gameObject.AddComponent<CanvasGroup>();
        }
        
        // Initialize choice buttons
        InitializeChoiceButtons();
        
        // Set initial state
        SetDialogueActive(false);
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
        DialogueEvents.OnDialogueStart += OnDialogueStartEvent;
        DialogueEvents.OnDialogueEnd += OnDialogueEndEvent;
        DialogueEvents.OnDialogueLineChanged += OnDialogueLineChanged;
        DialogueEvents.OnChoicesPresented += OnChoicesPresented;
        GameEvents.OnAdvanceInput += OnAdvanceInput;
        GameEvents.OnChoiceInput += OnChoiceInput;
    }
    
    private void UnsubscribeFromEvents()
    {
        DialogueEvents.OnDialogueStart -= OnDialogueStartEvent;
        DialogueEvents.OnDialogueEnd -= OnDialogueEndEvent;
        DialogueEvents.OnDialogueLineChanged -= OnDialogueLineChanged;
        DialogueEvents.OnChoicesPresented -= OnChoicesPresented;
        GameEvents.OnAdvanceInput -= OnAdvanceInput;
        GameEvents.OnChoiceInput -= OnChoiceInput;
    }
    
    private void InitializeChoiceButtons()
    {
        if (choiceButtons != null)
        {
            for (int i = 0; i < choiceButtons.Length; i++)
            {
                int choiceIndex = i; // Capture the index
                if (choiceButtons[i] != null)
                {
                    choiceButtons[i].onClick.AddListener(() => OnChoiceButtonClicked(choiceIndex));
                }
            }
        }
    }
    
    // Event handlers
    private void OnDialogueStartEvent(DialogueData dialogue)
    {
        ShowDialogue();
    }
    
    private void OnDialogueEndEvent()
    {
        HideDialogue();
    }
    
    private void OnDialogueLineChanged(string line)
    {
        SetDialogueText(line);
    }
    
    private void OnChoicesPresented(System.Collections.Generic.List<DialogueChoice> choices)
    {
        ShowChoices(choices);
    }
    
    private void OnAdvanceInput()
    {
        if (!isDialogueActive) return;
        
        if (isTyping)
        {
            // Skip typewriter effect
            CompleteTypewriter();
        }
        else if (isWaitingForInput)
        {
            // Advance dialogue
            AdvanceDialogue();
        }
    }
    
    private void OnChoiceInput(int choiceIndex)
    {
        if (!isDialogueActive || !isShowingChoices) return;
        
        if (choiceIndex >= 0 && choiceIndex < choiceButtons.Length)
        {
            OnChoiceButtonClicked(choiceIndex);
        }
    }
    
    // Public API
    public void ShowDialogue()
    {
        if (isDialogueActive) return;
        
        isDialogueActive = true;
        isTyping = false;
        isWaitingForInput = false;
        isShowingChoices = false;
        
        // Show dialogue panel
        if (dialoguePanel != null)
        {
            dialoguePanel.SetActive(true);
        }
        
        // Fade in
        if (fadeCoroutine != null)
        {
            StopCoroutine(fadeCoroutine);
        }
        fadeCoroutine = StartCoroutine(FadeInCoroutine());
        
        // Play start sound
        if (!string.IsNullOrEmpty(dialogueStartSoundId))
        {
            GameEvents.InvokePlaySound(dialogueStartSoundId);
        }
        
        OnDialogueStart?.Invoke();
        
        if (debugMode)
        {
            Debug.Log("Dialogue UI shown");
        }
    }
    
    public void HideDialogue()
    {
        if (!isDialogueActive) return;
        
        isDialogueActive = false;
        isTyping = false;
        isWaitingForInput = false;
        isShowingChoices = false;
        
        // Stop typewriter effect
        if (typewriterCoroutine != null)
        {
            StopCoroutine(typewriterCoroutine);
            typewriterCoroutine = null;
        }
        
        // Fade out
        if (fadeCoroutine != null)
        {
            StopCoroutine(fadeCoroutine);
        }
        fadeCoroutine = StartCoroutine(FadeOutCoroutine());
        
        // Play end sound
        if (!string.IsNullOrEmpty(dialogueEndSoundId))
        {
            GameEvents.InvokePlaySound(dialogueEndSoundId);
        }
        
        OnDialogueEnd?.Invoke();
        
        if (debugMode)
        {
            Debug.Log("Dialogue UI hidden");
        }
    }
    
    public void SetDialogueText(string text)
    {
        fullDialogueText = text;
        
        if (enableTypewriterEffect)
        {
            StartTypewriterEffect();
        }
        else
        {
            SetTextImmediate(text);
        }
    }
    
    public void SetSpeakerName(string speakerName)
    {
        if (speakerNameText != null)
        {
            speakerNameText.text = speakerName;
            speakerNameText.color = speakerNameColor;
        }
    }
    
    public void SetPortrait(Sprite portrait)
    {
        if (portraitPanel != null)
        {
            if (portrait != null)
            {
                portraitPanel.sprite = portrait;
                portraitPanel.gameObject.SetActive(true);
            }
            else
            {
                portraitPanel.gameObject.SetActive(false);
            }
        }
    }
    
    public void ShowChoices(System.Collections.Generic.List<DialogueChoice> choices)
    {
        if (choices == null || choices.Count == 0) return;
        
        isShowingChoices = true;
        isWaitingForInput = false;
        
        // Show choice panel
        if (choicePanel != null)
        {
            choicePanel.SetActive(true);
        }
        
        // Set up choice buttons
        for (int i = 0; i < choiceButtons.Length; i++)
        {
            if (i < choices.Count)
            {
                // Show button
                choiceButtons[i].gameObject.SetActive(true);
                choiceTexts[i].text = choices[i].text;
                choiceButtons[i].interactable = true;
            }
            else
            {
                // Hide button
                choiceButtons[i].gameObject.SetActive(false);
            }
        }
        
        if (debugMode)
        {
            Debug.Log($"Showing {choices.Count} choices");
        }
    }
    
    public void HideChoices()
    {
        isShowingChoices = false;
        
        if (choicePanel != null)
        {
            choicePanel.SetActive(false);
        }
        
        // Hide all choice buttons
        foreach (var button in choiceButtons)
        {
            if (button != null)
            {
                button.gameObject.SetActive(false);
            }
        }
    }
    
    public void RefreshDialogue()
    {
        // Refresh current dialogue state
        if (isDialogueActive)
        {
            UpdateVisualState();
        }
    }
    
    // Private methods
    private void SetDialogueActive(bool active)
    {
        isDialogueActive = active;
        
        if (dialoguePanel != null)
        {
            dialoguePanel.SetActive(active);
        }
        
        if (!active)
        {
            HideChoices();
        }
    }
    
    private void StartTypewriterEffect()
    {
        if (typewriterCoroutine != null)
        {
            StopCoroutine(typewriterCoroutine);
        }
        
        typewriterCoroutine = StartCoroutine(TypewriterCoroutine());
    }
    
    private void CompleteTypewriter()
    {
        if (typewriterCoroutine != null)
        {
            StopCoroutine(typewriterCoroutine);
            typewriterCoroutine = null;
        }
        
        SetTextImmediate(fullDialogueText);
        isTyping = false;
        isWaitingForInput = true;
        
        ShowContinuePrompt();
    }
    
    private void SetTextImmediate(string text)
    {
        currentDialogueText = text;
        
        if (dialogueText != null)
        {
            dialogueText.text = text;
        }
        
        isTyping = false;
        isWaitingForInput = true;
        
        ShowContinuePrompt();
    }
    
    private void ShowContinuePrompt()
    {
        if (continuePromptText != null)
        {
            continuePromptText.gameObject.SetActive(true);
            continuePromptText.color = continuePromptColor;
        }
    }
    
    private void HideContinuePrompt()
    {
        if (continuePromptText != null)
        {
            continuePromptText.gameObject.SetActive(false);
        }
    }
    
    private void AdvanceDialogue()
    {
        isWaitingForInput = false;
        HideContinuePrompt();
        
        OnDialogueAdvance?.Invoke();
        
        if (debugMode)
        {
            Debug.Log("Dialogue advanced");
        }
    }
    
    private void OnChoiceButtonClicked(int choiceIndex)
    {
        if (!isShowingChoices) return;
        
        currentChoiceIndex = choiceIndex;
        
        // Play choice sound
        if (!string.IsNullOrEmpty(choiceSoundId))
        {
            GameEvents.InvokePlaySound(choiceSoundId);
        }
        
        // Hide choices
        HideChoices();
        
        // Emit choice event
        OnChoiceSelected?.Invoke(choiceIndex);
        DialogueEvents.InvokeDialogueChoice(choiceIndex);
        
        if (debugMode)
        {
            Debug.Log($"Choice {choiceIndex} selected");
        }
    }
    
    private void UpdateVisualState()
    {
        // Update colors and visual state based on current state
        if (dialogueText != null)
        {
            dialogueText.color = defaultTextColor;
        }
    }
    
    // Coroutines
    private IEnumerator TypewriterCoroutine()
    {
        isTyping = true;
        currentDialogueText = "";
        
        if (dialogueText != null)
        {
            dialogueText.text = "";
        }
        
        for (int i = 0; i < fullDialogueText.Length; i++)
        {
            currentDialogueText += fullDialogueText[i];
            
            if (dialogueText != null)
            {
                dialogueText.text = currentDialogueText;
            }
            
            // Play type sound
            if (!string.IsNullOrEmpty(typeSoundId))
            {
                GameEvents.InvokePlaySound(typeSoundId);
            }
            
            yield return new WaitForSeconds(textTypeSpeed);
        }
        
        isTyping = false;
        isWaitingForInput = true;
        
        ShowContinuePrompt();
    }
    
    private IEnumerator FadeInCoroutine()
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
    
    private IEnumerator FadeOutCoroutine()
    {
        float elapsed = 0f;
        
        while (elapsed < fadeOutDuration)
        {
            elapsed += Time.deltaTime;
            float t = elapsed / fadeOutDuration;
            
            canvasGroup.alpha = 1f - t;
            
            yield return null;
        }
        
        canvasGroup.alpha = 0f;
        
        // Hide dialogue panel
        if (dialoguePanel != null)
        {
            dialoguePanel.SetActive(false);
        }
    }
    
    // Public API
    public void SetTypewriterEffect(bool enable)
    {
        enableTypewriterEffect = enable;
    }
    
    public void SetTextTypeSpeed(float speed)
    {
        textTypeSpeed = speed;
    }
    
    public void SetFadeInDuration(float duration)
    {
        fadeInDuration = duration;
    }
    
    public void SetFadeOutDuration(float duration)
    {
        fadeOutDuration = duration;
    }
    
    // Getters
    public bool IsDialogueActive() => isDialogueActive;
    public bool IsTyping() => isTyping;
    public bool IsWaitingForInput() => isWaitingForInput;
    public bool IsShowingChoices() => isShowingChoices;
    public string GetCurrentText() => currentDialogueText;
    public string GetFullText() => fullDialogueText;
    public int GetCurrentChoiceIndex() => currentChoiceIndex;
    
    // Debug
    private void OnValidate()
    {
        // Ensure positive values
        fadeInDuration = Mathf.Max(0f, fadeInDuration);
        fadeOutDuration = Mathf.Max(0f, fadeOutDuration);
        textTypeSpeed = Mathf.Max(0.001f, textTypeSpeed);
        textPauseDuration = Mathf.Max(0f, textPauseDuration);
    }
    
    private void OnGUI()
    {
        if (!debugMode) return;
        
        // Draw dialogue debug info
        GUILayout.BeginArea(new Rect(Screen.width - 300, Screen.height - 200, 290, 190));
        GUILayout.Label("Dialogue UI Debug");
        GUILayout.Label($"Active: {isDialogueActive}");
        GUILayout.Label($"Typing: {isTyping}");
        GUILayout.Label($"Waiting: {isWaitingForInput}");
        GUILayout.Label($"Choices: {isShowingChoices}");
        GUILayout.Label($"Choice Index: {currentChoiceIndex}");
        GUILayout.Label($"Text: {currentDialogueText}");
        
        if (GUILayout.Button("Advance"))
        {
            OnAdvanceInput();
        }
        
        if (GUILayout.Button("Hide"))
        {
            HideDialogue();
        }
        
        GUILayout.EndArea();
    }
}

