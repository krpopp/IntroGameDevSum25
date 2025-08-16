using UnityEngine;

[CreateAssetMenu(fileName = "GameData", menuName = "Emergency Pizza/Game Data")]
public class GameData : ScriptableObject
{
    [Header("Game Settings")]
    public float timeLimit = 120f;
    public float temperatureUpdateRate = 5f;
    public int maxTemperatureFrames = 9;
    public float playerBaseSpeed = 2f;
    public float playerMaxSpeed = 8f;
    public float sprintRampTime = 4f;
    
    [Header("Interaction Settings")]
    public float defaultInteractionRange = 100f;
    public float clickInteractionRange = 64f;
    public LayerMask interactableLayerMask = -1;
    public LayerMask collisionLayerMask = -1;
    
    [Header("Camera Settings")]
    public float cameraFollowSpeed = 5f;
    public Vector2 cameraBounds = new Vector2(1366f, 768f);
    public float cameraShakeIntensity = 0.1f;
    public float cameraShakeDuration = 0.2f;
    
    [Header("Animation Settings")]
    public float idleAnimationSpeed = 1f;
    public float walkAnimationSpeed = 1.5f;
    public float sprintAnimationSpeed = 2f;
    
    [Header("UI Settings")]
    public float uiFadeInDuration = 0.5f;
    public float uiFadeOutDuration = 0.3f;
    public float textTypeSpeed = 0.05f;
    public float dialogueAdvanceDelay = 0.1f;
    
    [Header("Audio Settings")]
    public float masterVolume = 1f;
    public float musicVolume = 0.7f;
    public float sfxVolume = 1f;
    public float uiVolume = 0.8f;
}

