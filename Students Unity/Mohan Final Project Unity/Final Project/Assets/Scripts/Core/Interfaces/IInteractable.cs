using UnityEngine;

public interface IInteractable
{
    bool CanInteract(GameObject interactor);
    void Interact(GameObject interactor);
    string GetInteractionPrompt();
    float GetInteractionRange();
    bool IsInRange(GameObject interactor);
}
