using UnityEngine;

public enum ItemType
{
    Pizza,
    Trash,
    Special,
    Tool,
    Key
}

[CreateAssetMenu(fileName = "ItemData", menuName = "Emergency Pizza/Item Data")]
public class ItemData : ScriptableObject
{
    [Header("Basic Info")]
    public string itemId;
    public string displayName;
    public string description;
    public ItemType itemType;
    
    [Header("Visual")]
    public Sprite icon;
    public Sprite worldSprite;
    public Color tintColor = Color.white;
    
    [Header("Gameplay")]
    public bool isCollectible = true;
    public bool isConsumable = false;
    public bool isStackable = false;
    public int maxStackSize = 1;
    public float interactionRange = 64f;
    
    [Header("Effects")]
    public bool affectsTemperature = false;
    public float temperatureEffect = 0f;
    public bool affectsTimer = false;
    public float timerEffect = 0f;
    
    [Header("Audio")]
    public string collectSoundId;
    public string useSoundId;
    
    [Header("Special Properties")]
    public bool isSpecialPizza = false;
    public bool triggersHiddenEnding = false;
    public string[] requiredItems;
    public string[] incompatibleItems;
}

