using System;
using UnityEngine;

public static class GameEvents
{
    // Game State Events
    public static event Action<GameState> OnGameStateChanged;
    public static event Action<float> OnTimeChanged;
    public static event Action<int> OnTemperatureChanged;
    public static event Action<string> OnItemCollected;
    public static event Action OnGameSuccess;
    public static event Action OnGameFailure;
    public static event Action OnGameRestart;
    
    // Player Events
    public static event Action<Vector2> OnPlayerMove;
    public static event Action<bool> OnPlayerSprint;
    public static event Action<GameObject> OnPlayerInteract;
    public static event Action<string> OnPlayerCollect;
    
    // Dialogue Events
    public static event Action<string> OnDialogueStart;
    public static event Action OnDialogueEnd;
    public static event Action<int> OnDialogueChoice;
    public static event Action<string> OnDialogueNext;
    // Input aliases used by some UI/Dialogue scripts
    public static event Action OnAdvanceInput;
    public static event Action<int> OnChoiceInput;
    
    // UI Events
    public static event Action<bool> OnUIVisibilityChanged;
    public static event Action<string> OnUITextChanged;
    public static event Action OnUIUpdate;
    public static event Action OnInventoryChanged;
    
    // Audio Events
    public static event Action<string> OnPlaySound;
    public static event Action<string> OnPlayMusic;
    public static event Action OnStopMusic;
    
    // Scene Events
    public static event Action<string> OnSceneLoad;
    public static event Action<string> OnSceneUnload;
    
    // Helper methods to invoke events
    public static void InvokeGameStateChanged(GameState newState) => OnGameStateChanged?.Invoke(newState);
    public static void InvokeTimeChanged(float timeRemaining) => OnTimeChanged?.Invoke(timeRemaining);
    public static void InvokeTemperatureChanged(int temperatureFrame) => OnTemperatureChanged?.Invoke(temperatureFrame);
    public static void InvokeItemCollected(string itemId) => OnItemCollected?.Invoke(itemId);
    public static void InvokeGameSuccess() => OnGameSuccess?.Invoke();
    public static void InvokeGameFailure() => OnGameFailure?.Invoke();
    public static void InvokeGameRestart() { OnGameRestart?.Invoke(); OnRestartInput?.Invoke(); }
    
    public static void InvokePlayerMove(Vector2 direction) => OnPlayerMove?.Invoke(direction);
    public static void InvokePlayerSprint(bool isSprinting) => OnPlayerSprint?.Invoke(isSprinting);
    public static void InvokePlayerInteract(GameObject interactable) => OnPlayerInteract?.Invoke(interactable);
    public static void InvokePlayerCollect(string itemId) => OnPlayerCollect?.Invoke(itemId);
    
    public static void InvokeDialogueStart(string dialogueId) => OnDialogueStart?.Invoke(dialogueId);
    public static void InvokeDialogueEnd() => OnDialogueEnd?.Invoke();
    public static void InvokeDialogueChoice(int choiceIndex) { OnDialogueChoice?.Invoke(choiceIndex); OnChoiceInput?.Invoke(choiceIndex); }
    public static void InvokeDialogueNext(string nextLine) { OnDialogueNext?.Invoke(nextLine); OnAdvanceInput?.Invoke(); }
    
    public static void InvokeUIVisibilityChanged(bool isVisible) => OnUIVisibilityChanged?.Invoke(isVisible);
    public static void InvokeUITextChanged(string newText) => OnUITextChanged?.Invoke(newText);
    public static void InvokeUIUpdate() => OnUIUpdate?.Invoke();
    public static void InvokeInventoryChanged() => OnInventoryChanged?.Invoke();
    
    public static void InvokePlaySound(string soundId) => OnPlaySound?.Invoke(soundId);
    public static void InvokePlayMusic(string musicId) => OnPlayMusic?.Invoke(musicId);
    public static void InvokeStopMusic() => OnStopMusic?.Invoke();
    
    public static void InvokeSceneLoad(string sceneName) => OnSceneLoad?.Invoke(sceneName);
    public static void InvokeSceneUnload(string sceneName) => OnSceneUnload?.Invoke(sceneName);
    
    // Additional input alias for restart used by some UI
    public static event Action OnRestartInput;
}

