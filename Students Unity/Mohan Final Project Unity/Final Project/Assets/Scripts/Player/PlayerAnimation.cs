using UnityEngine;

[RequireComponent(typeof(Animator))]
[RequireComponent(typeof(SpriteRenderer))]
public class PlayerAnimation : MonoBehaviour
{
    [Header("Animation Settings")]
    [SerializeField] private float idleAnimationSpeed = 1f;
    [SerializeField] private float walkAnimationSpeed = 1.5f;
    [SerializeField] private float sprintAnimationSpeed = 2f;
    [SerializeField] private float animationTransitionSpeed = 0.1f;
    
    [Header("Sprite Settings")]
    [SerializeField] private bool flipSpriteOnDirection = true;
    [SerializeField] private bool useDirectionalSprites = false;
    [SerializeField] private Sprite[] directionalSprites = new Sprite[4]; // Up, Down, Left, Right
    
    [Header("Animation Overrides")]
    [SerializeField] private RuntimeAnimatorController defaultController;
    [SerializeField] private AnimatorOverrideController[] overrideControllers;
    
    [Header("Debug")]
    [SerializeField] private bool debugMode = false;
    
    // Components
    private Animator animator;
    private SpriteRenderer spriteRenderer;
    private PlayerController playerController;
    
    // Animation state
    private bool isMoving = false;
    private bool isSprinting = false;
    private Vector2 moveDirection = Vector2.zero;
    private float moveSpeed = 0f;
    private int currentDirection = 1; // 0=Up, 1=Down, 2=Left, 3=Right
    
    // Animation parameters
    private readonly int IsMovingHash = Animator.StringToHash("IsMoving");
    private readonly int IsSprintingHash = Animator.StringToHash("IsSprinting");
    private readonly int MoveSpeedHash = Animator.StringToHash("MoveSpeed");
    private readonly int MoveXHash = Animator.StringToHash("MoveX");
    private readonly int MoveYHash = Animator.StringToHash("MoveY");
    private readonly int DirectionHash = Animator.StringToHash("Direction");
    
    private void Awake()
    {
        animator = GetComponent<Animator>();
        spriteRenderer = GetComponent<SpriteRenderer>();
        playerController = GetComponent<PlayerController>();
        
        if (playerController == null)
        {
            Debug.LogError("PlayerAnimation requires PlayerController component");
        }
    }
    
    private void Start()
    {
        InitializeAnimation();
    }
    
    private void Update()
    {
        if (playerController == null) return;
        
        UpdateAnimationState();
        UpdateAnimatorParameters();
        UpdateSpriteDirection();
        
        if (debugMode)
        {
            DebugAnimationState();
        }
    }
    
    private void InitializeAnimation()
    {
        // Set initial animation speed
        animator.speed = idleAnimationSpeed;
        
        // Set default controller if assigned
        if (defaultController != null && animator.runtimeAnimatorController == null)
        {
            animator.runtimeAnimatorController = defaultController;
        }
        
        if (debugMode)
        {
            Debug.Log("Player animation initialized");
        }
    }
    
    private void UpdateAnimationState()
    {
        // Get state from player controller
        isMoving = playerController.IsMoving();
        isSprinting = playerController.IsSprinting();
        moveDirection = playerController.GetVelocity().normalized;
        moveSpeed = playerController.GetVelocity().magnitude / playerController.GetCurrentSpeed();
        
        // Determine direction
        UpdateDirection();
    }
    
    private void UpdateDirection()
    {
        if (moveDirection.magnitude < 0.1f) return;
        
        // Determine primary direction
        float absX = Mathf.Abs(moveDirection.x);
        float absY = Mathf.Abs(moveDirection.y);
        
        if (absY > absX)
        {
            // Vertical movement
            currentDirection = moveDirection.y > 0 ? 0 : 1; // Up : Down
        }
        else
        {
            // Horizontal movement
            currentDirection = moveDirection.x > 0 ? 3 : 2; // Right : Left
        }
    }
    
    private void UpdateAnimatorParameters()
    {
        // Update animator parameters
        animator.SetBool(IsMovingHash, isMoving);
        animator.SetBool(IsSprintingHash, isSprinting);
        animator.SetFloat(MoveSpeedHash, moveSpeed);
        animator.SetFloat(MoveXHash, moveDirection.x);
        animator.SetFloat(MoveYHash, moveDirection.y);
        animator.SetInteger(DirectionHash, currentDirection);
        
        // Update animation speed based on state
        float targetSpeed = idleAnimationSpeed;
        if (isMoving)
        {
            targetSpeed = isSprinting ? sprintAnimationSpeed : walkAnimationSpeed;
        }
        
        animator.speed = Mathf.Lerp(animator.speed, targetSpeed, animationTransitionSpeed);
    }
    
    private void UpdateSpriteDirection()
    {
        if (!flipSpriteOnDirection && !useDirectionalSprites) return;
        
        if (useDirectionalSprites && directionalSprites.Length >= 4)
        {
            // Use directional sprites
            if (currentDirection >= 0 && currentDirection < directionalSprites.Length)
            {
                spriteRenderer.sprite = directionalSprites[currentDirection];
            }
        }
        else if (flipSpriteOnDirection)
        {
            // Flip sprite based on horizontal direction
            if (moveDirection.x != 0f)
            {
                spriteRenderer.flipX = moveDirection.x < 0f;
            }
        }
    }
    
    // Public API
    public void SetAnimationSpeed(float speed)
    {
        animator.speed = speed;
    }
    
    public void SetDirectionalSprites(Sprite[] sprites)
    {
        if (sprites != null && sprites.Length >= 4)
        {
            directionalSprites = sprites;
            useDirectionalSprites = true;
        }
    }
    
    public void SetOverrideController(int index)
    {
        if (index >= 0 && index < overrideControllers.Length && overrideControllers[index] != null)
        {
            animator.runtimeAnimatorController = overrideControllers[index];
        }
        else
        {
            animator.runtimeAnimatorController = defaultController;
        }
    }
    
    public void ResetToDefaultController()
    {
        animator.runtimeAnimatorController = defaultController;
    }
    
    public void PlayAnimation(string animationName)
    {
        if (!string.IsNullOrEmpty(animationName))
        {
            animator.Play(animationName);
        }
    }
    
    public void SetTrigger(string triggerName)
    {
        if (!string.IsNullOrEmpty(triggerName))
        {
            animator.SetTrigger(triggerName);
        }
    }
    
    public void SetBool(string boolName, bool value)
    {
        if (!string.IsNullOrEmpty(boolName))
        {
            animator.SetBool(boolName, value);
        }
    }
    
    public void SetFloat(string floatName, float value)
    {
        if (!string.IsNullOrEmpty(floatName))
        {
            animator.SetFloat(floatName, value);
        }
    }
    
    public void SetInteger(string intName, int value)
    {
        if (!string.IsNullOrEmpty(intName))
        {
            animator.SetInteger(intName, value);
        }
    }
    
    // Getters
    public bool IsMoving() => isMoving;
    public bool IsSprinting() => isSprinting;
    public Vector2 GetMoveDirection() => moveDirection;
    public float GetMoveSpeed() => moveSpeed;
    public int GetCurrentDirection() => currentDirection;
    public Animator GetAnimator() => animator;
    public SpriteRenderer GetSpriteRenderer() => spriteRenderer;
    
    // Debug
    private void DebugAnimationState()
    {
        if (Input.GetKeyDown(KeyCode.F7))
        {
            Debug.Log($"Animation State - Moving: {isMoving}, Sprinting: {isSprinting}, Direction: {currentDirection}, Speed: {moveSpeed:F2}");
        }
        
        if (Input.GetKeyDown(KeyCode.F8))
        {
            SetAnimationSpeed(2f);
        }
        
        if (Input.GetKeyDown(KeyCode.F9))
        {
            SetAnimationSpeed(1f);
        }
    }
    
    // Animation event handlers (can be called from animation clips)
    public void OnFootstep()
    {
        // Play footstep sound
        GameEvents.InvokePlaySound("footstep");
    }
    
    public void OnSprintStart()
    {
        // Play sprint start sound
        GameEvents.InvokePlaySound("sprint_start");
    }
    
    public void OnSprintEnd()
    {
        // Play sprint end sound
        GameEvents.InvokePlaySound("sprint_end");
    }
    
    public void OnInteractionStart()
    {
        // Play interaction sound
        GameEvents.InvokePlaySound("interact");
    }
    
    public void OnInteractionEnd()
    {
        // Play interaction end sound
        GameEvents.InvokePlaySound("interact_end");
    }
}

