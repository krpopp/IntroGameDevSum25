using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class InventoryItem
{
    public string itemId;
    public string displayName;
    public Sprite icon;
    public int quantity;
    public bool isStackable;
    public int maxStackSize;
    
    public InventoryItem(string id, string name, Sprite icon, int qty = 1, bool stackable = false, int maxStack = 1)
    {
        itemId = id;
        displayName = name;
        this.icon = icon;
        quantity = qty;
        isStackable = stackable;
        maxStackSize = maxStack;
    }
}

public class PlayerInventory : MonoBehaviour, IGameStateListener
{
    [Header("Inventory Settings")]
    [SerializeField] private int maxInventorySize = 10;
    [SerializeField] private bool allowOverflow = false;
    [SerializeField] private bool autoSort = true;
    
    [Header("Debug")]
    [SerializeField] private bool debugMode = false;
    [SerializeField] private bool showInventoryInInspector = true;
    
    // Inventory data
    private List<InventoryItem> items = new List<InventoryItem>();
    private Dictionary<string, InventoryItem> itemLookup = new Dictionary<string, InventoryItem>();
    
    // Events
    public System.Action<InventoryItem> OnItemAdded;
    public System.Action<InventoryItem> OnItemRemoved;
    public System.Action<InventoryItem> OnItemUsed;
    public System.Action OnInventoryChanged;
    
    private void Start()
    {
        SubscribeToEvents();
    }
    
    private void OnDestroy()
    {
        UnsubscribeFromEvents();
    }
    
    private void SubscribeToEvents()
    {
        GameEvents.OnItemCollected += OnItemCollected;
        GameEvents.OnGameRestart += ClearInventory;
    }
    
    private void UnsubscribeFromEvents()
    {
        GameEvents.OnItemCollected -= OnItemCollected;
        GameEvents.OnGameRestart -= ClearInventory;
    }
    
    // Public API
    public bool AddItem(string itemId, string displayName = "", Sprite icon = null, int quantity = 1)
    {
        if (string.IsNullOrEmpty(itemId)) return false;
        
        // Check if inventory is full
        if (!allowOverflow && items.Count >= maxInventorySize && !HasItem(itemId))
        {
            if (debugMode)
            {
                Debug.LogWarning($"Inventory is full, cannot add item: {itemId}");
            }
            return false;
        }
        
        // Check if item already exists and is stackable
        if (itemLookup.TryGetValue(itemId, out InventoryItem existingItem))
        {
            if (existingItem.isStackable)
            {
                existingItem.quantity += quantity;
                if (existingItem.quantity > existingItem.maxStackSize)
                {
                    existingItem.quantity = existingItem.maxStackSize;
                }
                
                OnItemAdded?.Invoke(existingItem);
                OnInventoryChanged?.Invoke();
                
                if (debugMode)
                {
                    Debug.Log($"Added {quantity} to existing item: {itemId} (Total: {existingItem.quantity})");
                }
                return true;
            }
            else
            {
                if (debugMode)
                {
                    Debug.LogWarning($"Cannot stack non-stackable item: {itemId}");
                }
                return false;
            }
        }
        
        // Create new item
        var newItem = new InventoryItem(itemId, displayName, icon, quantity);
        items.Add(newItem);
        itemLookup[itemId] = newItem;
        
        OnItemAdded?.Invoke(newItem);
        OnInventoryChanged?.Invoke();
        GameEvents.InvokeInventoryChanged();
        
        if (debugMode)
        {
            Debug.Log($"Added new item: {itemId} (Quantity: {quantity})");
        }
        
        return true;
    }
    
    public bool RemoveItem(string itemId, int quantity = 1)
    {
        if (!itemLookup.TryGetValue(itemId, out InventoryItem item))
        {
            if (debugMode)
            {
                Debug.LogWarning($"Item not found in inventory: {itemId}");
            }
            return false;
        }
        
        if (quantity >= item.quantity)
        {
            // Remove entire item
            items.Remove(item);
            itemLookup.Remove(itemId);
            
            OnItemRemoved?.Invoke(item);
            OnInventoryChanged?.Invoke();
            GameEvents.InvokeInventoryChanged();
            
            if (debugMode)
            {
                Debug.Log($"Removed item: {itemId}");
            }
        }
        else
        {
            // Reduce quantity
            item.quantity -= quantity;
            
            OnItemRemoved?.Invoke(item);
            OnInventoryChanged?.Invoke();
            GameEvents.InvokeInventoryChanged();
            
            if (debugMode)
            {
                Debug.Log($"Removed {quantity} from item: {itemId} (Remaining: {item.quantity})");
            }
        }
        
        return true;
    }
    
    public bool UseItem(string itemId)
    {
        if (!itemLookup.TryGetValue(itemId, out InventoryItem item))
        {
            if (debugMode)
            {
                Debug.LogWarning($"Cannot use item not in inventory: {itemId}");
            }
            return false;
        }
        
        // Check if item is consumable
        if (item.quantity <= 1)
        {
            RemoveItem(itemId);
        }
        else
        {
            item.quantity--;
        }
        
        OnItemUsed?.Invoke(item);
        GameEvents.InvokeInventoryChanged();
        
        if (debugMode)
        {
            Debug.Log($"Used item: {itemId}");
        }
        
        return true;
    }
    
    public bool HasItem(string itemId)
    {
        return itemLookup.ContainsKey(itemId);
    }
    
    public bool HasItem(string itemId, int quantity)
    {
        if (!itemLookup.TryGetValue(itemId, out InventoryItem item))
        {
            return false;
        }
        
        return item.quantity >= quantity;
    }
    
    public InventoryItem GetItem(string itemId)
    {
        itemLookup.TryGetValue(itemId, out InventoryItem item);
        return item;
    }
    
    public int GetItemQuantity(string itemId)
    {
        if (itemLookup.TryGetValue(itemId, out InventoryItem item))
        {
            return item.quantity;
        }
        return 0;
    }
    
    public List<InventoryItem> GetAllItems()
    {
        return new List<InventoryItem>(items);
    }
    
    public List<string> GetAllItemIds()
    {
        return new List<string>(itemLookup.Keys);
    }
    
    public void ClearInventory()
    {
        items.Clear();
        itemLookup.Clear();
        
        OnInventoryChanged?.Invoke();
        GameEvents.InvokeInventoryChanged();
        
        if (debugMode)
        {
            Debug.Log("Inventory cleared");
        }
    }
    
    public void SortInventory()
    {
        if (!autoSort) return;
        
        items.Sort((a, b) => string.Compare(a.displayName, b.displayName));
        
        if (debugMode)
        {
            Debug.Log("Inventory sorted");
        }
    }
    
    public void SetMaxInventorySize(int size)
    {
        maxInventorySize = size;
        
        // Remove excess items if needed
        while (items.Count > maxInventorySize)
        {
            var lastItem = items[items.Count - 1];
            RemoveItem(lastItem.itemId);
        }
    }
    
    public void SetAllowOverflow(bool allow)
    {
        allowOverflow = allow;
    }
    
    public void SetAutoSort(bool auto)
    {
        autoSort = auto;
    }
    
    // Utility methods
    public int GetItemCount()
    {
        return items.Count;
    }
    
    public int GetTotalItemCount()
    {
        int total = 0;
        foreach (var item in items)
        {
            total += item.quantity;
        }
        return total;
    }
    
    public bool IsInventoryFull()
    {
        return items.Count >= maxInventorySize;
    }
    
    public float GetInventoryFullness()
    {
        return (float)items.Count / maxInventorySize;
    }
    
    // Special item checks
    public bool HasPizza()
    {
        return HasItem("meat_pizza") || HasItem("vegan_pizza") || HasItem("special_pizza");
    }
    
    public bool HasCorrectPizza(string correctPizzaType)
    {
        if (correctPizzaType == "meat")
        {
            return HasItem("meat_pizza") && !HasItem("vegan_pizza");
        }
        else if (correctPizzaType == "vegan")
        {
            return HasItem("vegan_pizza") && !HasItem("meat_pizza");
        }
        return false;
    }
    
    public bool HasSpecialPizza()
    {
        return HasItem("special_pizza");
    }
    
    public string GetPizzaType()
    {
        if (HasItem("special_pizza")) return "special";
        if (HasItem("meat_pizza")) return "meat";
        if (HasItem("vegan_pizza")) return "vegan";
        return "";
    }
    
    // IGameStateListener implementation
    public void OnGameStateChanged(GameState newState) { }
    public void OnTimerChanged(float timeRemaining) { }
    public void OnTemperatureChanged(int temperatureFrame) { }
    public void OnItemCollected(string itemId) => AddItem(itemId);
    public void OnGameSuccess() { }
    public void OnGameFailure() { }
    
    // Debug
    private void OnValidate()
    {
        if (showInventoryInInspector && debugMode)
        {
            // This will show the inventory in the inspector when in debug mode
        }
    }
    
    private void OnGUI()
    {
        if (!debugMode || !showInventoryInInspector) return;
        
        // Draw inventory debug info
        GUILayout.BeginArea(new Rect(10, 10, 300, 200));
        GUILayout.Label("Player Inventory Debug");
        GUILayout.Label($"Items: {items.Count}/{maxInventorySize}");
        GUILayout.Label($"Total Items: {GetTotalItemCount()}");
        
        foreach (var item in items)
        {
            GUILayout.Label($"{item.displayName}: {item.quantity}");
        }
        
        GUILayout.EndArea();
    }
}

