using UnityEngine;
using System.Collections;

public class CameraController : MonoBehaviour
{
    [Header("Camera Settings")]
    public float orthographicSize = 7f;
    public Vector3 cameraOffset = new Vector3(0, 0, -10);
    public bool followPlayer = true;
    public float smoothSpeed = 5f;

    [Header("Intro Animation")]
    public bool playIntroAnimation = true;
    public float introStartHeight = 15f;
    public float introDuration = 2.5f;
    public AnimationCurve introCurve = AnimationCurve.EaseInOut(0, 0, 1, 1);

    [Header("Debug")]
    public bool showDebugInfo = true;
    
    private Camera mainCamera;
    private Transform playerTransform;
    private Vector3 targetPosition;
    private bool introComplete = false;
    
    void Start()
    {
        mainCamera = GetComponent<Camera>();
        if (mainCamera == null)
        {
            return;
        }
        
        mainCamera.orthographic = true;
        mainCamera.orthographicSize = orthographicSize;
        
        FixCameraBlur();
        
        FindPlayer();
        
        if (playerTransform != null)
        {
            targetPosition = playerTransform.position + cameraOffset;
            
            if (playIntroAnimation)
            {
                Vector3 startPosition = playerTransform.position + new Vector3(0, introStartHeight, -10);
                transform.position = startPosition;
                StartCoroutine(PlayIntroAnimation());
            }
            else
            {
                transform.position = targetPosition;
            }
        }
    }
    
    void FindPlayer()
    {
        PlayerController player = FindFirstObjectByType<PlayerController>();
        if (player != null)
        {
            playerTransform = player.transform;
        }
    }
    
    void LateUpdate()
    {
        if (playerTransform == null)
        {
            FindPlayer();
            return;
        }
        
        if (!introComplete) return;
        
        if (!followPlayer) return;
        
        targetPosition = playerTransform.position + cameraOffset;
        
        Vector3 smoothedPosition = Vector3.Lerp(transform.position, targetPosition, smoothSpeed * Time.deltaTime);
        transform.position = smoothedPosition;
    }
    
    void OnDrawGizmosSelected()
    {
        if (!showDebugInfo) return;
        
        if (mainCamera != null && mainCamera.orthographic)
        {
            Gizmos.color = Color.yellow;
            float height = mainCamera.orthographicSize * 2;
            float width = height * mainCamera.aspect;
            
            Vector3 center = transform.position;
            Vector3 size = new Vector3(width, height, 0.1f);
            
            Gizmos.DrawWireCube(center, size);
        }
    }
    
    public void SetOrthographicSize(float newSize)
    {
        if (mainCamera != null)
        {
            mainCamera.orthographicSize = newSize;
            orthographicSize = newSize;
        }
    }
    
    private IEnumerator PlayIntroAnimation()
    {
        if (playerTransform == null) yield break;
        
        Vector3 startPosition = transform.position;
        Vector3 endPosition = playerTransform.position + cameraOffset;
        
        float elapsed = 0f;
        float duration = Mathf.Max(0.1f, introDuration);
        
        while (elapsed < duration)
        {
            elapsed += Time.deltaTime;
            float t = Mathf.Clamp01(elapsed / duration);
            float curveValue = introCurve.Evaluate(t);
            
            transform.position = Vector3.Lerp(startPosition, endPosition, curveValue);
            
            yield return null;
        }
        
        transform.position = endPosition;
        introComplete = true;
    }
    
    void OnValidate()
    {
        if (mainCamera != null)
        {
            mainCamera.farClipPlane = 1000f;
        }
    }

    void FixCameraBlur()
    {
        if (mainCamera == null) return;
        
        mainCamera.allowHDR = false;
        mainCamera.allowMSAA = false;
        mainCamera.forceIntoRenderTexture = false;
        
        QualitySettings.antiAliasing = 0;
        
        mainCamera.clearFlags = CameraClearFlags.SolidColor;
        mainCamera.backgroundColor = Color.black;
        
        mainCamera.nearClipPlane = 0.1f;
        mainCamera.farClipPlane = 1000f;
        
        
    }
}
