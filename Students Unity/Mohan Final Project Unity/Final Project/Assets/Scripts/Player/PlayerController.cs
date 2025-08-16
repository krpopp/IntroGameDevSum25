using UnityEngine;
using System.Collections.Generic;

[RequireComponent(typeof(Rigidbody2D))]
[RequireComponent(typeof(Collider2D))]
public class PlayerController : MonoBehaviour, IGameStateListener
{
    [Header("Movement Settings")]
    [SerializeField] private float baseSpeed = 2f;
    [SerializeField] private float maxSpeed = 8f;
    [SerializeField] private float sprintRampTime = 4f;
    [SerializeField] private float acceleration = 10f;
    [SerializeField] private float deceleration = 15f;
    
    [Header("Interaction Settings")]
    [SerializeField] private float interactionRange = 100f;
    [SerializeField] private LayerMask interactableLayerMask = -1;
    [SerializeField] private LayerMask collisionLayerMask = -1;
    
    [Header("Animation")]
    [SerializeField] private Animator animator;
    [SerializeField] private SpriteRenderer spriteRenderer;
    
    [Header("Debug")]
    [SerializeField] private bool debugMode = false;
    [SerializeField] private bool showInteractionRange = true;
    
    // Components
    private Rigidbody2D rb;
    private Collider2D col;
    
    // Movement state
    private Vector2 moveInput = Vector2.zero;
    private Vector2 currentVelocity = Vector2.zero;
    private bool isSprinting = false;
    private float sprintTimer = 0f;
    private float currentSpeed = 0f;
    
    // Interaction state
    private List<IInteractable> nearbyInteractables = new List<IInteractable>();
    private IInteractable closestInteractable = null;
    private bool canInteract = true;
    private float interactionCooldown = 0f;
    
    // Animation state
    private bool isMoving = false;
    private Vector2 lastMoveDirection = Vector2.zero;
    
    // Events
    public System.Action<Vector2> OnMove;
    public System.Action<bool> OnSprint;
    public System.Action<IInteractable> OnInteract;
    public System.Action<string> OnCollect;
    
    private void Awake()
    {
        rb = GetComponent<Rigidbody2D>();
        col = GetComponent<Collider2D>();
        
        // Configure Rigidbody2D
        rb.gravityScale = 0f;
        rb.drag = 0f;
        rb.angularDrag = 0f;
        rb.constraints = RigidbodyConstraints2D.FreezeRotation;
        
        // Configure Collider2D
        col.isTrigger = false;
    }
    
    private void Start()
    {
        SubscribeToEvents();
        currentSpeed = baseSpeed;
    }
    
    private void OnDestroy()
    {
        UnsubscribeFromEvents();
    }
    
    private void Update()
    {
        if (GameManager.Instance.GetCurrentState() != GameState.Playing)
            return;
        
        HandleInput();
        UpdateMovement();
        UpdateInteraction();
        UpdateAnimation();
        
        if (debugMode)
        {
            HandleDebugInput();
        }
    }
    
    private void FixedUpdate()
    {
        if (GameManager.Instance.GetCurrentState() != GameState.Playing)
            return;
        
        ApplyMovement();
    }
    
    private void SubscribeToEvents()
    {
        GameEvents.OnPlayerMove += OnMoveInput;
        GameEvents.OnPlayerSprint += OnSprintInput;
        GameEvents.OnPlayerInteract += OnInteractInput;
        GameEvents.OnGameStateChanged += HandleGameStateChanged;
    }
    
    private void UnsubscribeFromEvents()
    {
        GameEvents.OnPlayerMove -= OnMoveInput;
        GameEvents.OnPlayerSprint -= OnSprintInput;
        GameEvents.OnPlayerInteract -= OnInteractInput;
        GameEvents.OnGameStateChanged -= HandleGameStateChanged;
    }
    
    private void HandleInput()
    {
        // Input is handled through events from InputManager
        // This method can be used for additional input processing if needed
    }
    
    private void UpdateMovement()
    {
        // Update sprint timer and speed
        if (isSprinting && moveInput.magnitude > 0.1f)
        {
            sprintTimer += Time.deltaTime;
            float sprintProgress = Mathf.Clamp01(sprintTimer / sprintRampTime);
            currentSpeed = Mathf.Lerp(baseSpeed, maxSpeed, sprintProgress);
        }
        else
        {
            sprintTimer = 0f;
            currentSpeed = baseSpeed;
        }
        
        // Calculate target velocity
        Vector2 targetVelocity = moveInput * currentSpeed;
        
        // Apply acceleration/deceleration
        if (moveInput.magnitude > 0.1f)
        {
            currentVelocity = Vector2.MoveTowards(currentVelocity, targetVelocity, acceleration * Time.deltaTime);
        }
        else
        {
            currentVelocity = Vector2.MoveTowards(currentVelocity, Vector2.zero, deceleration * Time.deltaTime);
        }
        
        // Update movement state
        isMoving = currentVelocity.magnitude > 0.1f;
        if (isMoving)
        {
            lastMoveDirection = currentVelocity.normalized;
        }
        
        // Update sprite direction
        if (spriteRenderer != null && lastMoveDirection.x != 0f)
        {
            spriteRenderer.flipX = lastMoveDirection.x < 0f;
        }
    }
    
    private void ApplyMovement()
    {
        // Apply velocity to rigidbody (Unity uses velocity)
        rb.velocity = currentVelocity;
        
        // Emit movement event
        if (isMoving)
        {
            OnMove?.Invoke(currentVelocity);
        }
    }
    
    private void UpdateInteraction()
    {
        // Update interaction cooldown
        if (interactionCooldown > 0f)
        {
            interactionCooldown -= Time.deltaTime;
            if (interactionCooldown <= 0f)
            {
                canInteract = true;
            }
        }
        
        // Find nearby interactables
        FindNearbyInteractables();
        
        // Update closest interactable
        UpdateClosestInteractable();
    }
    
    private void FindNearbyInteractables()
    {
        nearbyInteractables.Clear();
        
        // Find all colliders in interaction range
        Collider2D[] colliders = Physics2D.OverlapCircleAll(transform.position, interactionRange, interactableLayerMask);
        
        foreach (var collider in colliders)
        {
            var interactable = collider.GetComponent<IInteractable>();
            if (interactable != null && interactable.CanInteract(gameObject))
            {
                nearbyInteractables.Add(interactable);
            }
        }
    }
    
    private void UpdateClosestInteractable()
    {
        closestInteractable = null;
        float closestDistance = float.MaxValue;
        
        foreach (var interactable in nearbyInteractables)
        {
            if (interactable == null) continue;
            
            float distance = Vector2.Distance(transform.position, 
                (interactable as MonoBehaviour)?.transform.position ?? transform.position);
            
            if (distance < closestDistance && distance <= interactable.GetInteractionRange())
            {
                closestDistance = distance;
                closestInteractable = interactable;
            }
        }
    }
    
    private void UpdateAnimation()
    {
        if (animator == null) return;
        
        // Update animation parameters
        animator.SetBool("IsMoving", isMoving);
        animator.SetBool("IsSprinting", isSprinting);
        animator.SetFloat("MoveSpeed", currentVelocity.magnitude / maxSpeed);
        animator.SetFloat("MoveX", lastMoveDirection.x);
        animator.SetFloat("MoveY", lastMoveDirection.y);
    }
    
    // Event handlers
    private void OnMoveInput(Vector2 input)
    {
        moveInput = input;
    }
    
    private void OnSprintInput(bool sprinting)
    {
        isSprinting = sprinting;
        OnSprint?.Invoke(sprinting);
    }
    
    private void OnInteractInput(GameObject interactable)
    {
        if (!canInteract || closestInteractable == null) return;
        
        // Check if we're in range
        if (!closestInteractable.IsInRange(gameObject)) return;
        
        // Perform interaction
        closestInteractable.Interact(gameObject);
        OnInteract?.Invoke(closestInteractable);
        
        // Set cooldown
        interactionCooldown = 0.5f;
        canInteract = false;
        
        if (debugMode)
        {
            Debug.Log($"Interacted with: {closestInteractable.GetInteractionPrompt()}");
        }
    }
    
    private void HandleGameStateChanged(GameState newState)
    {
        // Stop movement when not playing
        if (newState != GameState.Playing)
        {
            moveInput = Vector2.zero;
            currentVelocity = Vector2.zero;
            rb.velocity = Vector2.zero;
        }
    }
    
    // Public API
    public void SetSpeed(float speed)
    {
        baseSpeed = speed;
        currentSpeed = speed;
    }
    
    public void SetMaxSpeed(float maxSpeed)
    {
        this.maxSpeed = maxSpeed;
    }
    
    public void SetInteractionRange(float range)
    {
        interactionRange = range;
    }
    
    public void ForceInteraction()
    {
        if (closestInteractable != null)
        {
            OnInteractInput(null);
        }
    }
    
    // Getters
    public Vector2 GetMoveInput() => moveInput;
    public Vector2 GetVelocity() => currentVelocity;
    public bool IsMoving() => isMoving;
    public bool IsSprinting() => isSprinting;
    public float GetCurrentSpeed() => currentSpeed;
    public IInteractable GetClosestInteractable() => closestInteractable;
    public bool CanInteract() => canInteract && closestInteractable != null;
    public string GetInteractionPrompt()
    {
        return closestInteractable?.GetInteractionPrompt() ?? "";
    }
    
    // IGameStateListener implementation
    public void OnGameStateChanged(GameState newState) => HandleGameStateChanged(newState);
    public void OnTimerChanged(float timeRemaining) { }
    public void OnTemperatureChanged(int temperatureFrame) { }
    public void OnItemCollected(string itemId) => OnCollect?.Invoke(itemId);
    public void OnGameSuccess() { }
    public void OnGameFailure() { }
    
    // Debug
    private void HandleDebugInput()
    {
        if (Input.GetKeyDown(KeyCode.F5))
        {
            SetSpeed(baseSpeed * 2f);
        }
        if (Input.GetKeyDown(KeyCode.F6))
        {
            SetSpeed(baseSpeed);
        }
    }
    
    private void OnDrawGizmosSelected()
    {
        if (!showInteractionRange) return;
        
        // Draw interaction range
        Gizmos.color = Color.yellow;
        Gizmos.DrawWireSphere(transform.position, interactionRange);
        
        // Draw closest interactable
        if (closestInteractable != null)
        {
            Gizmos.color = Color.green;
            var interactableTransform = (closestInteractable as MonoBehaviour)?.transform;
            if (interactableTransform != null)
            {
                Gizmos.DrawLine(transform.position, interactableTransform.position);
            }
        }
    }
}

