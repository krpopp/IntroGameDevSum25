using UnityEngine;
// using Cinemachine; // Temporarily commented out until package is installed

public class CameraController : MonoBehaviour
{
    [Header("Camera Settings")]
    [SerializeField] private Camera mainCamera;
    // [SerializeField] private CinemachineVirtualCamera virtualCamera; // Temporarily commented out
    // [SerializeField] private CinemachineConfiner2D confiner; // Temporarily commented out
    [SerializeField] private Collider2D cameraBounds;
    
    [Header("Follow Settings")]
    [SerializeField] private Transform target;
    [SerializeField] private float followSpeed = 5f;
    [SerializeField] private Vector3 offset = Vector3.zero;
    [SerializeField] private bool useSmoothFollow = true;
    [SerializeField] private float smoothTime = 0.1f;
    
    [Header("Bounds Settings")]
    [SerializeField] private Vector2 cameraBoundsSize = new Vector2(1366f, 768f);
    [SerializeField] private bool useBounds = true;
    [SerializeField] private bool showBounds = true;
    
    [Header("Shake Settings")]
    [SerializeField] private bool enableShake = true;
    [SerializeField] private float shakeIntensity = 0.1f;
    [SerializeField] private float shakeDuration = 0.2f;
    [SerializeField] private float shakeDecay = 0.95f;
    
    [Header("Zoom Settings")]
    [SerializeField] private bool enableZoom = false;
    [SerializeField] private float minZoom = 0.5f;
    [SerializeField] private float maxZoom = 2f;
    [SerializeField] private float zoomSpeed = 1f;
    [SerializeField] private float defaultZoom = 1f;
    
    [Header("Debug")]
    [SerializeField] private bool debugMode = false;
    
    // Private state
    private Vector3 velocity = Vector3.zero;
    private Vector3 originalPosition;
    private float shakeTimer = 0f;
    private float currentShakeIntensity = 0f;
    private float currentZoom = 1f;
    private bool isShaking = false;
    
    // Events
    public System.Action<Vector3> OnCameraMove;
    public System.Action<float> OnCameraZoom;
    public System.Action OnCameraShake;
    
    private void Awake()
    {
        // Get or create camera components
        if (mainCamera == null)
        {
            mainCamera = Camera.main;
        }
        
        // if (virtualCamera == null)
        // {
        //     virtualCamera = GetComponent<CinemachineVirtualCamera>();
        // }
        
        // if (confiner == null)
        // {
        //     confiner = GetComponent<CinemachineConfiner2D>();
        // }
        
        // Store original position
        originalPosition = transform.position;
        currentZoom = defaultZoom;
        
        // Initialize camera
        InitializeCamera();
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
        // Handle camera shake
        if (isShaking)
        {
            UpdateCameraShake();
        }
        
        // Handle zoom input
        if (enableZoom)
        {
            HandleZoomInput();
        }
        
        if (debugMode)
        {
            HandleDebugInput();
        }
    }
    
    private void LateUpdate()
    {
        // Update camera follow
        if (target != null && !useSmoothFollow)
        {
            UpdateCameraFollow();
        }
    }
    
    private void SubscribeToEvents()
    {
        // Subscribe to game events that might affect camera
        GameEvents.OnGameStateChanged += OnGameStateChanged;
    }
    
    private void UnsubscribeFromEvents()
    {
        GameEvents.OnGameStateChanged -= OnGameStateChanged;
    }
    
    private void InitializeCamera()
    {
        // Set up virtual camera if available
        // if (virtualCamera != null)
        // {
        //     virtualCamera.Follow = target;
        //     virtualCamera.LookAt = target;
        // }
        
        // Set up confiner if available
        // if (confiner != null && cameraBounds != null)
        // {
        //     confiner.m_BoundingShape2D = cameraBounds;
        // }
        
        // Set initial zoom
        if (enableZoom)
        {
            SetZoom(defaultZoom);
        }
        
        if (debugMode)
        {
            Debug.Log("Camera controller initialized");
        }
    }
    
    private void UpdateCameraFollow()
    {
        if (target == null) return;
        
        Vector3 targetPosition = target.position + offset;
        
        // Apply bounds if enabled
        if (useBounds)
        {
            targetPosition = ClampToBounds(targetPosition);
        }
        
        // Move camera
        transform.position = targetPosition;
        
        // Emit event
        OnCameraMove?.Invoke(targetPosition);
    }
    
    private Vector3 ClampToBounds(Vector3 position)
    {
        Vector2 bounds = cameraBoundsSize * 0.5f;
        
        position.x = Mathf.Clamp(position.x, -bounds.x, bounds.x);
        position.y = Mathf.Clamp(position.y, -bounds.y, bounds.y);
        
        return position;
    }
    
    private void UpdateCameraShake()
    {
        if (shakeTimer <= 0f)
        {
            // End shake
            isShaking = false;
            transform.position = originalPosition;
            return;
        }
        
        shakeTimer -= Time.deltaTime;
        currentShakeIntensity *= shakeDecay;
        
        // Apply shake
        Vector3 shakeOffset = Random.insideUnitSphere * currentShakeIntensity;
        transform.position = originalPosition + shakeOffset;
    }
    
    private void HandleZoomInput()
    {
        // Mouse wheel zoom
        float scroll = Input.GetAxis("Mouse ScrollWheel");
        if (Mathf.Abs(scroll) > 0.01f)
        {
            float zoomDelta = scroll * zoomSpeed;
            SetZoom(currentZoom + zoomDelta);
        }
    }
    
    // Public API
    public void SetTarget(Transform newTarget)
    {
        target = newTarget;
        
        // if (virtualCamera != null)
        // {
        //     virtualCamera.Follow = newTarget;
        //     virtualCamera.LookAt = newTarget;
        // }
        
        if (debugMode)
        {
            Debug.Log($"Camera target set to: {newTarget?.name ?? "null"}");
        }
    }
    
    public void SetFollowSpeed(float speed)
    {
        followSpeed = speed;
    }
    
    public void SetOffset(Vector3 newOffset)
    {
        offset = newOffset;
    }
    
    public void SetUseSmoothFollow(bool smooth)
    {
        useSmoothFollow = smooth;
    }
    
    public void SetSmoothTime(float time)
    {
        smoothTime = time;
    }
    
    public void SetCameraBounds(Vector2 bounds)
    {
        cameraBoundsSize = bounds;
    }
    
    public void SetUseBounds(bool use)
    {
        useBounds = use;
    }
    
    public void ShakeCamera(float intensity = -1f, float duration = -1f)
    {
        if (!enableShake) return;
        
        isShaking = true;
        shakeTimer = duration > 0f ? duration : shakeDuration;
        currentShakeIntensity = intensity > 0f ? intensity : shakeIntensity;
        originalPosition = transform.position;
        
        OnCameraShake?.Invoke();
        
        if (debugMode)
        {
            Debug.Log($"Camera shake: {currentShakeIntensity} intensity, {shakeTimer}s duration");
        }
    }
    
    public void StopShake()
    {
        isShaking = false;
        shakeTimer = 0f;
        transform.position = originalPosition;
    }
    
    public void SetZoom(float zoom)
    {
        if (!enableZoom) return;
        
        currentZoom = Mathf.Clamp(zoom, minZoom, maxZoom);
        
        if (mainCamera != null)
        {
            mainCamera.orthographicSize = 5f / currentZoom; // Adjust base size as needed
        }
        
        OnCameraZoom?.Invoke(currentZoom);
        
        if (debugMode)
        {
            Debug.Log($"Camera zoom set to: {currentZoom}");
        }
    }
    
    public void ResetZoom()
    {
        SetZoom(defaultZoom);
    }
    
    public void SetCameraBoundsCollider(Collider2D bounds)
    {
        cameraBounds = bounds;
        
        // if (confiner != null)
        // {
        //     confiner.m_BoundingShape2D = bounds;
        // }
    }
    
    public void EnableShake(bool enable)
    {
        enableShake = enable;
        if (!enable && isShaking)
        {
            StopShake();
        }
    }
    
    public void EnableZoom(bool enable)
    {
        enableZoom = enable;
        if (!enable)
        {
            ResetZoom();
        }
    }
    
    // Event handlers
    private void OnGameStateChanged(GameState newState)
    {
        // Handle camera behavior based on game state
        switch (newState)
        {
            case GameState.Playing:
                // Normal camera behavior
                break;
            case GameState.Dialogue:
                // Maybe zoom in slightly for dialogue
                if (enableZoom)
                {
                    SetZoom(currentZoom * 0.9f);
                }
                break;
            case GameState.Success:
            case GameState.Failure:
                // Maybe zoom out for end screens
                if (enableZoom)
                {
                    SetZoom(currentZoom * 1.2f);
                }
                break;
        }
    }
    
    // Getters
    public Transform GetTarget() => target;
    public float GetFollowSpeed() => followSpeed;
    public Vector3 GetOffset() => offset;
    public bool IsShaking() => isShaking;
    public float GetCurrentZoom() => currentZoom;
    public Vector2 GetCameraBounds() => cameraBoundsSize;
    public bool IsUsingBounds() => useBounds;
    
    // Debug
    private void HandleDebugInput()
    {
        if (Input.GetKeyDown(KeyCode.F10))
        {
            ShakeCamera();
        }
        
        if (Input.GetKeyDown(KeyCode.F11))
        {
            StopShake();
        }
        
        if (Input.GetKeyDown(KeyCode.F12))
        {
            ResetZoom();
        }
    }
    
    private void OnDrawGizmosSelected()
    {
        if (!showBounds) return;
        
        // Draw camera bounds
        Gizmos.color = Color.yellow;
        Gizmos.DrawWireCube(Vector3.zero, new Vector3(cameraBoundsSize.x, cameraBoundsSize.y, 1f));
        
        // Draw camera position and target
        if (target != null)
        {
            Gizmos.color = Color.green;
            Gizmos.DrawLine(transform.position, target.position);
            Gizmos.DrawWireSphere(target.position, 0.5f);
        }
        
        // Draw offset
        if (target != null)
        {
            Gizmos.color = Color.blue;
            Gizmos.DrawWireSphere(target.position + offset, 0.3f);
        }
    }
    
    private void OnValidate()
    {
        // Ensure positive values
        followSpeed = Mathf.Max(0f, followSpeed);
        smoothTime = Mathf.Max(0f, smoothTime);
        shakeIntensity = Mathf.Max(0f, shakeIntensity);
        shakeDuration = Mathf.Max(0f, shakeDuration);
        shakeDecay = Mathf.Clamp01(shakeDecay);
        
        // Ensure zoom values are valid
        minZoom = Mathf.Max(0.1f, minZoom);
        maxZoom = Mathf.Max(minZoom, maxZoom);
        zoomSpeed = Mathf.Max(0f, zoomSpeed);
        defaultZoom = Mathf.Clamp(defaultZoom, minZoom, maxZoom);
        
        // Ensure bounds are positive
        cameraBoundsSize.x = Mathf.Max(1f, cameraBoundsSize.x);
        cameraBoundsSize.y = Mathf.Max(1f, cameraBoundsSize.y);
    }
    
    private void OnGUI()
    {
        if (!debugMode) return;
        
        // Draw camera debug info
        GUILayout.BeginArea(new Rect(Screen.width - 300, Screen.height - 400, 290, 190));
        GUILayout.Label("Camera Controller Debug");
        GUILayout.Label($"Target: {target?.name ?? "null"}");
        GUILayout.Label($"Position: {transform.position}");
        GUILayout.Label($"Shaking: {isShaking}");
        GUILayout.Label($"Zoom: {currentZoom:F2}");
        GUILayout.Label($"Bounds: {cameraBoundsSize}");
        
        if (GUILayout.Button("Shake Camera"))
        {
            ShakeCamera();
        }
        
        if (GUILayout.Button("Reset Zoom"))
        {
            ResetZoom();
        }
        
        GUILayout.EndArea();
    }
}

