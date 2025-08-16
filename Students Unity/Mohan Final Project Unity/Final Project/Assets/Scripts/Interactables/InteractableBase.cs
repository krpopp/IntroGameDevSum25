using UnityEngine;

public abstract class InteractableBase : MonoBehaviour, IInteractable
{
    [Header("Interaction Settings")]
    [SerializeField] protected float interactionRange = 64f;
    [SerializeField] protected bool requiresClick = true;
    [SerializeField] protected bool autoInteract = false;
    [SerializeField] protected float interactionCooldown = 1f;
    [SerializeField] protected string interactionPrompt = "Press E to interact";
    
    [Header("Visual Feedback")]
    [SerializeField] protected bool showInteractionPrompt = true;
    [SerializeField] protected GameObject promptUI;
    [SerializeField] protected SpriteRenderer highlightRenderer;
    [SerializeField] protected Color highlightColor = Color.yellow;
    
    [Header("Audio")]
    [SerializeField] protected string interactSoundId = "interact";
    [SerializeField] protected string hoverSoundId = "hover";
    
    [Header("Debug")]
    [SerializeField] protected bool debugMode = false;
    
    // State
    protected bool isInteractable = true;
    protected bool isInRange = false;
    protected float lastInteractionTime = 0f;
    protected GameObject currentInteractor = null;
    
    // Events
    public System.Action<GameObject> OnInteractStart;
    public System.Action<GameObject> OnInteractComplete;
    public System.Action<GameObject> OnEnterRange;
    public System.Action<GameObject> OnExitRange;
    
    protected virtual void Awake()
    {
        // Initialize components
        if (highlightRenderer == null)
        {
            highlightRenderer = GetComponent<SpriteRenderer>();
        }
        
        // Set initial state
        SetInteractable(true);
        UpdateVisualState();
    }
    
    protected virtual void Start()
    {
        // Subscribe to events
        SubscribeToEvents();
    }
    
    protected virtual void OnDestroy()
    {
        // Unsubscribe from events
        UnsubscribeFromEvents();
    }
    
    protected virtual void Update()
    {
        // Handle auto-interaction
        if (autoInteract && isInRange && CanInteract(currentInteractor))
        {
            Interact(currentInteractor);
        }
        
        // Update visual state
        UpdateVisualState();
    }
    
    protected virtual void SubscribeToEvents()
    {
        // Override in derived classes to subscribe to specific events
    }
    
    protected virtual void UnsubscribeFromEvents()
    {
        // Override in derived classes to unsubscribe from specific events
    }
    
    // IInteractable implementation
    public virtual bool CanInteract(GameObject interactor)
    {
        if (!isInteractable) return false;
        
        // Check cooldown
        if (Time.time - lastInteractionTime < interactionCooldown) return false;
        
        // Check if interactor is valid
        if (interactor == null) return false;
        
        // Check if interactor is in range
        if (!IsInRange(interactor)) return false;
        
        return true;
    }
    
    public virtual void Interact(GameObject interactor)
    {
        if (!CanInteract(interactor)) return;
        
        // Update state
        lastInteractionTime = Time.time;
        currentInteractor = interactor;
        
        // Play sound
        if (!string.IsNullOrEmpty(interactSoundId))
        {
            GameEvents.InvokePlaySound(interactSoundId);
        }
        
        // Emit events
        OnInteractStart?.Invoke(interactor);
        
        // Perform interaction
        PerformInteraction(interactor);
        
        // Emit completion event
        OnInteractComplete?.Invoke(interactor);
        
        if (debugMode)
        {
            Debug.Log($"{gameObject.name} interacted with by {interactor.name}");
        }
    }
    
    public virtual string GetInteractionPrompt()
    {
        return interactionPrompt;
    }
    
    public virtual float GetInteractionRange()
    {
        return interactionRange;
    }
    
    public virtual bool IsInRange(GameObject interactor)
    {
        if (interactor == null) return false;
        
        float distance = Vector2.Distance(transform.position, interactor.transform.position);
        return distance <= interactionRange;
    }
    
    // Abstract methods to be implemented by derived classes
    protected abstract void PerformInteraction(GameObject interactor);
    
    // Public API
    public virtual void SetInteractable(bool interactable)
    {
        isInteractable = interactable;
        UpdateVisualState();
    }
    
    public virtual void SetInteractionRange(float range)
    {
        interactionRange = range;
    }
    
    public virtual void SetInteractionPrompt(string prompt)
    {
        interactionPrompt = prompt;
    }
    
    public virtual void SetRequiresClick(bool requires)
    {
        requiresClick = requires;
    }
    
    public virtual void SetAutoInteract(bool auto)
    {
        autoInteract = auto;
    }
    
    public virtual void SetInteractionCooldown(float cooldown)
    {
        interactionCooldown = cooldown;
    }
    
    // Range detection
    protected virtual void OnTriggerEnter2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            isInRange = true;
            currentInteractor = other.gameObject;
            OnEnterRange?.Invoke(other.gameObject);
            
            // Play hover sound
            if (!string.IsNullOrEmpty(hoverSoundId))
            {
                GameEvents.InvokePlaySound(hoverSoundId);
            }
            
            if (debugMode)
            {
                Debug.Log($"{gameObject.name} entered range of {other.name}");
            }
        }
    }
    
    protected virtual void OnTriggerExit2D(Collider2D other)
    {
        if (other.CompareTag("Player"))
        {
            isInRange = false;
            currentInteractor = null;
            OnExitRange?.Invoke(other.gameObject);
            
            if (debugMode)
            {
                Debug.Log($"{gameObject.name} exited range of {other.name}");
            }
        }
    }
    
    // Visual feedback
    protected virtual void UpdateVisualState()
    {
        // Update highlight
        if (highlightRenderer != null)
        {
            if (isInRange && isInteractable)
            {
                highlightRenderer.color = highlightColor;
            }
            else
            {
                highlightRenderer.color = Color.white;
            }
        }
        
        // Update prompt UI
        if (promptUI != null)
        {
            promptUI.SetActive(showInteractionPrompt && isInRange && isInteractable);
        }
    }
    
    // Getters
    public bool IsInteractable() => isInteractable;
    public bool IsInRange() => isInRange;
    public GameObject GetCurrentInteractor() => currentInteractor;
    public float GetLastInteractionTime() => lastInteractionTime;
    
    // Debug
    protected virtual void OnDrawGizmosSelected()
    {
        // Draw interaction range
        Gizmos.color = isInteractable ? Color.green : Color.red;
        Gizmos.DrawWireSphere(transform.position, interactionRange);
        
        // Draw interaction direction if applicable
        if (isInRange && currentInteractor != null)
        {
            Gizmos.color = Color.yellow;
            Gizmos.DrawLine(transform.position, currentInteractor.transform.position);
        }
    }
    
    protected virtual void OnValidate()
    {
        // Ensure interaction range is positive
        interactionRange = Mathf.Max(0f, interactionRange);
        interactionCooldown = Mathf.Max(0f, interactionCooldown);
    }
}

