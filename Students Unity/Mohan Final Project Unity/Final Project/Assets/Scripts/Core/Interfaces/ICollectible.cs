using UnityEngine;

public interface ICollectible
{
    string ItemId { get; }
    string DisplayName { get; }
    string Description { get; }
    Sprite Icon { get; }
    bool CanCollect(GameObject collector);
    void Collect(GameObject collector);
    void OnCollectStart(GameObject collector);
    void OnCollectComplete(GameObject collector);
}

