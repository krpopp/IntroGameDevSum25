using UnityEngine;

public class Interactable : MonoBehaviour
{
    [Header("Interaction Settings")]
    public float interactionRange = 3f;
    public bool canInteract = true;
    
    protected virtual void Interact()
    {
        Debug.Log($"Interacting with {gameObject.name}");
    }
}
