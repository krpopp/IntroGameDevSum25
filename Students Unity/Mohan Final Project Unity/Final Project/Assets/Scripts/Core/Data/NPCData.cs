using UnityEngine;

public enum NPCType
{
    Dialogue,
    Choice,
    Hint,
    Special
}

[CreateAssetMenu(fileName = "NPCData", menuName = "Emergency Pizza/NPC Data")]
public class NPCData : ScriptableObject
{
    [Header("Basic Info")]
    public string npcId;
    public string displayName;
    public NPCType npcType;
    
    [Header("Visual")]
    public Sprite portrait;
    public Sprite worldSprite;
    public Color tintColor = Color.white;
    
    [Header("Interaction")]
    public float interactionRange = 100f;
    public bool requiresClick = true;
    public bool autoInteract = false;
    public float interactionCooldown = 1f;
    
    [Header("Dialogue")]
    public string defaultDialogueId;
    public string[] dialogueIds;
    public bool hasChoices = false;
    public string[] choiceDialogueIds;
    
    [Header("Behavior")]
    public bool isOneTime = false;
    public bool requiresItems = false;
    public string[] requiredItemIds;
    public bool givesItems = false;
    public string[] giveItemIds;
    public bool removesItems = false;
    public string[] removeItemIds;
    
    [Header("Conditions")]
    public bool requiresCorrectPizza = false;
    public bool requiresSpecialPizza = false;
    public bool requiresIntroSeen = false;
    public string[] requiredFlags;
    public string[] forbiddenFlags;
    
    [Header("Audio")]
    public string interactSoundId;
    public string voiceSoundId;
    
    [Header("Special Properties")]
    public bool isHiddenNPC = false;
    public bool triggersSpecialEnding = false;
    public string[] triggerEvents;
}

