using System.Collections.Generic;

public interface IDialogueProvider
{
    string GetDialogueId();
    List<string> GetDialogueLines();
    bool HasChoices();
    List<DialogueChoice> GetChoices();
    void OnDialogueStart();
    void OnDialogueEnd();
    void OnChoiceSelected(int choiceIndex);
}

