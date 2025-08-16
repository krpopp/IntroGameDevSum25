using System;
using System.Collections.Generic;

public static class DialogueEvents
{
    public static event Action<DialogueData> OnDialogueStart;
    public static event Action OnDialogueEnd;
    public static event Action<int> OnDialogueChoice;
    public static event Action<string> OnDialogueLineChanged;
    public static event Action<bool> OnDialogueVisibilityChanged;
    public static event Action<List<DialogueChoice>> OnChoicesPresented;
    
    public static void InvokeDialogueStart(DialogueData dialogue) => OnDialogueStart?.Invoke(dialogue);
    public static void InvokeDialogueEnd() => OnDialogueEnd?.Invoke();
    public static void InvokeDialogueChoice(int choiceIndex) => OnDialogueChoice?.Invoke(choiceIndex);
    public static void InvokeDialogueLineChanged(string line) => OnDialogueLineChanged?.Invoke(line);
    public static void InvokeDialogueVisibilityChanged(bool isVisible) => OnDialogueVisibilityChanged?.Invoke(isVisible);
    public static void InvokeChoicesPresented(List<DialogueChoice> choices) => OnChoicesPresented?.Invoke(choices);
}

