using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DialogueManager : MonoBehaviour
{
    public static DialogueManager Instance { get; private set; }
    
    [Header("Configuration")]
    [SerializeField] private DialogueData[] dialogueDatabase;
    [SerializeField] private bool debugMode = false;
    
    [Header("Current Dialogue")]
    [SerializeField] private DialogueData currentDialogue;
    [SerializeField] private int currentLineIndex = 0;
    [SerializeField] private bool isDialogueActive = false;
    [SerializeField] private bool isWaitingForInput = false;
    [SerializeField] private bool isShowingChoices = false;
    
    // Private state
    private Dictionary<string, DialogueData> dialogueLookup = new Dictionary<string, DialogueData>();
    private HashSet<string> completedDialogues = new HashSet<string>();
    private Coroutine currentDialogueCoroutine;
    
    // Events
    public System.Action<DialogueData> OnDialogueStart;
    public System.Action OnDialogueEnd;
    public System.Action<int> OnDialogueChoice;
    public System.Action<string> OnDialogueLineChanged;
    public System.Action<List<DialogueChoice>> OnChoicesPresented;
    
    private void Awake()
    {
        // Singleton pattern
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
            InitializeDialogueDatabase();
        }
        else
        {
            Destroy(gameObject);
        }
    }
    
    private void Start()
    {
        SubscribeToEvents();
    }
    
    private void OnDestroy()
    {
        UnsubscribeFromEvents();
    }
    
    private void InitializeDialogueDatabase()
    {
        dialogueLookup.Clear();
        foreach (var dialogue in dialogueDatabase)
        {
            if (dialogue != null && !string.IsNullOrEmpty(dialogue.dialogueId))
            {
                dialogueLookup[dialogue.dialogueId] = dialogue;
            }
        }
        
        if (debugMode)
        {
            Debug.Log($"Dialogue database initialized with {dialogueLookup.Count} dialogues");
        }
    }
    
    private void SubscribeToEvents()
    {
        GameEvents.OnDialogueStart += StartDialogue;
        GameEvents.OnDialogueEnd += EndDialogue;
        GameEvents.OnDialogueChoice += HandleDialogueChoice;
        GameEvents.OnAdvanceInput += HandleAdvanceInput;
        GameEvents.OnChoiceInput += HandleChoiceInput;
    }
    
    private void UnsubscribeFromEvents()
    {
        GameEvents.OnDialogueStart -= StartDialogue;
        GameEvents.OnDialogueEnd -= EndDialogue;
        GameEvents.OnDialogueChoice -= HandleDialogueChoice;
        GameEvents.OnAdvanceInput -= HandleAdvanceInput;
        GameEvents.OnChoiceInput -= HandleChoiceInput;
    }
    
    // Public API
    public void StartDialogue(string dialogueId)
    {
        if (isDialogueActive)
        {
            if (debugMode)
            {
                Debug.Log($"Dialogue already active, cannot start: {dialogueId}");
            }
            return;
        }
        
        if (!dialogueLookup.TryGetValue(dialogueId, out DialogueData dialogue))
        {
            if (debugMode)
            {
                Debug.LogWarning($"Dialogue not found: {dialogueId}");
            }
            return;
        }
        
        // Check if dialogue is one-time and already completed
        if (dialogue.isOneTime && completedDialogues.Contains(dialogueId))
        {
            if (debugMode)
            {
                Debug.Log($"One-time dialogue already completed: {dialogueId}");
            }
            return;
        }
        
        // Check conditions
        if (!CheckDialogueConditions(dialogue))
        {
            if (debugMode)
            {
                Debug.Log($"Dialogue conditions not met: {dialogueId}");
            }
            return;
        }
        
        currentDialogue = dialogue;
        currentLineIndex = 0;
        isDialogueActive = true;
        isWaitingForInput = false;
        isShowingChoices = false;
        
        // Mark as completed if one-time
        if (dialogue.isOneTime)
        {
            completedDialogues.Add(dialogueId);
        }
        
        // Pause gameplay if needed
        if (dialogue.pauseGameplay)
        {
            GameManager.Instance.SetGameState(GameState.Dialogue);
        }
        
        // Play start sound
        if (!string.IsNullOrEmpty(dialogue.startSoundId))
        {
            GameEvents.InvokePlaySound(dialogue.startSoundId);
        }
        
        OnDialogueStart?.Invoke(dialogue);
        DialogueEvents.InvokeDialogueStart(dialogue);
        
        // Start dialogue coroutine
        if (currentDialogueCoroutine != null)
        {
            StopCoroutine(currentDialogueCoroutine);
        }
        currentDialogueCoroutine = StartCoroutine(ProcessDialogue());
        
        if (debugMode)
        {
            Debug.Log($"Started dialogue: {dialogueId}");
        }
    }
    
    public void EndDialogue()
    {
        if (!isDialogueActive) return;
        
        isDialogueActive = false;
        isWaitingForInput = false;
        isShowingChoices = false;
        
        // Stop current coroutine
        if (currentDialogueCoroutine != null)
        {
            StopCoroutine(currentDialogueCoroutine);
            currentDialogueCoroutine = null;
        }
        
        // Resume gameplay if needed
        if (currentDialogue != null && currentDialogue.pauseGameplay)
        {
            GameManager.Instance.SetGameState(GameState.Playing);
        }
        
        // Play end sound
        if (currentDialogue != null && !string.IsNullOrEmpty(currentDialogue.endSoundId))
        {
            GameEvents.InvokePlaySound(currentDialogue.endSoundId);
        }
        
        OnDialogueEnd?.Invoke();
        DialogueEvents.InvokeDialogueEnd();
        
        currentDialogue = null;
        currentLineIndex = 0;
        
        if (debugMode)
        {
            Debug.Log("Dialogue ended");
        }
    }
    
    public void HandleDialogueChoice(int choiceIndex)
    {
        if (!isDialogueActive || !isShowingChoices) return;
        
        if (currentDialogue != null && currentLineIndex < currentDialogue.lines.Count)
        {
            var line = currentDialogue.lines[currentLineIndex];
            if (choiceIndex >= 0 && choiceIndex < line.choices.Length)
            {
                var choice = line.choices[choiceIndex];
                
                // Handle choice effects
                HandleChoiceEffects(choice);
                
                // Move to next dialogue or end
                if (!string.IsNullOrEmpty(choice.nextDialogueId))
                {
                    StartDialogue(choice.nextDialogueId);
                }
                else if (choice.endsDialogue)
                {
                    EndDialogue();
                }
                else
                {
                    // Continue to next line
                    currentLineIndex++;
                    if (currentLineIndex >= currentDialogue.lines.Count)
                    {
                        EndDialogue();
                    }
                    else
                    {
                        ProcessCurrentLine();
                    }
                }
                
                OnDialogueChoice?.Invoke(choiceIndex);
                DialogueEvents.InvokeDialogueChoice(choiceIndex);
            }
        }
    }
    
    private void HandleAdvanceInput()
    {
        if (!isDialogueActive) return;
        
        if (isWaitingForInput)
        {
            // Advance to next line
            currentLineIndex++;
            if (currentLineIndex >= currentDialogue.lines.Count)
            {
                EndDialogue();
            }
            else
            {
                ProcessCurrentLine();
            }
        }
    }
    
    private void HandleChoiceInput(int choiceIndex)
    {
        HandleDialogueChoice(choiceIndex);
    }
    
    private IEnumerator ProcessDialogue()
    {
        while (isDialogueActive && currentDialogue != null)
        {
            if (currentLineIndex >= currentDialogue.lines.Count)
            {
                EndDialogue();
                yield break;
            }
            
            ProcessCurrentLine();
            
            // Wait for input or auto-advance
            var line = currentDialogue.lines[currentLineIndex];
            if (line.waitForInput)
            {
                isWaitingForInput = true;
                while (isWaitingForInput && isDialogueActive)
                {
                    yield return null;
                }
            }
            else
            {
                yield return new WaitForSeconds(line.displayTime);
                currentLineIndex++;
            }
        }
    }
    
    private void ProcessCurrentLine()
    {
        if (currentDialogue == null || currentLineIndex >= currentDialogue.lines.Count) return;
        
        var line = currentDialogue.lines[currentLineIndex];
        
        // Update dialogue text
        OnDialogueLineChanged?.Invoke(line.text);
        DialogueEvents.InvokeDialogueLineChanged(line.text);
        
        // Handle choices
        if (line.choices != null && line.choices.Length > 0)
        {
            isShowingChoices = true;
            var choices = new List<DialogueChoice>(line.choices);
            OnChoicesPresented?.Invoke(choices);
            DialogueEvents.InvokeChoicesPresented(choices);
        }
        else
        {
            isShowingChoices = false;
        }
        
        // Handle line effects
        HandleLineEffects(line);
        
        if (debugMode)
        {
            Debug.Log($"Dialogue line: {line.text}");
        }
    }
    
    private bool CheckDialogueConditions(DialogueData dialogue)
    {
        // Check required items
        if (dialogue.requiresItems && dialogue.requiredItemIds != null)
        {
            var playerItems = GameManager.Instance.GetCollectedItems();
            foreach (var requiredItem in dialogue.requiredItemIds)
            {
                if (!playerItems.Contains(requiredItem))
                {
                    return false;
                }
            }
        }
        
        // Check correct pizza requirement
        if (dialogue.requiresCorrectPizza)
        {
            var correctPizza = GameManager.Instance.GetCorrectPizza();
            var chosenPizza = GameManager.Instance.GetChosenPizzaType();
            if (chosenPizza != correctPizza)
            {
                return false;
            }
        }
        
        // Check special pizza requirement
        if (dialogue.requiresSpecialPizza)
        {
            var chosenPizza = GameManager.Instance.GetChosenPizzaType();
            if (chosenPizza != "special_pizza")
            {
                return false;
            }
        }
        
        // Check intro seen requirement
        if (dialogue.requiresIntroSeen && !GameManager.Instance.HasSeenIntro())
        {
            return false;
        }
        
        // Check required flags
        if (dialogue.requiredFlags != null)
        {
            foreach (var flag in dialogue.requiredFlags)
            {
                if (!GameManager.Instance.HasGameFlag(flag))
                {
                    return false;
                }
            }
        }
        
        // Check forbidden flags
        if (dialogue.forbiddenFlags != null)
        {
            foreach (var flag in dialogue.forbiddenFlags)
            {
                if (GameManager.Instance.HasGameFlag(flag))
                {
                    return false;
                }
            }
        }
        
        return true;
    }
    
    private void HandleLineEffects(DialogueLine line)
    {
        if (line.triggerEvents != null)
        {
            foreach (var eventName in line.triggerEvents)
            {
                // Handle specific events
                switch (eventName)
                {
                    case "give_meat_pizza":
                        GameManager.Instance.AddItem("meat_pizza");
                        break;
                    case "give_vegan_pizza":
                        GameManager.Instance.AddItem("vegan_pizza");
                        break;
                    case "give_special_pizza":
                        GameManager.Instance.AddItem("special_pizza");
                        break;
                    case "set_intro_seen":
                        GameManager.Instance.SetIntroSeen();
                        break;
                    default:
                        GameManager.Instance.SetGameFlag(eventName);
                        break;
                }
            }
        }
    }
    
    private void HandleChoiceEffects(DialogueChoice choice)
    {
        // Give items
        if (choice.giveItems != null)
        {
            foreach (var itemId in choice.giveItems)
            {
                GameManager.Instance.AddItem(itemId);
            }
        }
        
        // Trigger events
        if (choice.triggerEvents != null)
        {
            foreach (var eventName in choice.triggerEvents)
            {
                GameManager.Instance.SetGameFlag(eventName);
            }
        }
    }
    
    // Getters
    public bool IsDialogueActive() => isDialogueActive;
    public bool IsWaitingForInput() => isWaitingForInput;
    public bool IsShowingChoices() => isShowingChoices;
    public DialogueData GetCurrentDialogue() => currentDialogue;
    public int GetCurrentLineIndex() => currentLineIndex;
    public DialogueData GetDialogue(string dialogueId)
    {
        dialogueLookup.TryGetValue(dialogueId, out DialogueData dialogue);
        return dialogue;
    }
    
    // Public methods
    public void AddDialogueToDatabase(DialogueData dialogue)
    {
        if (dialogue != null && !string.IsNullOrEmpty(dialogue.dialogueId))
        {
            dialogueLookup[dialogue.dialogueId] = dialogue;
            if (debugMode)
            {
                Debug.Log($"Added dialogue to database: {dialogue.dialogueId}");
            }
        }
    }
    
    public void ClearCompletedDialogues()
    {
        completedDialogues.Clear();
        if (debugMode)
        {
            Debug.Log("Cleared completed dialogues");
        }
    }
}

