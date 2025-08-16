using UnityEngine;

public class DialogueNPC : InteractableBase, IDialogueProvider
{
    [Header("NPC Settings")]
    [SerializeField] private NPCData npcData;
    [SerializeField] private string npcId = "";
    [SerializeField] private string displayName = "";
    [SerializeField] private NPCType npcType = NPCType.Dialogue;
    
    [Header("Dialogue Settings")]
    [SerializeField] private DialogueData[] dialogueOptions;
    [SerializeField] private string defaultDialogueId = "";
    [SerializeField] private bool hasChoices = false;
    [SerializeField] private string[] choiceDialogueIds;
    [SerializeField] private bool isOneTime = false;
    [SerializeField] private bool requiresItems = false;
    [SerializeField] private string[] requiredItemIds;
    
    [Header("Behavior")]
    [SerializeField] private bool givesItems = false;
    [SerializeField] private string[] giveItemIds;
    [SerializeField] private bool removesItems = false;
    [SerializeField] private string[] removeItemIds;
    [SerializeField] private bool triggersSpecialEnding = false;
    [SerializeField] private string[] triggerEvents;
    
    [Header("Conditions")]
    [SerializeField] private bool requiresCorrectPizza = false;
    [SerializeField] private bool requiresSpecialPizza = false;
    [SerializeField] private bool requiresIntroSeen = false;
    [SerializeField] private string[] requiredFlags;
    [SerializeField] private string[] forbiddenFlags;
    
    [Header("Visual")]
    [SerializeField] private Sprite portrait;
    [SerializeField] private Sprite worldSprite;
    [SerializeField] private Color tintColor = Color.white;
    
    [Header("Audio")]
    [SerializeField] private string voiceSoundId = "npc_voice";
    [SerializeField] private new string interactSoundId = "npc_interact";
    
    // State
    private bool hasInteracted = false;
    private bool isInDialogue = false;
    private DialogueData currentDialogue;
    private int currentDialogueIndex = 0;
    
    // IDialogueProvider properties
    public string GetDialogueId() => defaultDialogueId;
    
    public System.Collections.Generic.List<string> GetDialogueLines()
    {
        var lines = new System.Collections.Generic.List<string>();
        if (currentDialogue != null)
        {
            foreach (var line in currentDialogue.lines)
            {
                lines.Add(line.text);
            }
        }
        return lines;
    }
    
    public bool HasChoices() => hasChoices;
    
    public System.Collections.Generic.List<DialogueChoice> GetChoices()
    {
        var choices = new System.Collections.Generic.List<DialogueChoice>();
        if (currentDialogue != null && currentDialogueIndex < currentDialogue.lines.Count)
        {
            var line = currentDialogue.lines[currentDialogueIndex];
            if (line.choices != null)
            {
                choices.AddRange(line.choices);
            }
        }
        return choices;
    }
    
    protected override void Awake()
    {
        base.Awake();
        
        // Initialize from NPCData if available
        if (npcData != null)
        {
            InitializeFromNPCData();
        }
        
        // Set interaction prompt
        if (string.IsNullOrEmpty(interactionPrompt))
        {
            interactionPrompt = $"Press E to talk to {displayName}";
        }
    }
    
    private void InitializeFromNPCData()
    {
        npcId = npcData.npcId;
        displayName = npcData.displayName;
        npcType = npcData.npcType;
        interactionRange = npcData.interactionRange;
        requiresClick = npcData.requiresClick;
        autoInteract = npcData.autoInteract;
        interactionCooldown = npcData.interactionCooldown;
        
        defaultDialogueId = npcData.defaultDialogueId;
        dialogueOptions = new DialogueData[npcData.dialogueIds?.Length ?? 0];
        hasChoices = npcData.hasChoices;
        choiceDialogueIds = npcData.choiceDialogueIds;
        
        isOneTime = npcData.isOneTime;
        requiresItems = npcData.requiresItems;
        requiredItemIds = npcData.requiredItemIds;
        givesItems = npcData.givesItems;
        giveItemIds = npcData.giveItemIds;
        removesItems = npcData.removesItems;
        removeItemIds = npcData.removeItemIds;
        triggersSpecialEnding = npcData.triggersSpecialEnding;
        triggerEvents = npcData.triggerEvents;
        
        requiresCorrectPizza = npcData.requiresCorrectPizza;
        requiresSpecialPizza = npcData.requiresSpecialPizza;
        requiresIntroSeen = npcData.requiresIntroSeen;
        requiredFlags = npcData.requiredFlags;
        forbiddenFlags = npcData.forbiddenFlags;
        
        portrait = npcData.portrait;
        worldSprite = npcData.worldSprite;
        tintColor = npcData.tintColor;
        
        interactSoundId = npcData.interactSoundId;
        voiceSoundId = npcData.voiceSoundId;
        
        // Update sprite if world sprite is available
        var spriteRenderer = GetComponent<SpriteRenderer>();
        if (worldSprite != null && spriteRenderer != null)
        {
            spriteRenderer.sprite = worldSprite;
            spriteRenderer.color = tintColor;
        }
    }
    
    protected override void PerformInteraction(GameObject interactor)
    {
        if (isInDialogue) return;
        
        // Check if NPC can be interacted with
        if (!CanInteractWithNPC(interactor))
        {
            if (debugMode)
            {
                Debug.Log($"Cannot interact with {displayName}: conditions not met");
            }
            return;
        }
        
        // Start dialogue
        StartDialogue(interactor);
    }
    
    private bool CanInteractWithNPC(GameObject interactor)
    {
        // Check if already interacted and is one-time
        if (isOneTime && hasInteracted) return false;
        
        // Check required items
        if (requiresItems && requiredItemIds != null)
        {
            var inventory = interactor.GetComponent<PlayerInventory>();
            if (inventory == null) return false;
            
            foreach (var requiredItem in requiredItemIds)
            {
                if (!inventory.HasItem(requiredItem))
                {
                    return false;
                }
            }
        }
        
        // Check correct pizza requirement
        if (requiresCorrectPizza)
        {
            var correctPizza = GameManager.Instance.GetCorrectPizza();
            var chosenPizza = GameManager.Instance.GetChosenPizzaType();
            if (chosenPizza != correctPizza)
            {
                return false;
            }
        }
        
        // Check special pizza requirement
        if (requiresSpecialPizza)
        {
            var chosenPizza = GameManager.Instance.GetChosenPizzaType();
            if (chosenPizza != "special_pizza")
            {
                return false;
            }
        }
        
        // Check intro seen requirement
        if (requiresIntroSeen && !GameManager.Instance.HasSeenIntro())
        {
            return false;
        }
        
        // Check required flags
        if (requiredFlags != null)
        {
            foreach (var flag in requiredFlags)
            {
                if (!GameManager.Instance.HasGameFlag(flag))
                {
                    return false;
                }
            }
        }
        
        // Check forbidden flags
        if (forbiddenFlags != null)
        {
            foreach (var flag in forbiddenFlags)
            {
                if (GameManager.Instance.HasGameFlag(flag))
                {
                    return false;
                }
            }
        }
        
        return true;
    }
    
    private void StartDialogue(GameObject interactor)
    {
        isInDialogue = true;
        hasInteracted = true;
        
        // Determine which dialogue to use
        string dialogueId = DetermineDialogueId(interactor);
        
        // Start dialogue through DialogueManager
        GameEvents.InvokeDialogueStart(dialogueId);
        
        // Handle item giving/removing
        HandleItemExchange(interactor);
        
        // Handle special ending trigger
        if (triggersSpecialEnding)
        {
            GameManager.Instance.SetChosenPizzaType("special_pizza");
        }
        
        // Handle event triggers
        if (triggerEvents != null)
        {
            foreach (var eventName in triggerEvents)
            {
                GameManager.Instance.SetGameFlag(eventName);
            }
        }
        
        if (debugMode)
        {
            Debug.Log($"Started dialogue with {displayName}: {dialogueId}");
        }
    }
    
    private string DetermineDialogueId(GameObject interactor)
    {
        // Check for choice-based dialogue
        if (hasChoices && choiceDialogueIds != null && choiceDialogueIds.Length > 0)
        {
            // For now, return the first choice dialogue
            // In a full implementation, this would be based on player choices
            return choiceDialogueIds[0];
        }
        
        // Check for conditional dialogue based on inventory
        if (dialogueOptions != null && dialogueOptions.Length > 0)
        {
            var inventory = interactor.GetComponent<PlayerInventory>();
            if (inventory != null)
            {
                // Check for specific conditions and return appropriate dialogue
                foreach (var dialogue in dialogueOptions)
                {
                    if (dialogue != null && CheckDialogueConditions(dialogue, inventory))
                    {
                        return dialogue.dialogueId;
                    }
                }
            }
        }
        
        // Return default dialogue
        return defaultDialogueId;
    }
    
    private bool CheckDialogueConditions(DialogueData dialogue, PlayerInventory inventory)
    {
        // Check required items for this specific dialogue
        if (dialogue.requiresItems && dialogue.requiredItemIds != null)
        {
            foreach (var requiredItem in dialogue.requiredItemIds)
            {
                if (!inventory.HasItem(requiredItem))
                {
                    return false;
                }
            }
        }
        
        // Check pizza requirements
        if (dialogue.requiresCorrectPizza)
        {
            var correctPizza = GameManager.Instance.GetCorrectPizza();
            var chosenPizza = GameManager.Instance.GetChosenPizzaType();
            if (chosenPizza != correctPizza)
            {
                return false;
            }
        }
        
        if (dialogue.requiresSpecialPizza)
        {
            var chosenPizza = GameManager.Instance.GetChosenPizzaType();
            if (chosenPizza != "special_pizza")
            {
                return false;
            }
        }
        
        return true;
    }
    
    private void HandleItemExchange(GameObject interactor)
    {
        var inventory = interactor.GetComponent<PlayerInventory>();
        if (inventory == null) return;
        
        // Give items
        if (givesItems && giveItemIds != null)
        {
            foreach (var itemId in giveItemIds)
            {
                inventory.AddItem(itemId);
            }
        }
        
        // Remove items
        if (removesItems && removeItemIds != null)
        {
            foreach (var itemId in removeItemIds)
            {
                inventory.RemoveItem(itemId);
            }
        }
    }
    
    // IDialogueProvider implementation
    public void OnDialogueStart()
    {
        // Called when dialogue starts
        if (debugMode)
        {
            Debug.Log($"Dialogue started with {displayName}");
        }
    }
    
    public void OnDialogueEnd()
    {
        // Called when dialogue ends
        isInDialogue = false;
        
        if (debugMode)
        {
            Debug.Log($"Dialogue ended with {displayName}");
        }
    }
    
    public void OnChoiceSelected(int choiceIndex)
    {
        // Called when player makes a choice
        if (debugMode)
        {
            Debug.Log($"Choice {choiceIndex} selected for {displayName}");
        }
    }
    
    // Public API
    public void SetNPCData(NPCData data)
    {
        npcData = data;
        InitializeFromNPCData();
    }
    
    public void SetDialogueOptions(DialogueData[] dialogues)
    {
        dialogueOptions = dialogues;
    }
    
    public void SetDefaultDialogueId(string dialogueId)
    {
        defaultDialogueId = dialogueId;
    }
    
    public void SetHasChoices(bool hasChoices)
    {
        this.hasChoices = hasChoices;
    }
    
    public void SetChoiceDialogueIds(string[] choiceIds)
    {
        choiceDialogueIds = choiceIds;
    }
    
    public void SetIsOneTime(bool oneTime)
    {
        isOneTime = oneTime;
    }
    
    public void SetRequiresItems(bool requires, string[] itemIds = null)
    {
        requiresItems = requires;
        if (itemIds != null)
        {
            requiredItemIds = itemIds;
        }
    }
    
    public void SetGivesItems(bool gives, string[] itemIds = null)
    {
        givesItems = gives;
        if (itemIds != null)
        {
            giveItemIds = itemIds;
        }
    }
    
    public void SetRemovesItems(bool removes, string[] itemIds = null)
    {
        removesItems = removes;
        if (itemIds != null)
        {
            removeItemIds = itemIds;
        }
    }
    
    public void SetTriggersSpecialEnding(bool triggers)
    {
        triggersSpecialEnding = triggers;
    }
    
    public void SetTriggerEvents(string[] events)
    {
        triggerEvents = events;
    }
    
    // Getters
    public bool HasInteracted() => hasInteracted;
    public bool IsInDialogue() => isInDialogue;
    public NPCData GetNPCData() => npcData;
    public string GetNPCId() => npcId;
    public string GetDisplayName() => displayName;
    public NPCType GetNPCType() => npcType;
    public Sprite GetPortrait() => portrait;
    
    // Debug
    protected override void OnDrawGizmosSelected()
    {
        base.OnDrawGizmosSelected();
        
        // Draw NPC-specific debug info
        if (debugMode)
        {
            // Draw dialogue range
            Gizmos.color = Color.blue;
            Gizmos.DrawWireSphere(transform.position, interactionRange + 20f);
        }
    }
}

