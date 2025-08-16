using UnityEngine;
using UnityEngine.InputSystem;

public class InputManager : MonoBehaviour
{
    public static InputManager Instance { get; private set; }
    
    [Header("Input Configuration")]
    [SerializeField] private PlayerInput playerInput;
    [SerializeField] private bool enableLegacyInput = true;
    [SerializeField] private bool debugMode = false;
    
    [Header("Input State")]
    [SerializeField] private Vector2 moveInput = Vector2.zero;
    [SerializeField] private bool sprintInput = false;
    [SerializeField] private bool interactInput = false;
    [SerializeField] private bool advanceInput = false;
    [SerializeField] private int choiceInput = -1;
    [SerializeField] private bool pauseInput = false;
    [SerializeField] private bool restartInput = false;
    
    // Input action references
    private InputAction moveAction;
    private InputAction sprintAction;
    private InputAction interactAction;
    private InputAction advanceAction;
    private InputAction choice1Action;
    private InputAction choice2Action;
    private InputAction pauseAction;
    private InputAction restartAction;
    
    private void Awake()
    {
        // Singleton pattern
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
            InitializeInput();
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
    
    private void Update()
    {
        if (enableLegacyInput)
        {
            HandleLegacyInput();
        }
        
        // Reset one-frame inputs
        interactInput = false;
        advanceInput = false;
        choiceInput = -1;
        pauseInput = false;
        restartInput = false;
    }
    
    private void InitializeInput()
    {
        if (playerInput != null)
        {
            // Get input actions
            moveAction = playerInput.actions["Move"];
            sprintAction = playerInput.actions["Sprint"];
            interactAction = playerInput.actions["Interact"];
            advanceAction = playerInput.actions["Advance"];
            choice1Action = playerInput.actions["Choice1"];
            choice2Action = playerInput.actions["Choice2"];
            pauseAction = playerInput.actions["Pause"];
            restartAction = playerInput.actions["Restart"];
            
            // Subscribe to input events
            if (moveAction != null)
                moveAction.performed += OnMovePerformed;
            if (sprintAction != null)
                sprintAction.performed += OnSprintPerformed;
            if (interactAction != null)
                interactAction.performed += OnInteractPerformed;
            if (advanceAction != null)
                advanceAction.performed += OnAdvancePerformed;
            if (choice1Action != null)
                choice1Action.performed += OnChoice1Performed;
            if (choice2Action != null)
                choice2Action.performed += OnChoice2Performed;
            if (pauseAction != null)
                pauseAction.performed += OnPausePerformed;
            if (restartAction != null)
                restartAction.performed += OnRestartPerformed;
            
            if (debugMode)
            {
                Debug.Log("Input system initialized");
            }
        }
        else
        {
            if (debugMode)
            {
                Debug.LogWarning("PlayerInput not assigned, using legacy input only");
            }
        }
    }
    
    private void SubscribeToEvents()
    {
        // Subscribe to game state changes to enable/disable input
        GameEvents.OnGameStateChanged += OnGameStateChanged;
    }
    
    private void UnsubscribeFromEvents()
    {
        GameEvents.OnGameStateChanged -= OnGameStateChanged;
    }
    
    // Input System callbacks
    private void OnMovePerformed(InputAction.CallbackContext context)
    {
        moveInput = context.ReadValue<Vector2>();
        GameEvents.InvokePlayerMove(moveInput);
        InputEvents.InvokeMoveInput(moveInput);
        
        if (debugMode)
        {
            Debug.Log($"Move input: {moveInput}");
        }
    }
    
    private void OnSprintPerformed(InputAction.CallbackContext context)
    {
        sprintInput = context.ReadValueAsButton();
        GameEvents.InvokePlayerSprint(sprintInput);
        InputEvents.InvokeSprintInput(sprintInput);
        
        if (debugMode)
        {
            Debug.Log($"Sprint input: {sprintInput}");
        }
    }
    
    private void OnInteractPerformed(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            interactInput = true;
            GameEvents.InvokePlayerInteract(null);
            InputEvents.InvokeInteractInput();
            
            if (debugMode)
            {
                Debug.Log("Interact input");
            }
        }
    }
    
    private void OnAdvancePerformed(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            advanceInput = true;
            GameEvents.InvokeDialogueNext("");
            InputEvents.InvokeAdvanceInput();
            
            if (debugMode)
            {
                Debug.Log("Advance input");
            }
        }
    }
    
    private void OnChoice1Performed(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            choiceInput = 0;
            GameEvents.InvokeDialogueChoice(0);
            InputEvents.InvokeChoiceInput(0);
            
            if (debugMode)
            {
                Debug.Log("Choice 1 input");
            }
        }
    }
    
    private void OnChoice2Performed(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            choiceInput = 1;
            GameEvents.InvokeDialogueChoice(1);
            InputEvents.InvokeChoiceInput(1);
            
            if (debugMode)
            {
                Debug.Log("Choice 2 input");
            }
        }
    }
    
    private void OnPausePerformed(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            pauseInput = true;
            InputEvents.InvokePauseInput();
            
            if (debugMode)
            {
                Debug.Log("Pause input");
            }
        }
    }
    
    private void OnRestartPerformed(InputAction.CallbackContext context)
    {
        if (context.performed)
        {
            restartInput = true;
            GameEvents.InvokeGameRestart();
            InputEvents.InvokeRestartInput();
            
            if (debugMode)
            {
                Debug.Log("Restart input");
            }
        }
    }
    
    // Legacy input handling
    private void HandleLegacyInput()
    {
        // Move input
        Vector2 legacyMoveInput = Vector2.zero;
        if (Input.GetKey(KeyCode.W) || Input.GetKey(KeyCode.UpArrow))
            legacyMoveInput.y += 1f;
        if (Input.GetKey(KeyCode.S) || Input.GetKey(KeyCode.DownArrow))
            legacyMoveInput.y -= 1f;
        if (Input.GetKey(KeyCode.A) || Input.GetKey(KeyCode.LeftArrow))
            legacyMoveInput.x -= 1f;
        if (Input.GetKey(KeyCode.D) || Input.GetKey(KeyCode.RightArrow))
            legacyMoveInput.x += 1f;
        
        if (legacyMoveInput != moveInput)
        {
            moveInput = legacyMoveInput.normalized;
            GameEvents.InvokePlayerMove(moveInput);
            InputEvents.InvokeMoveInput(moveInput);
        }
        
        // Sprint input
        bool legacySprintInput = Input.GetKey(KeyCode.LeftShift) || Input.GetKey(KeyCode.RightShift);
        if (legacySprintInput != sprintInput)
        {
            sprintInput = legacySprintInput;
            GameEvents.InvokePlayerSprint(sprintInput);
            InputEvents.InvokeSprintInput(sprintInput);
        }
        
        // Interact input
        if (Input.GetKeyDown(KeyCode.E) || Input.GetMouseButtonDown(0))
        {
            interactInput = true;
            GameEvents.InvokePlayerInteract(null);
            InputEvents.InvokeInteractInput();
        }
        
        // Advance input
        if (Input.GetKeyDown(KeyCode.Return) || Input.GetKeyDown(KeyCode.Space))
        {
            advanceInput = true;
            GameEvents.InvokeDialogueNext("");
            InputEvents.InvokeAdvanceInput();
        }
        
        // Choice inputs
        if (Input.GetKeyDown(KeyCode.Alpha1) || Input.GetKeyDown(KeyCode.Keypad1))
        {
            choiceInput = 0;
            GameEvents.InvokeDialogueChoice(0);
            InputEvents.InvokeChoiceInput(0);
        }
        else if (Input.GetKeyDown(KeyCode.Alpha2) || Input.GetKeyDown(KeyCode.Keypad2))
        {
            choiceInput = 1;
            GameEvents.InvokeDialogueChoice(1);
            InputEvents.InvokeChoiceInput(1);
        }
        
        // Pause input
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            pauseInput = true;
            InputEvents.InvokePauseInput();
        }
        
        // Restart input
        if (Input.GetKeyDown(KeyCode.R))
        {
            restartInput = true;
            GameEvents.InvokeGameRestart();
            InputEvents.InvokeRestartInput();
        }
    }
    
    // Game state handling
    private void OnGameStateChanged(GameState newState)
    {
        // Enable/disable input based on game state
        bool enableInput = newState == GameState.Playing || newState == GameState.Dialogue;
        
        if (playerInput != null)
        {
            playerInput.enabled = enableInput;
        }
        
        if (debugMode)
        {
            Debug.Log($"Input enabled: {enableInput} (State: {newState})");
        }
    }
    
    // Public API
    public Vector2 GetMoveInput() => moveInput;
    public bool GetSprintInput() => sprintInput;
    public bool GetInteractInput() => interactInput;
    public bool GetAdvanceInput() => advanceInput;
    public int GetChoiceInput() => choiceInput;
    public bool GetPauseInput() => pauseInput;
    public bool GetRestartInput() => restartInput;
    
    public void SetPlayerInput(PlayerInput input)
    {
        playerInput = input;
        InitializeInput();
    }
    
    public void EnableInput(bool enable)
    {
        if (playerInput != null)
        {
            playerInput.enabled = enable;
        }
    }
    
    public void SetLegacyInputEnabled(bool enabled)
    {
        enableLegacyInput = enabled;
    }
    
    // Utility methods
    public bool IsAnyInputPressed()
    {
        return moveInput.magnitude > 0.1f || sprintInput || interactInput || advanceInput || 
               choiceInput >= 0 || pauseInput || restartInput;
    }
    
    public void ClearInputs()
    {
        moveInput = Vector2.zero;
        sprintInput = false;
        interactInput = false;
        advanceInput = false;
        choiceInput = -1;
        pauseInput = false;
        restartInput = false;
    }
}

