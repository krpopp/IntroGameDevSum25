using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class DialogueChoice
{
    public string text;
    public string nextDialogueId;
    public string[] requiredItems;
    public string[] giveItems;
    public bool endsDialogue;
    public string[] triggerEvents;
}

[System.Serializable]
public class DialogueLine
{
    public string text;
    public string speakerId;
    public float displayTime = 3f;
    public bool waitForInput = true;
    public string[] triggerEvents;
    public DialogueChoice[] choices;
}

[CreateAssetMenu(fileName = "DialogueData", menuName = "Emergency Pizza/Dialogue Data")]
public class DialogueData : ScriptableObject
{
    [Header("Basic Info")]
    public string dialogueId;
    public string speakerName;
    public bool isOneTime = false;
    public bool requiresItems = false;
    public string[] requiredItemIds;
    
    [Header("Dialogue Content")]
    public List<DialogueLine> lines = new List<DialogueLine>();
    
    [Header("Behavior")]
    public bool autoStart = false;
    public bool canBeInterrupted = true;
    public bool pauseGameplay = true;
    public float interactionCooldown = 1f;
    
    [Header("Visual")]
    public Sprite speakerPortrait;
    public Color textColor = Color.white;
    public float textSpeed = 0.05f;
    
    [Header("Audio")]
    public string voiceSoundId;
    public string startSoundId;
    public string endSoundId;
    
    [Header("Conditions")]
    public bool requiresCorrectPizza = false;
    public bool requiresSpecialPizza = false;
    public bool requiresIntroSeen = false;
    public string[] requiredFlags;
    public string[] forbiddenFlags;
}

